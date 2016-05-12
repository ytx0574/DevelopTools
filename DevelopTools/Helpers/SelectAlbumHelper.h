//
//  SelectAlbumHelper.h
//  MKT
//
//  Created by Mac Xu on 14-2-22.
//  Copyright (c) 2014年 Mac Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectAlbumHelper : NSObject

/**
 *  从本地相册里面多选图片
 *
 *  @param block      回调的image数组
 */
+ (void)getImagesWithMaxNumberOfToBeSelected:(NSInteger)maxNum viewController:(UIViewController *)viewController complete:(void(^)(NSArray *images))complete;

/**
 *  从本地相册获取一张图片或者拍一张照片
 *
 *  @param sourceType 打开类型
 *  @param editeImage 是否可编辑
 *  @param block      回调并返回选中的image
 */
+ (void)getImageWithSourceType:(UIImagePickerControllerSourceType)sourceType editeImage:(BOOL)editeImage viewController:(UIViewController *)viewController complete:(void(^)(BOOL havePhotosPermission, UIImage *image))complete;

@end