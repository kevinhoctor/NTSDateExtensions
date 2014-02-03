//
//  NTSYearMonth.m
//
//  Created by Kevin Hoctor on 10/20/09.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
//

#import "NSDate+NTSAdditions.h"
#import "NTSDateOnly.h"
#import "NTSYearMonth.h"

#define FIRST_HALF_START_DAYS 0
#define FIRST_HALF_END_DAYS   13

@implementation NTSYearMonth

@synthesize year;
@synthesize month;
@synthesize day;

- (id)init
{
	return [self initWithDateOnly:[NTSDateOnly today]];
}

- (id)initWithDate:(NSDate *)aDate
{
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:aDate];
	return [self initWithYear:[comps year] month:[comps month] day:[comps day]];
}

- (id)initWithDateOnly:(NTSDateOnly *)aDate startDay:(NSInteger)aDay
{
	self = [self initWithYear:aDate.year month:aDate.month day:aDay];
	if ([aDate isGreaterThan:[self createEndDate]]) {
		[self incrementMonth];
	} else if ([aDate isLessThan:[self createStartDate]]) {
		[self decrementMonth];
	}
	return self;
}

- (id)initWithDateOnly:(NTSDateOnly *)aDate
{
	if ([aDate unsignedIntValue] == 0) {
		aDate = [NTSDateOnly today];
	}
	return [self initWithDateOnly:aDate startDay:1];
}

- (id)initWithYearMonth:(NTSYearMonth *)aYearMonth
{
	return [self initWithYear:[aYearMonth year] month:[aYearMonth month] day:[aYearMonth day]];
}

- (id)initWithInteger:(NSInteger)aYearMonth
{
	return [self initWithYear:aYearMonth / 100 month:aYearMonth % 100 day:1];
}

- (id)initWithDay:(NSInteger)aDay
{
	return [self initWithDateOnly:[NTSDateOnly today] startDay:aDay];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth
{
	return [self initWithYear:aYear month:aMonth day:1];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay
{
	self = [super init];
	if (self != nil) {
		year = aYear;
		month = aMonth;
		day = aDay;
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"{year = %ld; month = %ld; day = %ld}", (long)self.year, (long)self.month, (long)self.day];
}

- (NSString *)label
{
	// The day doesn't matter because the month and year are the label designators
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    NTSDateOnly *dateOnly = [[NTSDateOnly alloc] initWithYear:self.year month:self.month day:1];
    NSString *label = [NSString stringWithFormat:@"%@", [dateOnly dateValue]];
    dateOnly = nil;
	return label;
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
	return [NSString stringWithFormat:@"%@", [[[[NTSDateOnly alloc] initWithYear:self.year month:self.month day:1] dateValue] descriptionWithCalendarFormat:@"%b %Y" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]]];
#endif
}

- (NSComparisonResult)compare:(NTSYearMonth *)other
{
    if ([self integerValue] < [other integerValue]) {
        return NSOrderedAscending;
    } else if ([self integerValue] > [other integerValue]) {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}

- (NSInteger)integerValue
{
	return (year * 100) + month;
}

- (void)incrementMonth
{
	self.month++;
	if (self.month > 12) {
		self.year++;
		self.month -= 12;
	}
}

- (void)decrementMonth
{
	self.month--;
	if (self.month < 1) {
		self.year--;
		self.month = 12;
	}
}

- (BOOL)isCurrent
{
	NTSYearMonth *currentYearMonth = [[NTSYearMonth alloc] init];
	BOOL isCurrent = (self.year == currentYearMonth.year && self.month == currentYearMonth.month) ? YES : NO;
	currentYearMonth = nil;
	return isCurrent;
}

- (BOOL)containsDate:(NTSDateOnly *)aDate
{
	return ([aDate isLessThan:[self createStartDate]] || [aDate isGreaterThan:[self createEndDate]]) ? NO : YES;
}

- (NTSDateOnly *)createDateWithDay:(NSInteger)dayOfMonth
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger monthToUse = (dayOfMonth < 1) ? self.month + 1 : self.month;
	[comps setDay:dayOfMonth];
	[comps setMonth:monthToUse];
	[comps setYear:self.year];
	NSDate *testDate = [[NSDate currentCalendar] dateFromComponents:comps];
	comps = nil;
	return [[NTSDateOnly alloc] initWithDate:testDate];
}

- (NTSDateOnly *)createStartDateWithDay:(NSInteger)dayOfMonth
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger monthToUse = self.month;     // (dayOfMonth < 1) ? self.month + 1 : self.month;
	if (dayOfMonth > 15) {
		monthToUse--;
	}
	[comps setDay:dayOfMonth];
	[comps setMonth:monthToUse];
	[comps setYear:self.year];
	NTSDateOnly *dateOnly = [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateFromComponents:comps]];
	comps = nil;
	return dateOnly;
}

- (NTSDateOnly *)createEndDateWithDay:(NSInteger)dayOfMonth
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger monthToUse = self.month;     // (dayOfMonth < 1) ? self.month + 1 : self.month;
	if (dayOfMonth <= 15) {
		monthToUse++;
	}
	[comps setDay:dayOfMonth - 1];
	[comps setMonth:monthToUse];
	[comps setYear:self.year];
	NTSDateOnly *dateOnly = [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateFromComponents:comps]];
	comps = nil;
	return dateOnly;
}

- (NTSDateOnly *)createStartDate
{
	return [self createStartDateWithDay:self.day];
}

- (NTSDateOnly *)createEndDate
{
	return [self createEndDateWithDay:self.day];
}

- (BOOL)isFirstHalfDate:(NTSDateOnly *)aDate
{
	return ([aDate isGreaterThanOrEqualTo:[self firstHalfStartDate]] && [aDate isLessThanOrEqualTo:[self firstHalfEndDate]]) ? YES : NO;
}

- (NTSDateOnly *)firstHalfStartDate
{
	return [[self createStartDate] dateByAddingDays:FIRST_HALF_START_DAYS];
}

- (NTSDateOnly *)firstHalfEndDate
{
	return [[self createStartDate] dateByAddingDays:FIRST_HALF_END_DAYS];
}

- (NSString *)labelWithFirstHalfDate:(NTSDateOnly *)aDate
{
	return [NSString stringWithFormat:@"%@/%@", [self label], ([self isFirstHalfDate:aDate]) ? NSLocalizedString(@"First Half", @"First Half"):NSLocalizedString(@"Second Half", @"Second Half")];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[NTSYearMonth allocWithZone:zone] initWithYear:self.year month:self.month day:self.day];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[NTSYearMonth class]] == NO) {
        return NO;
    }
    
    NTSYearMonth *yearMonthObject = (NTSYearMonth *)object;
    
    return (yearMonthObject.year == self.year && yearMonthObject.month == self.month);
}

- (NSUInteger)hash
{
    return [self integerValue];
}

@end
