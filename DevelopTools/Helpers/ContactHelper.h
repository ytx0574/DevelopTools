//
//  ContactHelper.h
//  DevelopTools
//
//  Created by Johnson on 5/12/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactHelper : NSObject

+ (BOOL)haveContactPermission;

+ (NSDictionary *)allContacts;

+ (NSDictionary *)allContactForMobilePhone;

+ (BOOL)queryContactWithName:(NSString *)name;

+ (void)addContactWithName:(NSString *)name phone:(NSString *)phone;

@end
