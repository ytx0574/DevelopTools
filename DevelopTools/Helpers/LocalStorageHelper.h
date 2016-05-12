//
//  LocalStorage.h
//  DevelopTools
//
//  Created by Johnson on 4/27/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 本地化对象， 继承该类的对象实例， 可进行本地化存储与读取, 仅保存一个实例, 属性字段仅基本类型
 */
@interface LocalStorageHelper : NSObject

/**初始化对象，并从本地读取值    最好是单例对象使用*/
- (instancetype)initWithLocalStore;
/**从本类型的其他对象或者字典进行复制， 并本地保存*/
- (instancetype)setInfo:(id)info saveLocal:(BOOL)save;

@end
