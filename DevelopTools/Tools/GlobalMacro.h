//
//  GlobalMacro.h
//  uBing
//
//  Created by Johnson on 14-6-16.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#pragma mark - DEBUG
#ifdef  DEBUG

#define NSOBJECT_TOOLS_DEBUG YES
#define PRINT_JOSN_STRING NO
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define ALERT_LOG(msg)                                   [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]
#define DEALLOC_LOG  - (void)dealloc{    NSLog(@"◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊ dealloc Class:%@\n %@",self, NO ?  [NSString stringWithFormat:@"Class_Information:%@", [self Log:NO]] : EMPTY_STRING);}

#else

#define NSOBJECT_TOOLS_DEBUG NO
#define PRINT_JOSN_STRING NO
#define NSLog(FORMAT, ...) nil;
#define ALERT_LOG(msg)
#define DEALLOC_LOG

#endif


#pragma mark - Syetem
/**状态栏高度*/
#define STATUSBAR_HEIGHT                          20
/**工具栏高度*/
#define TABBAR_HEIGHT                             49
/**导航栏高度*/
#define NAVIGATIONBAR_HEIGHT                      44
/**屏幕 宽高*/
#define SCREEN_WIDTH                              [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                             [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SCALE_WIDTH                        (SCREEN_WIDTH / 320.f)
#define SCREEN_SCALE_HEIGHT                       (SCREEN_HEIGHT / 480.f)
/**判断屏幕大小*/
#define isSizeOf_3_5                              (SCREEN_HEIGHT == 480 ? YES : NO)
#define isSizeOf_4_0                              (SCREEN_HEIGHT == 568 ? YES : NO)
#define isSizeOf_4_7                              (SCREEN_HEIGHT == 667 ? YES : NO)
#define isSizeOf_5_5                              (SCREEN_HEIGHT == 736 ? YES : NO)

/**传入参数判断系统是哪个版本*/
#define iOS_SYSTEM_VERSION(version) [[[UIDevice currentDevice] systemVersion] hasPrefix:[NSString stringWithFormat:@"%d",version]]
/**传入参数,判断系统版本是多少,及以后*/
#define iOS_SYSTEM_LATER(version)   (([[[UIDevice currentDevice] systemVersion] floatValue] >= version) ? YES : NO)
/**版本不一致的代码*/
#define MATCHING_SYSTEM_VERSION_CODE_LATER_ADN_EARLIER(isVersionLater, later, earlier)   if (isVersionLater){later;}else{earlier;}
/**iOS 8 7 6  的判定*/
#define iOS8                 (iOS_SYSTEM_VERSION(8) ? YES : NO)
#define iOS7                 (iOS_SYSTEM_VERSION(7) ? YES : NO)
#define iOS6                 (iOS_SYSTEM_VERSION(6) ? YES : NO)
#define iOS7_AND_LATER       (iOS_SYSTEM_LATER(7) ? YES : NO)

#pragma mark - System class or path
/**KEYWINDOW对象*/
#define KEY_WINDOW                      [[UIApplication sharedApplication] keyWindow]
/**AppDelegate对象*/
#define APPDELEGATE_INSTANCE            ((AppDelegate *)[[UIApplication sharedApplication] delegate])
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


#pragma mark - SetValue
/**设置颜色值*/
#define RGB(r,g,b)                                     [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
/**空字符串*/
#define EMPTY_STRING                                   @""
#define SetStringValue(value)                          (!value || [value isEqual:[NSNull null]]) ? EMPTY_STRING : value
/**字体*/
#define FONT(size)                                     [UIFont systemFontOfSize:size]
/**失去第一响应者*/
#define RESIGN_FIRST_RESPONDER                         [[UIApplication sharedApplication].keyWindow endEditing:YES]
/**得到字符串的像素矩阵*/
#define STRING_WITH_SIZE_AND_DEFAULT_HEIGHT(string, font, width) (iOS7_AND_LATER ? [string boundingRectWithSize:CGSizeMake(width, NSIntegerMax) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size : [string sizeWithFont:font constrainedToSize:CGSizeMake(width, NSIntegerMax)])

/**获取MAINBUNDLE*/
#define MAIN_BUNDLE                                    [NSBundle mainBundle]
/**获取bundle文件路径*/
#define BANDLE_FILE_PATH(filename, extension)          [MAIN_BUNDLE pathForResource:filename ofType:extension]
/**加载图片  内存*/
#define LOAD_IMAGE(filename)                           [UIImage imageNamed:filename]
//**加载图片(bundle中获取自动添加png后缀)  从文件加载*/
#define LOAD_IMAGE_WITH_FILE_FROM_BUNDLE(filename)     [UIImage imageWithContentsOfFile:BANDLE_FILE_PATH(BANDLE_FILE_PATH(filename, @"png") ? filename : ([filename stringByAppendingFormat:@"@%@x", isSizeOf_5_5 ? @"3" : @"2"]), @"png")]
//#define LOAD_IMAGE_WITH_FILE_FROM_BUNDLE(filename)     [UIImage imageWithContentsOfFile:BANDLE_FILE_PATH(BANDLE_FILE_PATH(filename, @"png") ? filename : [filename stringByAppendingString:@"@2x"],@"png")]

