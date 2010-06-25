//
//  NTSYearMonth.h
//  MoneyWell
//
//  Created by Kevin Hoctor on 10/20/09.
//  Copyright 2009 No Thirst Software LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NTSDateOnly;

@interface NTSYearMonth : NSObject {
	NSInteger year;
	NSInteger month;
	NSInteger day;
}

- (id)initWithDate:(NSDate *)aDate;
- (id)initWithDateOnly:(NTSDateOnly *)aDate;
- (id)initWithDateOnly:(NTSDateOnly *)aDate startDay:(NSInteger)aDay;
- (id)initWithYearMonth:(NTSYearMonth *)aYearMonth;
- (id)initWithInteger:(NSInteger)aYearMonth;
- (id)initWithDay:(NSInteger)aDay;
- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth;
- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay;

- (NSString *)label;
- (NSInteger)integerValue;
- (void)incrementMonth;
- (void)decrementMonth;
- (BOOL)isCurrent;
- (BOOL)containsDate:(NTSDateOnly *)aDate;
- (NTSDateOnly *)createDateWithDay:(NSInteger)dayOfMonth;
- (NTSDateOnly *)createStartDateWithDay:(NSInteger)dayOfMonth;
- (NTSDateOnly *)createEndDateWithDay:(NSInteger)dayOfMonth;
- (NTSDateOnly *)createStartDate;
- (NTSDateOnly *)createEndDate;

- (BOOL)isFirstHalfDate:(NTSDateOnly *)aDate;
- (NTSDateOnly *)firstHalfStartDate;
- (NTSDateOnly *)firstHalfEndDate;
- (NSString *)labelWithFirstHalfDate:(NTSDateOnly *)aDate;

@property(assign) NSInteger year;
@property(assign) NSInteger month;
@property(assign) NSInteger day;

@end
