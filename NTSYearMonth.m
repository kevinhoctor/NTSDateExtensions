//
//  NTSYearMonth.m
//  MoneyWell
//
//  Created by Kevin Hoctor on 10/20/09.
//  Copyright 2009 No Thirst Software LLC. All rights reserved.
//

#import "NTSYearMonth.h"
#import "NTSDateOnly.h"
#import "NSDate_NTSExtensions.h"

#define FIRST_HALF_START_DAYS	0
#define FIRST_HALF_END_DAYS		13

@implementation NTSYearMonth

- (id)init {
	return [self initWithDateOnly:[NTSDateOnly today]];
}

- (id)initWithDate:(NSDate *)aDate {
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:aDate];
	return [self initWithYear:[comps year] month:[comps month] day:[comps day]];
}

- (id)initWithDateOnly:(NTSDateOnly *)aDate startDay:(NSInteger)aDay {
	[self initWithYear:aDate.year month:aDate.month day:aDay];
	if ([aDate isGreaterThan:[self createEndDate]])
		[self incrementMonth];
	else if ([aDate isLessThan:[self createStartDate]])
		[self decrementMonth];
	return self;
}

- (id)initWithDateOnly:(NTSDateOnly *)aDate {
	if ([aDate unsignedIntValue] == 0)
		aDate = [NTSDateOnly today];
	return [self initWithDateOnly:aDate startDay:1];
}

- (id)initWithYearMonth:(NTSYearMonth *)aYearMonth {
	return [self initWithYear:[aYearMonth year] month:[aYearMonth month] day:[aYearMonth day]];
}

- (id)initWithInteger:(NSInteger)aYearMonth {
	return [self initWithYear:aYearMonth/100 month:aYearMonth%100 day:1];
}

- (id)initWithDay:(NSInteger)aDay {
	return [self initWithDateOnly:[NTSDateOnly today] startDay:aDay];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth {
	return [self initWithYear:aYear month:aMonth day:1];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay {
	self = [super init];
	if (self != nil) {
		year = aYear;
		month = aMonth;
		day = aDay;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"{year = %d; month = %d; day = %d}", self.year, self.month, self.day];
}

- (NSString *)label {
	
	// The day doesn't matter because the month and year are the label designators
	return [NSString stringWithFormat:@"%@", [[[[NTSDateOnly alloc] initWithYear:self.year month:self.month day:1] dateValue] descriptionWithCalendarFormat:@"%b %Y" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]]];
}

- (NSInteger)integerValue {
	return (year * 100) + month;
}

- (void)incrementMonth {
	self.month++;
	if (self.month > 12) {
		self.year++;
		self.month -= 12;
	}
}

- (void)decrementMonth {
	self.month--;
	if (self.month < 1) {
		self.year--;
		self.month = 12;
	}
}

- (BOOL)isCurrent {
	NTSYearMonth *currentYearMonth = [[NTSYearMonth alloc] init];
	return (self.year == currentYearMonth.year && self.month == currentYearMonth.month) ? YES : NO;
}

- (BOOL)containsDate:(NTSDateOnly *)aDate {
	return ([aDate isLessThan:[self createStartDate]] || [aDate isGreaterThan:[self createEndDate]]) ? NO : YES;
}

- (NTSDateOnly *)createDateWithDay:(NSInteger)dayOfMonth {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger monthToUse = (dayOfMonth < 1) ? self.month + 1 : self.month;
	[comps setDay:dayOfMonth];
	[comps setMonth:monthToUse];
	[comps setYear:self.year];
	NSDate *testDate = [[NSDate currentCalendar] dateFromComponents:comps];
	return [[NTSDateOnly alloc] initWithDate:testDate];
}

- (NTSDateOnly *)createStartDateWithDay:(NSInteger)dayOfMonth {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger monthToUse = self.month; // (dayOfMonth < 1) ? self.month + 1 : self.month;
	if (dayOfMonth > 15)
		monthToUse--;
	[comps setDay:dayOfMonth];
	[comps setMonth:monthToUse];
	[comps setYear:self.year];
	return [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateFromComponents:comps]];
}

- (NTSDateOnly *)createEndDateWithDay:(NSInteger)dayOfMonth {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger monthToUse = self.month; // (dayOfMonth < 1) ? self.month + 1 : self.month;
	if (dayOfMonth <= 15)
		monthToUse++;
	[comps setDay:dayOfMonth - 1];
	[comps setMonth:monthToUse];
	[comps setYear:self.year];
	return [[NTSDateOnly alloc] initWithDate:[[NTSDateOnly currentCalendar] dateFromComponents:comps]];
}

- (NTSDateOnly *)createStartDate {
	return [self createStartDateWithDay:self.day];
}

- (NTSDateOnly *)createEndDate {
	return [self createEndDateWithDay:self.day];
}

- (BOOL)isFirstHalfDate:(NTSDateOnly *)aDate {
	
	return ([aDate isGreaterThanOrEqualTo:[self firstHalfStartDate]] && [aDate isLessThanOrEqualTo:[self firstHalfEndDate]]) ? YES : NO;
}

- (NTSDateOnly *)firstHalfStartDate {

	return [[self createStartDate] dateByAddingDays:FIRST_HALF_START_DAYS];
}

- (NTSDateOnly *)firstHalfEndDate {

	return [[self createStartDate] dateByAddingDays:FIRST_HALF_END_DAYS];
}

- (NSString *)labelWithFirstHalfDate:(NTSDateOnly *)aDate {

	return [NSString stringWithFormat:@"%@/%@", [self label], ([self isFirstHalfDate:aDate]) ? NSLocalizedString(@"First Half", @"First Half") : NSLocalizedString(@"Second Half", @"Second Half")];
}

@synthesize year;
@synthesize month;
@synthesize day;

@end
