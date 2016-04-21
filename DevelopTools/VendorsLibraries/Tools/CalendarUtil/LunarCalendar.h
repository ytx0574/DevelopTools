//  LunarCalendar
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 caobo. All rights reserved.
//
//  Modified by cyrusleung on 2014-05-25
//  1.修改了部分方法命名
//  2.增加了getChineseHoliday，getWorldHoliday，getWeekHoliday等方法
//  3.修改了星座返回中文
//  4.其余少量bug修改


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface LunarCalendar : NSObject

- (void)loadWithDate:(NSDate *)date;//加载数据

- (void)InitializeValue;//添加数据
- (NSInteger)LunarYearDays:(NSInteger)y;
- (NSInteger)DoubleMonth:(NSInteger)y;
- (NSInteger)DoubleMonthDays:(NSInteger)y;
- (NSInteger)MonthDays:(NSInteger)y :(NSInteger)m;
- (void)ComputeSolarTerm;

- (CGFloat)Term:(NSInteger)y :(NSInteger)n :(BOOL)pd;
- (CGFloat)AntiDayDifference:(NSInteger)y :(CGFloat)x;
- (CGFloat)EquivalentStandardDay:(NSInteger)y :(NSInteger)m :(NSInteger)d;
- (NSInteger)IfGregorian:(NSInteger)y :(NSInteger)m :(NSInteger)d :(NSInteger)opt;
- (NSInteger)DayDifference:(NSInteger)y :(NSInteger)m :(NSInteger)d;
- (CGFloat)Tail:(CGFloat)x;

- (NSString *)MonthLunar;//农历
- (NSString *)DayLunar;//农历日
- (NSString *)ZodiacLunar;//年生肖
- (NSString *)YearHeavenlyStem;//年天干
- (NSString *)MonthHeavenlyStem;//月天干
- (NSString *)DayHeavenlyStem;//日天干
- (NSString *)YearEarthlyBranch;//年地支
- (NSString *)MonthEarthlyBranch;//月地支
- (NSString *)DayEarthlyBranch;//日地支
- (NSString *)SolarTermTitle;//节气
- (NSMutableArray *)Holiday;//节日
- (BOOL)IsLeap;//是不是农历闰年？？
- (NSInteger)GregorianYear;//阳历年
- (NSInteger)GregorianMonth;//阳历月
- (NSInteger)GregorianDay;//阳历天
- (NSInteger)Weekday;//一周的第几天
- (NSString *)Constellation;//星座

@end


@interface NSDate (LunarCalendar)

/****************************************************
 *@Description:获得NSDate对应的中国日历（农历）的NSDate
 *@Params:nil
 *@Return:NSDate对应的中国日历（农历）的LunarCalendar
 ****************************************************/
- (LunarCalendar *)chineseCalendarDate;//加载中国农历

@end