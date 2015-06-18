//
//  UIImage+Comm.h
//  testone
//
//  Created by Jackalsen on 13-8-29.
//  Copyright (c) 2013年 dr。xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)
//水印加文字
+ (UIImage *)addText:(UIImage *)img text:(NSString *)text;
//水印加图片
+ (UIImage *)addImageLogo:(UIImage *)img text:(UIImage *)logo;
//半透明水印
+ (UIImage *)addImage:(UIImage *)useImage addImage1:(UIImage *)addImage;
//图片拉升
+ (UIImage*)image:(UIImage*)img stretchW:(NSInteger)w stretchH:(NSInteger)h;
//color to image
+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size;
//1、生成图片的大小 2、压缩比 3、存放图片的路径
+ (UIImage *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath;
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
//传入size,可以将当前UIImage原比例缩放
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
//直接压缩Image
- (UIImage *)compressedImage;
//得到压缩比(<50000 ? 1:1-50000/length)
- (CGFloat)compressionQuality;
//压缩 (临界值为50000)
- (NSData *)compressedData;
//指定比例压缩;
- (NSData *)compressedData:(CGFloat)compressionQuality;
//截取imageview.image
+ (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height;
/**
 *  毛玻璃效果
 *
 *  @param blurAmount 0 - 1 之间
 *
 *  @return image
 */
- (UIImage*)blurredImage:(CGFloat)blurAmount;
/**
 *  截图 (从0,0开始截取)
 *
 *  @param frame 截图大小
 *
 *  @return <#return value description#>
 */
+ (UIImage *)captureScreen:(CGRect)frame;

@end
