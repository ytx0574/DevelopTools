//
//  SelectAlbumHelper.m
//  MKT
//
//  Created by Mac Xu on 14-2-22.
//  Copyright (c) 2014年 Mac Xu. All rights reserved.
//

#import "SelectAlbumHelper.h"
#import "AGImagePickerController.h"
#import "AGIPCToolbarItem.h"
#import <AVFoundation/AVFoundation.h>

#import "BaseNVC.h"

#define AlertTips(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]


@interface SelectAlbumHelper () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, copy) void(^systemPhotosSelectImagecomplete)(BOOL havePhotosPermission, UIImage *image);
@property (nonatomic, assign) BOOL isEditeImage;
@end

@implementation SelectAlbumHelper

+ (instancetype)shareInstance{
    
    static SelectAlbumHelper *shareInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    return shareInstance;
}

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}


+ (void)getImagesWithMaxNumberOfToBeSelected:(NSInteger)maxNum viewController:(UIViewController *)viewController complete:(void(^)(NSArray *images))complete;
{
    
    AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return YES;
    }];
    AGIPCToolbarItem *flexible = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] andSelectionBlock:nil];
    
    AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Deselect All" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return NO;
    }];
    
    
    
    __weak UIViewController *vc = viewController;
    AGImagePickerController *imagepicker = [[AGImagePickerController alloc] initWithDelegate:self failureBlock:^(NSError *error) {
        
        [vc dismissViewControllerAnimated:YES completion:nil];
    } successBlock:^(NSArray *info) {
        
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        [info enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [photos addObject:[SelectAlbumHelper fullResolutionImageFromALAsset:obj]];
        }];
        
        complete ? complete(photos) : nil;
        [vc dismissViewControllerAnimated:YES completion:nil];
    } maximumNumberOfPhotosToBeSelected:maxNum shouldChangeStatusBarStyle:YES toolbarItemsForManagingTheSelection:@[selectAll, flexible, flexible, deselectAll] andShouldShowSavedPhotosOnTop:NO];
    
    [viewController presentViewController:imagepicker animated:YES completion:nil];
    
}


+ (void)getImageWithSourceType:(UIImagePickerControllerSourceType)sourceType editeImage:(BOOL)editeImage viewController:(UIViewController *)viewController complete:(void(^)(BOOL havePhotosPermission, UIImage *image))complete;
{
    //检测相册访问权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied) {
        AlertTips(@"设置->隐私->照片\n请开启访问相册权限");
        complete ? complete(NO, nil) : nil;
        return;
    }
    
    if ((([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? YES : NO)) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == ALAuthorizationStatusDenied) {
            AlertTips(@"设置->隐私->照片\n请开启访问相册权限");
            complete ? complete(NO, nil) : nil;
            return;
        }
    }
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera && [[NSObject getDeviceType] isEqualToString:@"iPhone Simulator"]) {
        AlertTips(@"模拟器不能拍照,请使用手机调试");
        complete ? complete(NO, nil) : nil;
        return;
    }
    
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.allowsEditing = YES;
    imagepicker.sourceType = sourceType;
    imagepicker.delegate = [SelectAlbumHelper shareInstance];
    
    [SelectAlbumHelper shareInstance].systemPhotosSelectImagecomplete = complete;
    [SelectAlbumHelper shareInstance].isEditeImage = editeImage;
    [viewController presentViewController:imagepicker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.isEditeImage) {
            self.systemPhotosSelectImagecomplete ? self.systemPhotosSelectImagecomplete(YES, [info objectForKey:UIImagePickerControllerEditedImage]) : nil;
        }else {
            self.systemPhotosSelectImagecomplete ? self.systemPhotosSelectImagecomplete(YES, [info objectForKey:UIImagePickerControllerOriginalImage]) : nil;
        }
        
    });
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end