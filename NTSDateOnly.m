//
//  NTSDateOnly.m
//  MoneyWell
//
//  Created by Kevin Hoctor on 11/25/09.
//  Copyright 2009 No Thirst Software LLC. All rights reserved.
//

#import "NTSDateOnly.h"
#import "NSDate_NTSExtensions.h"

static NSTimeInterval dayTimeInterval = (60.0 * 60.0 * 24.0);

@implementation NTSDateOnly

+ (NSCalendar *)currentCalendar {
	static NSCalendar *currentCalendar = nil;
	if (currentCalendar == nil) {
		currentCalendar = [NSCalendar currentCalendar];
		//[currentCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	}
	return currentCalendar;
}

+ (NSCalendar *)standardizedCalendar {
	static NSCalendar *standardizedCalendar = nil;
	if (standardizedCalendar == nil) {
		standardizedCalendar = [NSCalendar currentCalendar];
		[standardizedCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	}
	return standardizedCalendar;
}

+ (NTSDateOnly *)today {
	return [[NTSDateOnly alloc] init];
}

+ (NTSDateOnly *)yesterday {
	return [[NTSDateOnly alloc] initWithDate:[[NSDate alloc] initWithTimeInterval:-dayTimeInterval sinceDate:[NSDate date]]];
}

+ (NTSDateOnly *)startOfMonthDate:(NTSDateOnly *)aDate {
	if (aDate == nil) return nil;
	
	return [[NTSDateOnly alloc] initWithYear:[aDate year] month:[aDate month] day:1];
}

+ (NTSDateOnly *)startOfYearDate:(NTSDateOnly *)aDate {
	if (aDate == nil) return nil;
	
	return [[NTSDateOnly alloc] initWithYear:[aDate year] month:1 day:1];
}

+ (NTSDateOnly *)startOfPreviousYearDate:(NTSDateOnly *)aDate {
	if (aDate == nil) return nil;
	
	return [[NTSDateOnly alloc] initWithYear:[aDate year] - 1 month:1 day:1];
}

- (id)init {
	return [self initWithDate:[NSDate date]];
}

- (id)initWithDate:(NSDate *)aDate {
	
	NSUInteger aDateYMD = 0;
	if (aDate != nil) {
		NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:aDate];
		aDateYMD = ([comps year] * 10000) + ([comps month] * 100) + [comps day];
	}
	return [self initWithDateYMD:aDateYMD];
}

- (id)initWithYearMonth:(NTSYearMonth *)aYearMonth {
	return [self initWithYear:[aYearMonth year] month:[aYearMonth month] day:[aYearMonth day]];
}

- (id)initWithDay:(NSInteger)aDay {
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	return [self initWithYear:[comps year] month:[comps month] day:aDay];
}

- (id)initWithMonth:(NSInteger)aMonth day:(NSInteger)aDay {
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	return [self initWithYear:[comps year] month:aMonth day:aDay];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth {
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSDayCalendarUnit) fromDate:[NSDate date]];
	return [self initWithYear:aYear month:aMonth day:[comps day]];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:aDay];
	[comps setMonth:aMonth];
	[comps setYear:aYear];
	NSDate *normalizedDate = [[NTSDateOnly currentCalendar] dateFromComponents:comps];
	comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:normalizedDate];
	NSUInteger aDateYMD = ([comps year] * 10000) + ([comps month] * 100) + [comps day];
	
	return [self initWithDateYMD:aDateYMD];
}

- (id)initWithNumber:(NSNumber *)aNumber {
	return [self initWithDateYMD:[aNumber unsignedIntValue]];
}

- (id)initWithDateYMD:(NSUInteger)aDateYMD {
	self = [super init];
	if (self != nil) {
		dateYMD = aDateYMD;
	}
	return self;
}

- (const char *)objCType {
	return @encode(unsigned int);
}

- (unsigned int)unsignedIntValue {
	return dateYMD;
}

- (unsigned int)intValue {
	return dateYMD;
}

- (long long)longLongValue {
	return dateYMD;
}

- (const char *)UTF8String {
	return [[NSString stringWithFormat:@"%u", dateYMD] UTF8String];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%u", dateYMD];
}

- (NSString *)debugDescription {
	return [NSString stringWithFormat:@"{\nyear: %d\nmonth: %d\nday: %d\n}", [self year], [self month], [self day]];
}

- (NSInteger)year {
	return dateYMD / 10000;
}

- (NSInteger)month {
	return (dateYMD / 100) % 100;
}

- (NSInteger)day {
	return dateYMD % 100;
}

- (NSDate *)dateValue {
	if ([self intValue] == 0)
		return nil;

	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:[self day]];
	[comps setMonth:[self month]];
	[comps setYear:[self year]];
	return [[NTSDateOnly currentCalendar] dateFromComponents:comps];
}

- (NSNumber *)numberValue {
	return [NSNumber numberWithUnsignedLong:dateYMD];
}

- (BOOL)isEqualTo:(NTSDateOnly *)aDate {
	return (self.dateYMD == aDate.dateYMD) ? YES : NO;
}

- (BOOL)isLessThan:(NTSDateOnly *)aDate {
	return (self.dateYMD < aDate.dateYMD) ? YES : NO;
}

- (BOOL)isLessThanOrEqualTo:(NTSDateOnly *)aDate {
	return (self.dateYMD <= aDate.dateYMD) ? YES : NO;
}

- (BOOL)isGreaterThan:(NTSDateOnly *)aDate {
	return (self.dateYMD > aDate.dateYMD) ? YES : NO;
}

- (BOOL)isGreaterThanOrEqualTo:(NTSDateOnly *)aDate {
	return (self.dateYMD >= aDate.dateYMD) ? YES : NO;
}

- (NTSDateOnly *)dateByAddingDays:(NSInteger)days {
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:days];
	return [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateByAddingComponents:comps toDate:[self dateValue] options:0]];
}

- (NTSDateOnly *)dateByAddingWeeks:(NSInteger)weeks {

	return [self dateByAddingDays:(weeks * 7)];
}

- (NTSDateOnly *)dateByAddingMonths:(NSInteger)months {
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:months];
	return [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateByAddingComponents:comps toDate:[self dateValue] options:0]];
}

- (NTSDateOnly *)dateByAddingYears:(NSInteger)years {
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:years];
	return [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateByAddingComponents:comps toDate:[self dateValue] options:0]];
}

@synthesize dateYMD;

@end
