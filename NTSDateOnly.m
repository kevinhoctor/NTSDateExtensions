//
//  NTSDateOnly.m
//
//  Created by Kevin Hoctor on 11/25/09.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
//

#import "NTSDateOnly.h"

#import "NSDate+NTSAdditions.h"
#import "NTSYearMonth.h"


NSString *const NTSDateOnlyCurrentCalendarKey = @"NTSDateOnlyCurrentCalendarKey";

@implementation NTSDateOnly

@synthesize dateYMD;

+ (NSCalendar *)currentCalendar
{
    NSThread *currentThread = [NSThread currentThread];
    if (currentThread == nil) { //ZOMBIE THREAD!!
        return [NSCalendar currentCalendar];
    }
    
    NSCalendar *cachedThreadCalendar = [currentThread.threadDictionary objectForKey:NTSDateOnlyCurrentCalendarKey];
    if (cachedThreadCalendar == nil) {
        cachedThreadCalendar = [NSCalendar currentCalendar];
        [currentThread.threadDictionary setObject:cachedThreadCalendar forKey:NTSDateOnlyCurrentCalendarKey];
    }
    
	return cachedThreadCalendar;
}

+ (NTSDateOnly *)today
{
	return [[NTSDateOnly alloc] init];
}

+ (NTSDateOnly *)tomorrow
{
	NTSDateOnly *tomorrow = [[self today] dateByAddingDays:1];
    
	return tomorrow;
}

+ (NTSDateOnly *)yesterday
{
	NTSDateOnly *yesterday = [[self today] dateByAddingDays:-1];

	return yesterday;
}

+ (NTSDateOnly *)startOfWeekDate:(NTSDateOnly *)aDate
{
    return [NTSDateOnly dateOnlyWithDate:[NSDate startOfWeekDate:[aDate dateValue]]];
}

+ (NTSDateOnly *)startOfMonthDate:(NTSDateOnly *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	return [[NTSDateOnly alloc] initWithYear:[aDate year] month:[aDate month] day:1];
}

+ (NTSDateOnly *)startOfYearDate:(NTSDateOnly *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	return [[NTSDateOnly alloc] initWithYear:[aDate year] month:1 day:1];
}

+ (NTSDateOnly *)startOfPreviousYearDate:(NTSDateOnly *)aDate
{
    if (aDate == nil) {
        return nil;
    }
    
    return [[NTSDateOnly alloc] initWithYear:[aDate year] - 1 month:1 day:1];
}

+ (NTSDateOnly *)endOfWeekDate:(NTSDateOnly *)aDate
{
    return [NTSDateOnly dateOnlyWithDate:[NSDate endOfWeekDate:[aDate dateValue]]];
}

+ (NTSDateOnly *)endOfMonthDate:(NTSDateOnly *)aDate;
{
    return [NTSDateOnly dateOnlyWithDate:[NSDate endOfMonthDate:[aDate dateValue]]];
}

+ (NTSDateOnly *)endOfYearDate:(NTSDateOnly *)aDate;
{
    return [NTSDateOnly dateOnlyWithDate:[NSDate endOfYearDate:[aDate dateValue]]];
}

+ (NTSDateOnly *)dateWithNumber:(NSNumber *)aNumber
{
	return [[NTSDateOnly alloc] initWithNumber:aNumber];
}

+ (NTSDateOnly *)dateOnlyWithDate:(NSDate *)aDate
{
	return [[NTSDateOnly alloc] initWithDate:aDate];
}

- (id)init
{
	return [self initWithDate:[NSDate date]];
}

- (id)initWithDate:(NSDate *)aDate
{
	NSUInteger aDateYMD = 0;
	if (aDate != nil) {
		NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:aDate];
		aDateYMD = ([comps year] * 10000) + ([comps month] * 100) + [comps day];
	}
	return [self initWithDateYMD:aDateYMD];
}

- (id)initWithYearMonth:(NTSYearMonth *)aYearMonth
{
	return [self initWithYear:[aYearMonth year] month:[aYearMonth month] day:[aYearMonth day]];
}

- (id)initWithDay:(NSInteger)aDay
{
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	return [self initWithYear:[comps year] month:[comps month] day:aDay];
}

- (id)initWithMonth:(NSInteger)aMonth day:(NSInteger)aDay
{
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	return [self initWithYear:[comps year] month:aMonth day:aDay];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth
{
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSDayCalendarUnit) fromDate:[NSDate date]];
	return [self initWithYear:aYear month:aMonth day:[comps day]];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:aDay];
	[comps setMonth:aMonth];
	[comps setYear:aYear];
	NSDate *normalizedDate = [[NTSDateOnly currentCalendar] dateFromComponents:comps];
	comps = nil;
	comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:normalizedDate];
	NSUInteger aDateYMD = ([comps year] * 10000) + ([comps month] * 100) + [comps day];

	return [self initWithDateYMD:aDateYMD];
}