/**加载图片  从文件加载*/
#define LOAD_IMAGE_WITH_FILE_PATH(path)                [UIImage imageWithContentsOfFile:path]
/**设置数组值.*/
#define SET_ARRAY(_arrayWith__, tempArray)                                  _arrayWith__ = [NSArray arrayWithArray:tempArray]
#define SET_MUTABLEARRAY(_arrayWith__, tempArray)                           _arrayWith__ = [NSMutableArray arrayWithArray:tempArray]
/**设置字典值.*/
#define SET_DICATIONARY(_dicationaryWith__, tempDicationary)                _dicationaryWith__ = [NSDicationary dictionaryWithDictionary:tempDicationary]
#define SET_MUTABLEDICATIONARY(_dicationaryWith__, tempDicationary)         _dicationaryWith__ = [NSMutableDicationary dictionaryWithDictionary:tempDicationary]

/**设置单例 (前面和后面)*/
#define SHAREINSTANCE_FOR_CLASS_HEADER \
+ (instancetype)getInstance;
#define SHAREINSTANCE_FOR_CLASS(class) \
+ (instancetype)getInstance;\
{\
static class *shareInstance = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
shareInstance = [[class alloc] init];\
});\
return shareInstance;\
}
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

#pragma mark - View frame
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

#define RESET_FRAME_ORIGIN_X(view, x)                    (CGRect){x, ORIGIN_Y(view), SIZE_W(view), SIZE_H(view)}
#define RESET_FRAME_ORIGIN_Y(view, y)                    (CGRect){ORIGIN_X(view), y, SIZE_W(view), SIZE_H(view)}
#define RESET_FRAME_SIZE_WIDTH(view, width)              (CGRect){ORIGIN_X(view), ORIGIN_Y(view), width, SIZE_H(view)}
#define RESET_FRAME__SIZE_HEIGHT(view, height)           (CGRect){ORIGIN_X(view), ORIGIN_Y(view), SIZE_W(view), height}

#define ORIGIN_Y_ADD_SIZE_H(view)                        (ORIGIN_Y(view) + SIZE_H(view))
#define ORIGIN_X_ADD_SIZE_W(view)                        (ORIGIN_X(view) + SIZE_W(view))

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

#define ShowTitleAlert(title, msg)                   [self showAlert:title message:msg delay:1];
#define ShowTipsAlert(msg)                           [self showAlert:@"提示" message:msg delay:1];
#define ShowAlert(msg)                               [self showAlert:nil message:msg delay:1];

#define Alert(title, msg, buttonTitle)               [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil, nil] show]
#define AlertTitleMsgOk(title, msg)                  AlertAll(title, msg, @"确定")
#define AlertMsgOk(msg)                              AlertAll(@"提示", msg, @"确定")

#define WEAK_SELF                                    typeof(self) __weak wself = self;

#pragma mark - Current Project
/**全局的cell的标志 (作为服务器字段id的转化)*/
static NSString *idIdentifier =              @"-Johnson-Identifier-";
/**默认的idUbing字符串(本地出现) "idUbing"*/
#define PROPERTY_IDUBING                     idUbing
/**数据接收时,本地跟服务器不同的字段  默认需要转换的keys  详情见:NSObject+AccessibilityTools-> convertResponseObject:keys:*/
#define CONVERT_RESPONSE_KEYS                @{[NSString stringWithFormat:@"\"%@\"",@"id"]: [NSString stringWithFormat:@"\"%@\"",idIdentifier]}
/**获取唯一单条数据的唯一标识时,本地跟服务器不同的字段  默认需要转换的keys 详情见:NSObject+AccessibilityTools-> convertUnique:keys:*/
#define CONVERT_UNIQUE_KEYS                  @{@"id": idIdentifier}

/**根控制器对象*/
#define ROOTVIEWCONTROLLER                           ((CTTabBarViewController *)APPDELEGATE_INSTANCE.window.rootViewController)
/**根导航栏*/
#define ROOTNAVIGATIONCONROLLER                      ((UINavigationController *)((CTTabBarViewController *)APPDELEGATE_INSTANCE.window.rootViewController).selectedViewController)
/**当前vc*/
#define CURRENTVIEWCONTROLLER                        ((CTViewController *)ROOTNAVIGATIONCONROLLER.viewControllers.lastObject)