//
//  NTSDateFormatter.m
//
//  Created by Kevin Hoctor on 9/2/07.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
//

#import "NSDate+NTSAdditions.h"
#import "NTSDateFormatter.h"

@implementation NTSDateFormatter

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)errorString
{
	NSInteger monthStart = [[self dateFormat] rangeOfString:@"m" options:NSCaseInsensitiveSearch].location;
	NSInteger dayStart = [[self dateFormat] rangeOfString:@"d" options:NSCaseInsensitiveSearch].location;
	NSInteger yearStart = [[self dateFormat] rangeOfString:@"y" options:NSCaseInsensitiveSearch].location;
	NSInteger first = -1;
	NSInteger second = -1;
	NSInteger third = -1;
	NSScanner *scanner = [NSScanner localizedScannerWithString:string];
	NSMutableCharacterSet *workingSet;
	NSCharacterSet *finalCharSet;
	workingSet = [[NSCharacterSet punctuationCharacterSet] mutableCopy];
	[workingSet addCharactersInString:@" "];
	finalCharSet = [workingSet copy];
	[scanner setCharactersToBeSkipped:finalCharSet];
    finalCharSet = nil;

	if ([scanner scanInteger:&first]) {
		if ([scanner scanInteger:&second]) {
			[scanner scanInteger:&third];
		}
	}
	NSInteger month;
	NSInteger day;
	NSInteger year;

	if (third != -1 && yearStart < monthStart && yearStart < dayStart) {
		year = first;
		if (monthStart > dayStart) {
			day = second;
			month = third;
		} else {
			month = second;
			day = third;
		}
	} else {
		if (monthStart > dayStart || second == -1) {
			day = first;
			month = second;
		} else {
			month = first;
			day = second;
		}
		year = third;
	}
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate zeroHourToday]];
	if (day == -1) {
		day = [comps day];
	}
	if (month == -1) {
		month = [comps month];
	}
	if (year == -1) {
		year = [comps year];
	}
	if (year < 50) {
		year += 2000;
	} else if (year < 100) {
		year += 1900;
	}
	[comps setYear:year];
	[comps setMonth:month];
	[comps setDay:day];
	NSDate *date = [[NSDate currentCalendar] dateFromComponents:comps];
	*obj = date;

	if (date == nil) {
		*errorString = [NSString stringWithFormat:NSLocalizedString(@"Invalid date: %@", @"Invalid date: %@"), string];
		return NO;
	}

	return YES;
}

- (NSString *)stringForObjectValue:(id)anObject
{
	return [super stringForObjectValue:anObject];
}

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString **)error
{
	return YES;
}

- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString **)newString errorDescription:(NSString **)error
{
	return YES;
}

@end