- (id)initWithNumber:(NSNumber *)aNumber
{
	return [self initWithDateYMD:[aNumber unsignedIntValue]];
}

- (id)initWithDateYMD:(NSUInteger)aDateYMD
{
	self = [super init];
	if (self != nil) {
		dateYMD = aDateYMD;
	}
	return self;
}

- (const char *)objCType
{
	return @encode(unsigned int);
}

- (unsigned int)unsignedIntValue
{
	return (unsigned int)dateYMD;
}

- (unsigned int)intValue
{
	return (unsigned int)dateYMD;
}

- (long long)longLongValue
{
	return dateYMD;
}

- (const char *)UTF8String
{
	return [[NSString stringWithFormat:@"%lu", (unsigned long)dateYMD] UTF8String];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%lu", (unsigned long)dateYMD];
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"{\nyear: %ld\nmonth: %ld\nday: %ld\n}", (long)[self year], (long)[self month], (long)[self day]];
}

- (NSInteger)year
{
	return dateYMD / 10000;
}

- (NSInteger)month
{
	return (dateYMD / 100) % 100;
}

- (NSInteger)day
{
	return dateYMD % 100;
}

- (NSInteger)dayOfTheWeek
{
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:NSWeekdayCalendarUnit fromDate:[self dateValue]];
	return [comps weekday]; 
}

- (NSDate *)dateValue
{
	if ([self unsignedIntValue] == 0) {
		return nil;
	}

	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:[self day]];
	[comps setMonth:[self month]];
	[comps setYear:[self year]];
	NSDate *date = [[NTSDateOnly currentCalendar] dateFromComponents:comps];

	return date;
}

- (NSNumber *)numberValue
{
	return [NSNumber numberWithUnsignedLong:dateYMD];
}

- (NSComparisonResult)compare:(NTSDateOnly *)other
{
    if ([self dateYMD] < [other dateYMD]) {
        return NSOrderedAscending;
    } else if ([self dateYMD] > [other dateYMD]) {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}

- (BOOL)isEqualTo:(NTSDateOnly *)aDate
{
	return (self.dateYMD == aDate.dateYMD) ? YES : NO;
}

- (BOOL)isLessThan:(NTSDateOnly *)aDate
{
	return (self.dateYMD < aDate.dateYMD) ? YES : NO;
}

- (BOOL)isLessThanOrEqualTo:(NTSDateOnly *)aDate
{
	return (self.dateYMD <= aDate.dateYMD) ? YES : NO;
}

- (BOOL)isGreaterThan:(NTSDateOnly *)aDate
{
	return (self.dateYMD > aDate.dateYMD) ? YES : NO;
}

- (BOOL)isGreaterThanOrEqualTo:(NTSDateOnly *)aDate
{
	return (self.dateYMD >= aDate.dateYMD) ? YES : NO;
}

- (NTSDateOnly *)dateByAddingDays:(NSInteger)days
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:days];
	NTSDateOnly *date = [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateByAddingComponents:comps toDate:[self dateValue] options:0]];
	comps = nil;
	return date;
}

- (NTSDateOnly *)dateByAddingWeeks:(NSInteger)weeks
{
	return [self dateByAddingDays:(weeks * 7)];
}

- (NTSDateOnly *)dateByAddingMonths:(NSInteger)months
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:months];
	NTSDateOnly *date = [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateByAddingComponents:comps toDate:[self dateValue] options:0]];
	comps = nil;
	return date;
}

- (NTSDateOnly *)dateByAddingYears:(NSInteger)years
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:years];
	NTSDateOnly *date = [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateByAddingComponents:comps toDate:[self dateValue] options:0]];
	comps = nil;
	return date;
}

- (NSInteger)timeIntervalInDaysSinceDate:(NTSDateOnly *)referenceDate
{
    return [[self dateValue] timeIntervalInDaysSinceDate:[referenceDate dateValue]];
}

- (NSString *)label
{
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
	return [NSString stringWithFormat:@"%@", [self dateValue]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
	return [NSString stringWithFormat:@"%@", [[self dateValue] descriptionWithCalendarFormat:@"%d %b %Y" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]]];
#endif
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[NTSDateOnly allocWithZone:zone] initWithDateYMD:self.dateYMD];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[NTSDateOnly class]] == NO) {
        return NO;
    }
    
    NTSDateOnly *dateOnlyObject = (NTSDateOnly *)object;
    
    return (dateOnlyObject.year == self.year && dateOnlyObject.month == self.month && dateOnlyObject.day == self.day);
}

- (NSUInteger)hash
{
    return [self unsignedIntValue];
}

@end
