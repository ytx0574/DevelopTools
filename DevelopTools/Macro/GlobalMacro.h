//
//  GlobalMacro.h
//  uBing
//
//  Created by Johnson on 14-6-16.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#pragma mark - DEBUG
#ifdef  DEBUG

#define NSLog(FORMAT, ...)                       fprintf(stderr,"\nfunction:%s line:%d content:\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define ALERT_LOG(msg)                           [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]

#define DEALLOC_LOG                              NSLog(@"◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊ dealloc Class:%@\n %@",self, NO ?  [NSString stringWithFormat:@"Class_Information:%@", [self Log:NO]] : EMPTY_STRING);

#else

#define NSLog(FORMAT, ...) nil;
#define ALERT_LOG(msg)
#define DEALLOC_LOG

#endif


#pragma mark - Syetem
/**是否是模拟器*/
#define iPhoneSimulator                           [[self getDeviceType] isEqualToString:@"iPhone Simulator"]

/**传入参数判断系统是哪个版本*/
#define iOS_SYSTEM_VERSION(version) [[[UIDevice currentDevice] systemVersion] hasPrefix:[NSString stringWithFormat:@"%d",version]]
/**传入参数,判断系统版本是多少,及以后*/
#define iOS_SYSTEM_LATER(version)   (([[[UIDevice currentDevice] systemVersion] floatValue] >= version) ? YES : NO)
/**版本不一致的代码*/
#define MATCHING_SYSTEM_VERSION_CODE_LATER_ADN_EARLIER(isVersionLater, later, earlier)   if (isVersionLater){later;}else{earlier;}
/**iOS 8 7 6  的判定*/
#define iOS9                 (iOS_SYSTEM_VERSION(9) ? YES : NO)
#define iOS8                 (iOS_SYSTEM_VERSION(8) ? YES : NO)
#define iOS7                 (iOS_SYSTEM_VERSION(7) ? YES : NO)
#define iOS6                 (iOS_SYSTEM_VERSION(6) ? YES : NO)
#define iOS7_AND_LATER       (iOS_SYSTEM_LATER(7) ? YES : NO)
#define iOS8_AND_LATER       (iOS_SYSTEM_LATER(8) ? YES : NO)

#define FONT(size)           [UIFont systemFontOfSize:size]
#define BOLDFONT(size)       [UIFont boldSystemFontOfSize:size]


#pragma mark - System class or path
/**KEYWINDOW对象*/
#define KEY_WINDOW                      [[UIApplication sharedApplication] keyWindow]
/**AppDelegate对象*/
#define APPDELEGATE_INSTANCE            ((AppDelegate *)[[UIApplication sharedApplication] delegate])
/**AppDelegate的window对象*/
#define APPDELEGATE_WINDOW              [[[UIApplication sharedApplication] delegate] window]
/**App主目录   可见子目录(3个):Documents、Library、tmp*/
#define APP_PATH                        NSHomeDirectory()
/**Documents路径   文档目录(ITUNES要同步)*/
#define APP_DOCUMENTS_PATH              [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
/**Library路径   资源目录*/
#define APP_LIBRARY_PATH                [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
/**Library/Caches   资源缓存(ITUNES不同步)*/
#define APP_LIBRARY_CACHES_PATH         [APP_LIBRARY_PATH stringByAppendingPathComponent:@"/Caches"]
/**Library/Preferences  配置目录(ITUNES要同步)*/
#define APP_LIBRARY_PREFERENCES_PATH    [APP_LIBRARY_PATH stringByAppendingPathComponent:@"/Preferences"]
/**tmp目录   缓存目录(ITUNES不同步,程序退出后自动清空)*/
#define APP_TMP_PATH                    [NSHomeDirectory() stringByAppendingFormat:@"/tmp"]


#pragma mark - View frame
/**状态栏高度*/
#define STATUSBAR_HEIGHT                          20
/**工具栏高度*/
#define TABBAR_HEIGHT                             49
/**导航栏高度*/
#define NAVIGATIONBAR_HEIGHT                      44
/**融合高度*/
#define FUSIONNAVIGATIONBAR_HEIGHT                64
/**屏幕 宽高*/
#define SCREEN_WIDTH                              [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                             [[UIScreen mainScreen] bounds].size.height
/**判断屏幕大小*/
#define isSizeOf_3_5                              (SCREEN_HEIGHT == 480 ? YES : NO)
#define isSizeOf_4_0                              (SCREEN_HEIGHT == 568 ? YES : NO)
#define isSizeOf_4_7                              (SCREEN_HEIGHT == 667 ? YES : NO)
#define isSizeOf_5_5                              (SCREEN_HEIGHT == 736 ? YES : NO)
#define iSWidth320                                (SCREEN_WIDTH == 320 ? YES : NO)

