//
//  NSDate+NTSAdditions.m
//
//  Created by Kevin Hoctor on 3/16/08.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
//

#import "NSDate+NTSAdditions.h"
#import "NTSDateOnly.h"

static NSInteger standardizedHour = 12;
NSString *const NTSDateCurrentCalendarKey = @"NTSDateCurrentCalendarKey";

@implementation NSDate (NTSAdditions)

+ (NSCalendar *)currentCalendar
{
    NSThread *currentThread = [NSThread currentThread];
    if (currentThread == nil) { //ZOMBIE THREAD!!
        return [NSCalendar currentCalendar];
    }
    
    NSCalendar *cachedThreadCalendar = [currentThread.threadDictionary objectForKey:NTSDateCurrentCalendarKey];
    if (cachedThreadCalendar == nil) {
        cachedThreadCalendar = [NSCalendar currentCalendar];
        [currentThread.threadDictionary setObject:cachedThreadCalendar forKey:NTSDateCurrentCalendarKey];
    }
    
	return cachedThreadCalendar;
}

+ (NSDate *)zeroHourDateWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:aYear];
	[comps setMonth:aMonth];
	[comps setDay:aDay];
	[comps setHour:0];
	NSDate *date = [[NSDate currentCalendar] dateFromComponents:comps];
	comps = nil;
	return date;
}

+ (NSDate *)zeroHourDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)zeroHourToday
{
	return [NSDate zeroHourDate:[NSDate date]];
}

+ (NSDate *)zeroHourYesterday
{
	return [[NSDate zeroHourToday] dateByAddingDays:-1];
}

+ (NSDate *)zeroHourTomorrow
{
    return [[NSDate zeroHourToday] dateByAddingDays:1];
}

+ (NSDate *)midnightDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)midnightToday
{
	return [NSDate midnightDate:[NSDate date]];
}

+ (NSDate *)midnightYesterday
{
	return [[NSDate midnightToday] dateByAddingDays:-1];
}

+ (NSDate *)standardizedDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)standardizedDateWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:aYear];
	[comps setMonth:aMonth];
	[comps setDay:aDay];
	[comps setHour:standardizedHour];
	NSDate *date = [[NSDate currentCalendar] dateFromComponents:comps];
	comps = nil;
	return date;
}

+ (NSDate *)standardizedToday
{
	return [NSDate standardizedDate:[NSDate date]];
}

+ (NSDate *)standardizedYesterday
{
	return [[NSDate standardizedToday] dateByAddingDays:-1];
}

+ (NSDate *)standardizedTomorrow
{
	return [[NSDate standardizedToday] dateByAddingDays:1];
}

+ (NSDate *)startOfWeekDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDate *beginningOfWeek = nil;
	[[NSDate currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek interval:NULL forDate:aDate];
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:beginningOfWeek];

	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)startOfMonthDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setDay:1];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)startOfYearDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setMonth:1];
	[comps setDay:1];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)startOfPreviousYearDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setYear:[comps year] - 1];
	[comps setMonth:1];
	[comps setDay:1];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)endOfWeekDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}
    
    NSRange weekRange = [[NSDate currentCalendar] maximumRangeOfUnit:NSWeekdayCalendarUnit];
    return [[self startOfWeekDate:aDate] dateByAddingDays:weekRange.length - 1];
}

+ (NSDate *)endOfMonthDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}
    
    NSRange monthRange = [[NSDate currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDate];
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setDay:monthRange.length];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)endOfYearDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}
    
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setMonth:[[NSDate currentCalendar] maximumRangeOfUnit:NSMonthCalendarUnit].length];
	[comps setDay:1];
    NSDate *firstDayOfLastMonth = [[NSDate currentCalendar] dateFromComponents:comps];
    
    NSRange monthRange = [[NSDate currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDayOfLastMonth];
    return [firstDayOfLastMonth dateByAddingDays:monthRange.length - 1];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:days];
	NSDate *date = [[NSDate currentCalendar] dateByAddingComponents:comps toDate:self options:0];
	comps = nil;
	return date;
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setWeek:weeks];
	NSDate *date = [[NSDate currentCalendar] dateByAddingComponents:comps toDate:self options:0];
	comps = nil;
	return date;
}

- (NSDate *)dateByAddingMonths:(NSInteger)months
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:months];
	NSDate *date = [[NSDate currentCalendar] dateByAddingComponents:comps toDate:self options:0];
	comps = nil;
	return date;
}

- (NSDate *)dateByAddingYears:(NSInteger)years
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:years];
	NSDate *date = [[NSDate currentCalendar] dateByAddingComponents:comps toDate:self options:0];
	comps = nil;
	return date;
}

- (BOOL)isToday
{
	NSDate *today = [[NSDate alloc] init];
	NSDateComponents *todayComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];

	today = nil;

	NSDateComponents *selfComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];

	return [todayComponents year] == [selfComponents year] && [todayComponents month] == [selfComponents month] && [todayComponents day] == [selfComponents day];
}

- (BOOL)isYesterday
{
	NSDate *yesterday = [NSDate standardizedYesterday];
	NSDateComponents *yesterdayComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:yesterday];

	NSDateComponents *selfComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];

	return [yesterdayComponents year] == [selfComponents year] && [yesterdayComponents month] == [selfComponents month] && [yesterdayComponents day] == [selfComponents day];
}

- (BOOL)isTomorrow
{
	NSDate *tomorrow = [NSDate standardizedTomorrow];
	NSDateComponents *tomorrowComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:tomorrow];

	NSDateComponents *selfComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];

	return [tomorrowComponents year] == [selfComponents year] && [tomorrowComponents month] == [selfComponents month] && [tomorrowComponents day] == [selfComponents day];
}

- (NSNumber *)numberValue
{
    return [[NTSDateOnly dateOnlyWithDate:self] numberValue];
}

- (NSInteger)timeIntervalInDaysSinceDate:(NSDate *)referenceDate
{
	NSDate *zeroHourDate = [NSDate zeroHourDate:self];
	NSDate *zeroHourReferenceDate = [NSDate zeroHourDate:referenceDate];

    NSUInteger unitFlags = NSDayCalendarUnit;
    NSDateComponents *components = [[NSDate currentCalendar] components:unitFlags fromDate:zeroHourReferenceDate toDate:zeroHourDate options:0];
    NSInteger days = [components day];
    
    return days;
}

#pragma mark - Comparisons

- (BOOL)isLaterThanDate:(NSDate *)anotherDate
{
    NSComparisonResult result = [self compare:anotherDate];
    
    return result == NSOrderedDescending;
}

- (BOOL)isLaterThanOrEqualToDate:(NSDate *)anotherDate
{
    NSComparisonResult result = [self compare:anotherDate];
    
    return result == NSOrderedDescending || result == NSOrderedSame;
}

- (BOOL)isEarlierThanDate:(NSDate *)anotherDate
{
    NSComparisonResult result = [self compare:anotherDate];
    
    return result == NSOrderedAscending;
}

- (BOOL)isEarlierThanOrEqualToDate:(NSDate *)anotherDate
{
    NSComparisonResult result = [self compare:anotherDate];
    
    return result == NSOrderedAscending || result == NSOrderedSame;
}

@end
