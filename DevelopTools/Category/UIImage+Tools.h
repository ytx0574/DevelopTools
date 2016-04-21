//
//  UIImage+Comm.h
//  testone
//
//  Created by Jackalsen on 13-8-29.
//  Copyright (c) 2013年 dr。xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

//从原image上指定rect截取
- (UIImage *)getSubImage:(CGRect)rect;
//将原image以做成3：2的比例（原图为方形）
- (UIImage *)getSubImage3_2;
//传入size,可以将当前UIImage原比例缩放
- (instancetype)imageByScalingAndCroppingForSize:(CGSize)targetSize;
//直接压缩Image
- (instancetype)compressedImage;
//得到压缩比(<50000 ? 1:1-50000/length)
- (CGFloat)compressionQuality;
//压缩 (临界值为50000)
- (NSData *)compressedData;
//指定比例压缩;
- (NSData *)compressedData:(CGFloat)compressionQuality;
//毛玻璃效果
- (instancetype)blurredImage:(CGFloat)blurAmount;


//水印加文字
+ (instancetype)addText:(UIImage *)img text:(NSString *)text;
//水印加图片
+ (instancetype)addImageLogo:(UIImage *)img text:(UIImage *)logo;
//半透明水印
+ (instancetype)addImage:(UIImage *)useImage addImage1:(UIImage *)addImage;
//图片拉升
+ (instancetype)image:(UIImage*)img stretchW:(NSInteger)w stretchH:(NSInteger)h;
//color to image
+ (instancetype)imageWithColor:(UIColor *)color Size:(CGSize)size;
//1、生成图片的大小 2、压缩比 3、存放图片的路径
+ (instancetype)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath;

+ (instancetype)scale:(UIImage *)image toSize:(CGSize)size;
//截取imageview.image
+ (instancetype)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height;

/**
 *  截屏
 *
 *  @param frame 截屏矩阵
 *
 *  @return image
 */
+ (instancetype)captureScreen:(CGRect)frame;
/**
 *  从main bundle加载图片
 *
 *  @param fileName mainbundle中的文件名
 *
 *  @return image
 */
+ (instancetype)loadImageFromMainBundleWithFileName:(NSString *)fileName;

/**
 *  从bundle中加载图片
 *
 *  @param bundle   bundle名称
 *  @param fileName bundle中的文件名
 *
 *  @return image
 */
+ (instancetype)loadImageFormBundle:(NSBundle *)bundle fileName:(NSString *)fileName;

@end