#define RECT(x, y, width, height)                        (CGRect){x, y, width, height}
#define RECT_ORIGIN(origin, width, height)               (CGRect){origin, width, height}
#define RECT_SIZE(x, y, size)                            (CGRect){x, y, size}
#define RECT_ORIGIN_SIZE(origin, size)                   (CGRect){origin, size}

#define ORIGIN(view)                                     (view.frame.origin)
#define SIZE(view)                                       (view.frame.size)
#define FRAME(view)                                      (view.frame)
#define ORIGIN_X(view)                                   (view.frame.origin.x)
#define ORIGIN_Y(view)                                   (view.frame.origin.y)
#define SIZE_W(view)                                     (view.frame.size.width)
#define SIZE_H(view)                                     (view.frame.size.height)

#define ORIGIN_Y_ADD_SIZE_H(view)                        (ORIGIN_Y(view) + SIZE_H(view))
#define ORIGIN_X_ADD_SIZE_W(view)                        (ORIGIN_X(view) + SIZE_W(view))

/**重置frame*/
#define RESET_FRAME_ORIGIN_X(view, x)                    view.frame = (CGRect){x, ORIGIN_Y(view), SIZE_W(view), SIZE_H(view)}
#define RESET_FRAME_ORIGIN_Y(view, y)                    view.frame = (CGRect){ORIGIN_X(view), y, SIZE_W(view), SIZE_H(view)}
#define RESET_FRAME_SIZE_WIDTH(view, width)              view.frame = (CGRect){ORIGIN_X(view), ORIGIN_Y(view), width, SIZE_H(view)}
#define RESET_FRAME__SIZE_HEIGHT(view, height)           view.frame = (CGRect){ORIGIN_X(view), ORIGIN_Y(view), SIZE_W(view), height}

/**原始比例缩放宽高*/
#define RESET_FRAME_SIZE_WIDTH_FROM_ORIGINAL(view)       view.frame = (CGRect){ORIGIN_X(view), ORIGIN_Y(view), SCREEN_SCALE_WIDTH(SIZE_W(view)), SIZE_H(view)}
/**根据宽高设置方形*/
#define RESET_FRAME_SQUARE_FROM_WIDTH(view)              view.frame = (CGRect){ORIGIN_X(view), ORIGIN_Y(view), SIZE_W(view), SIZE_W(view)}
/**比例设置矩形*/
#define RESET_FRAME_HEIGHT_FROM_WIDTH(view)              JUDGE_IF(view.sizeRatio.floatValue == 0.f, NSLog(@"默认比例未设置"); return;) \
view.frame = (CGRect){ORIGIN_X(view), ORIGIN_Y(view), SIZE_W(view), SIZE_W(view) / view.sizeRatio.floatValue}
/**原始比例缩放宽度, 并设置高度*/
#define RESET_FRAME_SIZE_WIDTH_FROM_ORIGINAL_AND_SET_TATIO_HEIGHT(view) \
RESET_FRAME_SIZE_WIDTH_FROM_ORIGINAL(view);\
RESET_FRAME_HEIGHT_FROM_WIDTH(view)


#pragma mark - SetValue
/**设置颜色值*/
#define RGB(r,g,b)                                     [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
/**空字符串*/
#define EMPTY_STRING                                   @""
#define SetStringValue(value)                          (!value || [value isEqual:[NSNull null]]) ? EMPTY_STRING : value
/**失去第一响应者*/
#define RESIGN_FIRST_RESPONDER                         [[UIApplication sharedApplication].keyWindow endEditing:YES]
/**得到字符串的像素矩阵*/
//#define STRING_WITH_SIZE_AND_DEFAULT_HEIGHT(string, font, width) (iOS7_AND_LATER ? [string boundingRectWithSize:CGSizeMake(width, NSIntegerMax) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size : [string sizeWithFont:font constrainedToSize:CGSizeMake(width, NSIntegerMax)])
#define STRING_WITH_SIZE_AND_DEFAULT_HEIGHT(string, font, width) ([string boundingRectWithSize:CGSizeMake(width, NSIntegerMax) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size)

