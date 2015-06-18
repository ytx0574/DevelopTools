//
//  NSString+MKNetworkKitAdditions.m
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

#import "NSString+Tools.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (Tools)

//资源文件读取
+ (UIImage *)readBundleImageNamed:(NSString *)name
{
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && name ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : name];
        
        if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 || [[UIScreen mainScreen] scale] == 2.0 ) {
            
            return  [UIImage imageWithCGImage:[[UIImage  imageWithContentsOfFile:s] CGImage]
                                        scale:2.0 orientation:UIImageOrientationUp];
        }
        return [UIImage imageWithContentsOfFile:s];
    }
    
    return nil;
    
}

//MD5 加密
+(NSString*)md5Str:(NSString*)str
{
    NSString *md5str;
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    md5str =  [hash lowercaseString];
    return md5str;
}

//文本先进行DES加密。然后再转成base64
+ (NSString *)base64StringFromText:(NSString *)text withKey:(NSString*)key
{
    if (text && ![text isEqualToString:@""]) {
        //取项目的bundleIdentifier作为KEY
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin
        data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return @"";
    }
}

//先把base64转为文本。然后再DES解密
+ (NSString *)textFromBase64String:(NSString *)base64 withKey:(NSString*)key
{
    if (base64 && ![base64 isEqualToString:@""]) {
        //取项目的bundleIdentifier作为KEY
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin
        data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return @"";
    }
}


/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
	if (string == nil)
		[NSException raise:NSInvalidArgumentException format:nil];
	if ([string length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = malloc((([string length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	bytes = realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
	if ([data length] == 0)
		return @"";
	
    char *characters = malloc((([data length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [data length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [data length])
			buffer[bufferLength++] = ((char *)[data bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';
	}
	
	return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}


/**
 字节数组转化16进制数
 */
+(NSString *)parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    return [hexStr uppercaseString];
}


/*
 将16进制数据转化成NSData 数组
 */
+(NSData*)parseHexToByteArray:(NSString*) hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    NSLog(@"newData=%@",newData);
    return newData;
}

+ (NSString *)replaceEmptyOrNull:(NSString *)checkString
{
    if (!checkString || [checkString isEqualToString:@""]||[checkString isEqualToString:@"null"]) {
        return @"";
    }
    return checkString;
}

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];      
}
- (NSString*)sha
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


- (NSString*)uniqueString
{
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);
//    NSString	*uuidString = ( NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	NSString	*uuidString = CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

- (NSString*)urlEncodedString {
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        ( CFStringRef) self, 
                                                                        nil,
                                                                        CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "), 
                                                                        kCFStringEncodingUTF8);
    
//    NSString *encodedString = [[NSString alloc] initWithString:( NSString*) encodedCFString];
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge NSString*) encodedCFString];
    CFRelease(encodedCFString);
    
    if(!encodedString)
        encodedString = @"";    
    
    return encodedString;
    
}

- (NSString*)urlDecodedString {

    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, 
                                                                                          ( CFStringRef) self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);

    NSString *decodedString = [[NSString alloc] initWithString:(__bridge NSString*) decodedCFString];
    CFRelease(decodedCFString);
    return (!decodedString) ? @"" : [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = nil;
    if (iOS_SYSTEM_LATER(8)) {
        returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:nil error:NULL];
    }else {
        returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:nil errorDescription:NULL];
    }
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

+ (BOOL)validateName:(NSString *)candidate;
{
    NSString *regex = @"[\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validateSearchText:(NSString *)candidate;
{
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5\\w]{2,35}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validatePassword:(NSString *)candidate;
{
    NSString *regex = @"^[\\w]{6,12}$";
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validateEmail:(NSString *)candidate;
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validateTel:(NSString *)candidate;
{
    NSString *regex = @"^1[3|4|5|6|7|8]\\d{9}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validateCharacter:(NSString *)candidate;
{
    NSString *regex=@"^[\u4E00-\u9FA5A-Za-z_]+$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validateNum:(NSString *)candidate;
{
    NSString *regex = @"^[0-9]+(.[0-9]{1,2})?$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validateNumeric:(NSString *)candidate;
{
    NSString *regex = @"^[0-9]*$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validateHanzi:(NSString *)candidate;
{
    NSString *regex = @"[\u4e00-\u9fa5]{2,4}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [predicate evaluateWithObject:candidate];
}

+ (BOOL)validate:(NSString *)candidate regex:(NSString *)regex;
{
    if (!candidate || !regex) {return NO;}
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex] evaluateWithObject:candidate];
}

- (BOOL)validate:(NSString *)regex;
{
    if (!self || !regex) {return NO;}
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex] evaluateWithObject:self];
}

+ (BOOL)validateBlank:(NSString *)candidate;
{
    NSCharacterSet *characterset = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if (!IS_NOT_nilORnullOREmptyString(candidate)) { return NO; }
    return [[candidate stringByTrimmingCharactersInSet:characterset] isEqualToString:@""];
}

+ (BOOL)validateIdCardNumber:(NSString *)idCardNumber;
{
    if (idCardNumber == nil || [idCardNumber isEqualToString:@""]) {
        return NO;
    }
    if (idCardNumber.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[idCardNumber substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[idCardNumber substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[idCardNumber substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

@end