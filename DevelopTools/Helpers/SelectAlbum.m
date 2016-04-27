//
//  hp.m
//  MKT
//
//  Created by Mac Xu on 14-2-22.
//  Copyright (c) 2014年 Mac Xu. All rights reserved.
//

#import "SelectAlbum.h"
#import "AGImagePickerController.h"
#import "AGIPCToolbarItem.h"
#import <AVFoundation/AVFoundation.h>

#import "BaseNVC.h"

#define AlertTips(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]

static SelectAlbum *shareInstance;

@interface SelectAlbum ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,copy)InfoBlock aBlock;
@property (nonatomic,assign) BOOL isEditeImage;
@end

@implementation SelectAlbum

+ (instancetype)getInstance{
    if (!shareInstance) {
        shareInstance = [[[self class] alloc]init];
    }
    return shareInstance;
}

+ (void)getImagesFromAlbumPhotosBlock:(void (^)(NSMutableArray *photos))block
{
    __block NSMutableArray *photos = [[NSMutableArray alloc]init];
    AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return YES;
    }];
    AGIPCToolbarItem *flexible = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] andSelectionBlock:nil];
    
//    AGIPCToolbarItem *selectOdd = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"      " style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
//        return !(index % 2);
//    }];
    AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Deselect All" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return NO;
    }];
    
    AGImagePickerController *imagepicker = [[AGImagePickerController alloc]initWithDelegate:self failureBlock:^(NSError *error) {
    
//        [ROOTNAVIGATIONCONROLLER.viewControllers.lastObject dismissViewControllerAnimated:YES completion:nil];
    } successBlock:^(NSArray *info) {
        [info enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [photos addObject:[SelectAlbum fullResolutionImageFromALAsset:obj]];
        }];
        block(photos);
//        [ROOTNAVIGATIONCONROLLER.viewControllers.lastObject dismissViewControllerAnimated:YES completion:nil];
    } maximumNumberOfPhotosToBeSelected:100 shouldChangeStatusBarStyle:YES toolbarItemsForManagingTheSelection:@[selectAll, flexible, flexible, deselectAll] andShouldShowSavedPhotosOnTop:YES];
//    [ROOTNAVIGATIONCONROLLER.viewControllers.lastObject presentViewController:imagepicker animated:YES completion:nil];
    
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

- (void)getImageFromSourceType:(UIImagePickerControllerSourceType)sourceType EditedImage:(BOOL)editeImage Image:(InfoBlock)block;
{
    //检测相册访问权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied) {
        AlertTips(@"设置->隐私->照片\n请开启访问相册权限");
        return;
    }
    if ((([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? YES : NO)) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == ALAuthorizationStatusDenied) {
           AlertTips(@"设置->隐私->照片\n请开启访问相册权限");
            return;
        }
    }

    if (sourceType == UIImagePickerControllerSourceTypeCamera && [[NSObject getDeviceType] isEqualToString:@"iPhone Simulator"]) {
        AlertTips(@"模拟器不能拍照,请使用手机调试");
        return;
    }
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.allowsEditing = YES;
    [[SelectAlbum getInstance] setABlock:block];
    [[SelectAlbum getInstance] setIsEditeImage:editeImage];
    imagepicker.sourceType = sourceType;
    imagepicker.delegate = self;

//    [ROOTNAVIGATIONCONROLLER.viewControllers.lastObject presentViewController:imagepicker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isEditeImage ? self.aBlock([info objectForKey:UIImagePickerControllerEditedImage]) : self.aBlock([info objectForKey:UIImagePickerControllerOriginalImage]);
    });
    shareInstance = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    shareInstance = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