/**获取main bundle*/
#define MAIN_BUNDLE                                    [NSBundle mainBundle]
/**获取main bundle文件路径*/
#define MAIN_BUNDLE_FILE_PATH(fileName, extension)     [MAIN_BUNDLE pathForResource:fileName ofType:extension]
/**根据文件名获取bundle对象*/
#define BUNDLE_WITH_NAME(fileName)                     [[NSBundle alloc] initWithPath:MAIN_BUNDLE_FILE_PATH(fileName, @"bundle")]
/**加载图片  内存*/
#define LOAD_IMAGE(fileName)                           [UIImage imageNamed:fileName]
//**加载图片(bundle中获取自动添加png后缀)  从文件加载*/
#define LOAD_IMAGE_FROM_MAIN_BUNDLE(fileName)          [UIImage loadImageFromMainBundleWithFileName:fileName]
#define LOAD_IMAGE_FROM_BUNDLE(bundleName, fileName_)   [UIImage loadImageFormBundle:BUNDLE_WITH_NAME(bundleName) fileName:fileName_]
/**加载原图image*/
#define LOAD_IMAGE_WITH_ORIGINAL(image)                [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

/**方便SDWebImage传入URL*/

//#define LOAD_IMAGE_WITH_FILE_FROM_BUNDLE(filename)     [UIImage imageWithContentsOfFile:MAIN_BUNDLE_FILE_PATH(MAIN_BUNDLE_FILE_PATH(filename, @"png") ? filename : [filename stringByAppendingString:@"@2x"], @"png")]

/**加载图片  从文件加载*/
#define LOAD_IMAGE_WITH_FILE_PATH(path)                [UIImage imageWithContentsOfFile:path]
/**设置数组值.*/
#define SET_ARRAY(_arrayWith__, tempArray)                                  _arrayWith__ = [NSArray arrayWithArray:tempArray]
#define SET_MUTABLEARRAY(_arrayWith__, tempArray)                           _arrayWith__ = [NSMutableArray arrayWithArray:tempArray]
/**设置字典值.*/
#define SET_DICATIONARY(_dicationaryWith__, tempDicationary)                _dicationaryWith__ = [NSDicationary dictionaryWithDictionary:tempDicationary]
#define SET_MUTABLEDICATIONARY(_dicationaryWith__, tempDicationary)         _dicationaryWith__ = [NSMutableDicationary dictionaryWithDictionary:tempDicationary]

/**TempClass*/
#define TempClass(class_name)   \
@interface class_name : UIView\
\
@end\
\
@implementation class_name\
\
- (void)setNeedsDisplay\
{\
[super setNeedsDisplay];\
NSString *className = [NSStringFromClass([self class]) substringFromIndex:1];\
NSLog(@"TempView->          %@", className);\
if (![self.subviews.lastObject isKindOfClass:NSClassFromString(className)]) {\
UIView *view = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil].lastObject;\
view.frame = RECT_ORIGIN_SIZE(CGPointZero, SIZE(self));\
[self addSubview:view];\
}\
}\
@end

/** va_list_parameters */
#define  GetVariableParameterWithMutableArray(theFirstParameterValue, arrayWithParameter)     \
NSMutableArray *arrayWithParameter = [NSMutableArray array];\
if (theFirstParameterValue) {\
va_list list;\
va_start(list, theFirstParameterValue);\
[arrayWithParameter addObject:theFirstParameterValue];\
NSObject *value = va_arg(list, id);\
while (value) {\
value ? [arrayWithParameter addObject:value] : nil;\
value = va_arg(list, id);\
}\
va_end(list);\
}\


#pragma mark - Calculate

