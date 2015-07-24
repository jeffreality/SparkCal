//
//  NSDate+Components.h
//  SparkCal
//
//  Created by Jeffrey Berthiaume on 6/22/15.
//  Copyright (c) 2015 Pushplay.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Components)

- (NSInteger) dayOfWeekIndex;
- (NSDate *) firstDayOfMonth;
- (NSDate *) lastDayOfMonth;
- (NSInteger) numberOfWeeksInCurrentMonth;
- (NSInteger) dayValue;
- (NSInteger) monthValue;
- (NSInteger) yearValue;

- (NSDate *)dateFromDay:(NSInteger)day andMonth:(NSInteger)month andYear:(NSInteger)year;
- (NSDate *)dateWithinCurrentMonthFor:(NSInteger)day;

@end
