//
//  ContactHelper.m
//  DevelopTools
//
//  Created by Johnson on 5/12/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import "ContactHelper.h"
@import AddressBook;

@implementation ContactHelper

+ (BOOL)haveContactPermission;
{
    //是否开启权限
    __block BOOL havePermission;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //申请访问权限
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool greanted, CFErrorRef error) {
        //greanted为YES是表示用户允许，否则为不允许
        havePermission = greanted;
        //发送一次信号
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (havePermission) {CFRelease(addressBookRef);}
    return havePermission;
}

+ (NSDictionary *)allContacts;
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addressBookRef);
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < number; i++) {
        ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        NSString *middleName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonMiddleNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        
        
        //        NSString *phone = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonPhoneProperty));
        NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(ABRecordCopyValue(people, kABPersonPhoneProperty), 0));
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:EMPTY_STRING];
        
        
        NSString *name = [[lastName ?: EMPTY_STRING stringByAppendingString:middleName ?: EMPTY_STRING] stringByAppendingString:firstName ?: EMPTY_STRING];
        phone ? [dictionary setObject:phone forKey:[name isEqualToString:EMPTY_STRING] ? phone : name] : nil;
    }
    
    CFRelease(addressBookRef);
    CFRelease(allLinkPeople);
    return dictionary;
}

+ (NSDictionary *)allContactForMobilePhone;
{
    NSMutableDictionary *dictionary = (id)[ContactHelper allContacts];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![NSString validateTel:obj]) {
            [dictionary removeObjectForKey:key];
        }
    }];
    return dictionary;
}

+ (BOOL)queryContactWithName:(NSString *)name;
{
    return [[[ContactHelper allContacts] allValues] containsObject:name];
}

+ (void)addContactWithName:(NSString *)name phone:(NSString *)phone;
{
    if (name == nil || phone == nil) {
        return;
    }
    ABRecordRef person = ABPersonCreate();
    NSString *firstName = name;
    NSArray *phones = @[phone];
    NSArray *labels = @[@"-红帽法律卫士-"];
    
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)firstName, NULL);
    
    // 字典引用
    ABMultiValueRef dic = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    // 添加电话号码与其对应的名称内容
    for (int i = 0; i < [phones count]; i ++) {
        ABMultiValueIdentifier obj = ABMultiValueAddValueAndLabel(dic, (__bridge CFStringRef)[phones objectAtIndex:i],  (__bridge CFStringRef)[labels objectAtIndex:i], &obj);
    }
    // 设置phone属性
    ABRecordSetValue(person, kABPersonPhoneProperty, dic, NULL);
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // 将新建的联系人添加到通讯录中
    ABAddressBookAddRecord(addressBookRef, person, NULL);
    // 保存通讯录数据
    ABAddressBookSave(addressBookRef, NULL);
    
    
    CFRelease(person);
    CFRelease(dic);
    CFRelease(addressBookRef);
}

@end
