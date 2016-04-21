//
//  hp.h
//  MKT
//
//  Created by Mac Xu on 14-2-22.
//  Copyright (c) 2014年 Mac Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^InfoBlock)(UIImage *image);

@interface SelectAlbum : NSObject
/**
 *  单例
 *
 *  @return 返回实例
 */
+ (instancetype)getInstance;
/**
 *  从本地相册里面多选图片
 *
 *  @param block      回调的image数组
 */
+ (void)getImagesFromAlbumPhotosBlock:(void (^)(NSMutableArray *photos))block;
/**
 *  从本地相册获取一张图片或者拍一张照片
 *
 *  @param sourceType 打开类型
 *  @param editeImage 是否可编辑
 *  @param block      回调并返回选中的image
 */
- (void)getImageFromSourceType:(UIImagePickerControllerSourceType)sourceType EditedImage:(BOOL)editeImage Image:(InfoBlock)block;

@end
