//
//  NSDate+Components.m
//  SparkCal
//
//  Created by Jeffrey Berthiaume on 6/22/15.
//  Copyright (c) 2015 Pushplay.net. All rights reserved.
//

#import "NSDate+Components.h"

@implementation NSDate (Components)

- (NSDate *)dateFromDay:(NSInteger)day andMonth:(NSInteger)month andYear:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    return ([calendar dateFromComponents:components]);
}

- (NSDate *)dateWithinCurrentMonthFor:(NSInteger)day {
    NSDate *currentDay = self;
    NSInteger month = [currentDay monthValue];
    NSInteger year = [currentDay yearValue];
    return ([self dateFromDay:day andMonth:month andYear:year]);
}

- (NSInteger) dayOfWeekIndex {
    // weekday 1 = Sunday for Gregorian calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:self];
    return ([weekdayComponents weekday]);
}

- (NSDate *) firstDayOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    [components setDay:1];
    return ([calendar dateFromComponents:components]);
}

- (NSDate *) lastDayOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *nextMonth = [calendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:self options:0];
    return ([calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:nextMonth options:0]);
}

- (NSInteger) numberOfWeeksInCurrentMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange weekRange = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self];
    return (weekRange.length);
}

- (NSInteger) dayValue {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return ([components day]);
}

- (NSInteger) monthValue {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return ([components month]);
}

- (NSInteger) yearValue {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return ([components year]);
}

@end
