//
//  NSString+MKNetworkKitAdditions.h
//  MKNetworkKitDemo
//
//  Created by Mugunth Kumar (@mugunthkumar) on 11/11/11.
//  Copyright (C) 2011-2020 by Steinlogic Consulting and Training Pte Ltd

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>

@interface NSString (Tools)

#define MYBUNDLE_NAME @"GLResources.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
/**
 *  从bundle里面读取图片文件
 *
 *  @param name bundle里面的图片文件名
 *
 *  @return UIImage
 */
+ (UIImage *)readBundleImageNamed:(NSString *)name;
/**
 *  MD5加密字符串
 *
 *  @param str 被加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)md5Str:(NSString*)str;
/**
 *  文本先进行DES加密。然后再转成base64
 *
 *  @param text 被加密的字符串
 *  @param key  加密的key
 *
 *  @return 加密后的字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text withKey:(NSString*)key;
/**
 *  先把base64转为文本。然后再DES解密
 *
 *  @param withKey:NSString* 被解密的字符串
 *  @param key  加密的key
 *
 *  @return 解密后的字符串
 */

+ (NSString *)textFromBase64String:(NSString *)base64 withKey:(NSString*)key;
/**
 *  文本数据进行DES加密
 *
 *  @param data 被加密的data
 *  @param key  加密的key
 *
 *  @return 加密后的字符串
 */
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;
/**
 *  文本数据进行DES解密
 *
 *  @param data 被解密的data
 *  @param key  加密的key
 *
 *  @return 解密后的字符串
 */
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;
/**
 *  字符串base64加密
 *
 *  @param string 文本数据base64加密
 *
 *  @return 返回加密后的data
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

//文本数据转换为base64格式字符串
/**
 *  data base64解密
 *
 *  @param data 被解密的data
 *
 *  @return 返回解密后的字符串
 */
+ (NSString *)base64EncodedStringFrom:(NSData *)data;
/**
 *  字节数组转化16进制数
 *
 *  @param bytes 字节数组
 *
 *  @return 转化后的字符串
 */
+ (NSString *)parseByteArray2HexString:(Byte[]) bytes;
/**
 *  将16进制字符串转化成NSData
 *
 *  @param hexString 被转换的字符串
 *
 *  @return 转换后的data
 */
+ (NSData*)parseHexToByteArray:(NSString*) hexString;
/**
 *  SHA 加密
 *
 *  @return 加密后的字符串
 */
- (NSString*)sha;
/**
 *  MD5加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)md5;
/**
 *  返回UUID
 *
 *  @return UUID
 */
- (NSString*)uniqueString;
/**
 *  URL 里面特殊字符进行编码
 *
 *  @return 编码后的字符串
 */
- (NSString*)urlEncodedString;
/**
 *  URL里面的特殊字符解码
 *
 *  @return 解码后的字符串
 */
- (NSString*)urlDecodedString;
/**
 *  Unicode转换为汉字
 *
 *  @param unicodeStr unicode字符串
 *
 *  @return 转换后的汉字
 */
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

/**
 *  过滤掉emoji文字
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)filterEmoji:(NSString *)string;


+ (BOOL)validateName:(NSString *)candidate;

+ (BOOL)validateSearchText:(NSString *)candidate;

+ (BOOL)validatePassword:(NSString *)candidate;

+ (BOOL)validateEmail:(NSString *)candidate;

+ (BOOL)validateTel:(NSString *)candidate;

+ (BOOL)validateCharacter:(NSString *)candidate;

+ (BOOL)validateNum:(NSString *)candidate;

+ (BOOL)validateNumeric:(NSString *)candidate;

+ (BOOL)validateHanzi:(NSString *)candidate;

+ (BOOL)validate:(NSString *)candidate regex:(NSString *)regex;

- (BOOL)validate:(NSString *)regex;

+ (BOOL)validateBlank:(NSString *)candidate;

+ (BOOL)validateIdCardNumber:(NSString *)idCardNumber;

@end

@interface NSString (Operation)
+ (NSString *)encryptPhoneNumber:(NSString *)phoneNumber;
+ (NSString *)encryptPhoneNumber:(NSString *)phoneNumber string:(NSString *)string;
+ (NSString *)convertDate:(NSDate *)date;
@end

@interface NSString (Runtime)

+ (NSString *)decodeType:(const char *)cString;

@end