#define OnePixelSize                                     CGSizeMake(1 , 1)
/**判断一个对象是否为nil  不为nil返回YES*/
#define IS_NOT_nil(class)                                (class != nil ? YES : NO)
/**判断一个对象是否为null 不为null返回YES*/
#define IS_NOT_null(class)                               ([class isEqual:[NSNull null]] ? NO : YES)
/**判断一个对象是否存在  即不等于nil也不为null才返回YES*/
#define IS_NOT_nilANDnull(class)                         ((class == nil || [class isEqual:[NSNull null]]) ? NO : YES)
/**判断字符串(仅限字符串)      即不等于nil也不为null也不为@""才返回YES */
#define IS_NOT_nilORnullOREmptyString(class)             ((class == nil || [class isEqual:[NSNull null]] || [class isEqualToString:EMPTY_STRING]) ? NO : YES)
/**if 判定*/
#define JUDGE_IF(condition, contentWithTrue)                           if (condition) {contentWithTrue;}
/**if else 判定*/
#define JUDGE_IF_ELSE(condition, contentWithTrue, contentWithFalse)    if (condition) {contentWithTrue;}else {contentWithFalse;}
/**条件满足 ruturn*/
#define IF_RETURN(condition)                                           if (condition) {return;}


#pragma mark - Assist
/**强制转换*/
#define CONVERTION_TYPE(classType, object)           ((classType *)object)
/**普通类型直接转为字符串*/
#define STRINGFORMAT(value)                          [NSString stringWithFormat:@"%@", value]
#if __LP64__
#define STRINGFORMATWITH_INT(value)              [NSString stringWithFormat:@"%ld", value]
#else
#define STRINGFORMATWITH_INT(value)              [NSString stringWithFormat:@"%d", value]
#endif

//alert提示
#define ShowTitleAlert(title, msg)                   [self showAlert:title message:msg delay:1];
#define ShowTipsAlert(msg)                           [self showAlert:@"提示" message:msg delay:1];
#define ShowAlert(msg)                               [self showAlert:nil message:msg delay:1];
#define ShowAlertComplete(msg, code)                 [self showAlert:nil message:msg delay:1 complete:^{(code);}];
#define ShowTipsAlertComplete(msg, code)             [self showAlert:@"提示" message:msg delay:1 complete:^{(code);}];

#define Alert(title, msg, buttonTitle)               [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil, nil] show]
#define AlertTitleMsgOk(title, msg)                  Alert(title, msg, @"确定")
#define AlertMsgOk(msg)                              Alert(@"提示", msg, @"确定")

#define SVShowStatus(msg)                            [SVProgressHUD showWithStatus:msg]
#define SVDismiss                                    [SVProgressHUD dismiss];
#define SVShowError(msg)                             [SVProgressHUD showErrorWithStatus:msg]
#define SVShowSuccess(msg)                           [SVProgressHUD showSuccessWithStatus:msg]

#define WEAK_SELF                                    typeof(self) __weak wself = self;
#define PerformInBackground(code)                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{ code; });
#define PerformInBackgroundAndPerformMainQueue(perfromInBackgroundCode, perfromInMainCode) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{\
perfromInBackgroundCode;\
dispatch_sync(dispatch_get_main_queue(), ^{ \
perfromInMainCode; \
});});





#pragma mark - IgnoreWarning (慎用)
#define IgnoreWarningDeprecatedDeclarations(code)
#pragma clang diagnostic push\
#pragma clang diagnostic ignored "-Wdeprecated-declarations" \
code;\
#pragma clang diagnostic pop

#define IgnoreWarningIncompatiblePointer(code)
#pragma clang diagnostic push\
#pragma clang diagnostic ignored "-Wincompatible-pointer-types" \
code;\
#pragma clang diagnostic pop

#define IgnoreWarningRetainCycles(code)
#pragma clang diagnostic push\
#pragma clang diagnostic ignored "-Warc-retain-cycles" \
code;\
#pragma clang diagnostic pop

#define IgnoreWarningUnusedVariable(code)
#pragma clang diagnostic push\
#pragma clang diagnostic ignored "-Wunused-variable" \
code;\
#pragma clang diagnostic pop

#define IgnoreWarningProtocolMethodImplementation(code)
#pragma clang diagnostic push\
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation" \
code;\
#pragma clang diagnostic pop

#pragma mark - Algorithm Maybe Changed
#define SCREEN_SCALE_WIDTH(width)                 (width * (SCREEN_WIDTH / 375.f))
#define SCREEN_SCALE_HEIGHT(height)               (height * (SCREEN_HEIGHT / (isSizeOf_3_5 ? 568.f : 667.f)))

