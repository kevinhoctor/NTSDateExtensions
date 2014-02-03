//
//  NTSYearMonth.h
//
//  Created by Kevin Hoctor on 10/20/09.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
//

@class NTSDateOnly;

@interface NTSYearMonth : NSObject <NSCopying> {
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

- (NSComparisonResult)compare:(NTSYearMonth *)other;

@property (assign) NSInteger year;
@property (assign) NSInteger month;
@property (assign) NSInteger day;

@end
