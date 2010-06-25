//
//  NSDate_NTSExtensions.h
//  MoneyWell
//
//  Created by Kevin Hoctor on 3/16/08.
//  Copyright 2008 No Thirst Software LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSDate (NTSExtensions) 

+ (NSCalendar *)currentCalendar;
+ (NSDate *)zeroHourDate:(NSDate *)aDate;
+ (NSDate *)zeroHourToday;
+ (NSDate *)zeroHourYesterday;
+ (NSDate *)midnightDate:(NSDate *)aDate;
+ (NSDate *)midnightToday;
+ (NSDate *)midnightYesterday;
+ (NSDate *)startOfMonthDate:(NSDate *)aDate;
+ (NSDate *)startOfYearDate:(NSDate *)aDate;
+ (NSDate *)startOfPreviousYearDate:(NSDate *)aDate;
+ (NSDate *)standardizedDate:(NSDate *)aDate;
+ (NSDate *)standardizedDateWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay;
+ (NSDate *)standardizedToday;
+ (NSDate *)standardizedYesterday;

- (NSDate *)dateByAddingDays:(NSInteger)weeks;
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateByAddingYears:(NSInteger)years;

@end
