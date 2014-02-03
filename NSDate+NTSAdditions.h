//
//  NSDate+NTSAdditions.h
//
//  Created by Kevin Hoctor on 3/16/08.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
//

@interface NSDate (NTSAdditions)

+ (NSCalendar *)currentCalendar;
+ (NSDate *)zeroHourDateWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay;
+ (NSDate *)zeroHourDate:(NSDate *)aDate;
+ (NSDate *)zeroHourToday;
+ (NSDate *)zeroHourYesterday;
+ (NSDate *)zeroHourTomorrow;
+ (NSDate *)midnightDate:(NSDate *)aDate;
+ (NSDate *)midnightToday;
+ (NSDate *)midnightYesterday;
+ (NSDate *)startOfWeekDate:(NSDate *)aDate;
+ (NSDate *)startOfMonthDate:(NSDate *)aDate;
+ (NSDate *)startOfYearDate:(NSDate *)aDate;
+ (NSDate *)startOfPreviousYearDate:(NSDate *)aDate;
+ (NSDate *)endOfWeekDate:(NSDate *)aDate;
+ (NSDate *)endOfMonthDate:(NSDate *)aDate;
+ (NSDate *)endOfYearDate:(NSDate *)aDate;
+ (NSDate *)standardizedDate:(NSDate *)aDate;
+ (NSDate *)standardizedDateWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay;
+ (NSDate *)standardizedToday;
+ (NSDate *)standardizedYesterday;
+ (NSDate *)standardizedTomorrow;

- (NSDate *)dateByAddingDays:(NSInteger)weeks;
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateByAddingYears:(NSInteger)years;
- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isTomorrow;

- (NSNumber *)numberValue;

- (NSInteger)timeIntervalInDaysSinceDate:(NSDate *)referenceDate;

// Date Comparisons

- (BOOL)isLaterThanDate:(NSDate *)anotherDate;
- (BOOL)isLaterThanOrEqualToDate:(NSDate *)anotherDate;
- (BOOL)isEarlierThanDate:(NSDate *)anotherDate;
- (BOOL)isEarlierThanOrEqualToDate:(NSDate *)anotherDate;

@end
