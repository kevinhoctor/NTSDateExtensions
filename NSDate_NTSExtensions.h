//
//  NSDate_NTSExtensions.h
//
//  Created by Kevin Hoctor on 3/16/08.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
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
