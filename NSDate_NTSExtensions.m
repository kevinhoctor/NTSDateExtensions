//
//  NSDate_NTSExtensions.m
//
//  Created by Kevin Hoctor on 3/16/08.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
//

#import "NSDate_NTSExtensions.h"

static NSTimeInterval dayTimeInterval = (60.0 * 60.0 * 24.0);
static NSInteger standardizedHour = 12;

@implementation NSDate (NTSExtensions)

+ (NSCalendar *)currentCalendar {

	static NSCalendar *currentCalendar = nil;
	if (currentCalendar == nil)
		currentCalendar = [[NSCalendar currentCalendar] retain];

	return currentCalendar;
}

+ (NSDate *)zeroHourDate:(NSDate *)aDate {

	if (aDate == nil) return nil;
	
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)zeroHourToday {

    return [NSDate zeroHourDate:[NSDate date]];
}

+ (NSDate *)zeroHourYesterday {

	return [[NSDate alloc] initWithTimeInterval:-dayTimeInterval sinceDate:[NSDate zeroHourToday]];
}

+ (NSDate *)midnightDate:(NSDate *)aDate {

	if (aDate == nil) return nil;
	
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)midnightToday {

    return [NSDate midnightDate:[NSDate date]];
}

+ (NSDate *)midnightYesterday {

	return [[NSDate alloc] initWithTimeInterval:-dayTimeInterval sinceDate:[NSDate midnightToday]];
}

+ (NSDate *)standardizedDate:(NSDate *)aDate {

	if (aDate == nil) return nil;
	
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)standardizedDateWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay {

	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:aYear];
	[comps setMonth:aMonth];
	[comps setDay:aDay];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)standardizedToday {

	return [NSDate standardizedDate:[NSDate date]];
}

+ (NSDate *)standardizedYesterday {

	return [[NSDate alloc] initWithTimeInterval:-dayTimeInterval sinceDate:[NSDate standardizedToday]];
}

+ (NSDate *)startOfMonthDate:(NSDate *)aDate {

	if (aDate == nil) return nil;
	
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setDay:1];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)startOfYearDate:(NSDate *)aDate {

	if (aDate == nil) return nil;
	
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setMonth:1];
	[comps setDay:1];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)startOfPreviousYearDate:(NSDate *)aDate {

	if (aDate == nil) return nil;
	
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setYear:[comps year] - 1];
	[comps setMonth:1];
	[comps setDay:1];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {

	return [[NSDate alloc] initWithTimeInterval:(NSTimeInterval)days * dayTimeInterval sinceDate:self];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {

	return [self dateByAddingDays:(weeks * 7)];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {

	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:months];
	return [[NSDate currentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)dateByAddingYears:(NSInteger)years {
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:years];
	return [[NSDate currentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

@end
