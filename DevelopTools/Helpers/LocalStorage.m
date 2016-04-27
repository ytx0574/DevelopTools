//
//  LocalStorage.m
//  DevelopTools
//
//  Created by Johnson on 4/27/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import "LocalStorage.h"
#import <objc/runtime.h>

@implementation LocalStorage
#pragma mark - 对象本地化
static char LocalUserDafaultsKey;
- (NSUserDefaults *)userDefaultForLocalInstance
{
    return objc_getAssociatedObject(self, &LocalUserDafaultsKey);
}

- (void)setUserDefaultForLocalInstance:(NSUserDefaults *)userDefaultForLocalInstance
{
    objc_setAssociatedObject(self, &LocalUserDafaultsKey, userDefaultForLocalInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (instancetype)initWithLocalStore;
{
    self = [super init];
    
    if (self) {
        if (![self userDefaultForLocalInstance]) {
            [self setUserDefaultForLocalInstance:[[NSUserDefaults alloc] initWithSuiteName:NSStringFromClass([self class])]];
        }
        
        [[self propertyList:[self class]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self setValue:[[self userDefaultForLocalInstance] objectForKey:obj] forKey:obj];
        }];
        
        
        NSMutableArray *mutableArraySignals = [NSMutableArray array];
        [[self propertyList:[self class]] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArraySignals addObject:[self rac_valuesForKeyPath:obj observer:self]];
        }];
        
        [[RACSignal merge:mutableArraySignals] subscribeNext:^(id x) {
            
            @weakify(self)
            [x performInBackground:^{
                @strongify(self)
                NSString *propretyName = [self getPropertyNameForValue:x];
                
                if (propretyName) {
                    [[self userDefaultForLocalInstance] setObject:x ?: EMPTY_STRING forKey:[propretyName substringFromIndex:1]];
                    [[self userDefaultForLocalInstance] synchronize];
                }
                
            }];
            
        }];
    }
    
    return self;
}


- (instancetype)setInfo:(id)info saveLocal:(BOOL)save;
{
    
    BOOL flag = [info isKindOfClass:[self class]] || [info isKindOfClass:[NSDictionary class]];
    
    if (!flag)
        NSLog(@"传入的对象和本类型不一致或不是NSDictionary对象")
        
    
    [[self propertyList:[self class]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self setValue:[info valueForKey:obj] forKey:obj];
        
        if (save) {
            
            @weakify(self)
            [info performInBackground:^{
                @strongify(self)
                [[self userDefaultForLocalInstance] setValue:[info valueForKey:obj] forKey:obj];
            }];
        }
        
    }];
    return nil;
}
@end
