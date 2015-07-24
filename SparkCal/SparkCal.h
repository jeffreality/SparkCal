//
//  SparkCal.h
//  SparkCal
//
//  Created by Jeffrey Berthiaume on 5/26/15.
//  Copyright (c) 2015 Pushplay.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SparkCal : UIView

- (void) setForegroundColor:(UIColor *)fgColor;
- (void) setMainColors:(NSArray *)colorArray;
- (void) setColors:(NSArray *)colorArray forDays:(NSArray *)dayArray;
- (void) enableBorderBetweenDays;
- (void) disableBorderBetweenDays;

- (void) setDate:(NSDate *)date;
- (void) setColor:(UIColor *)color fromDate:(NSDate *)startDate toDate:(NSDate *)endDate;
- (void) replaceColor:(UIColor *)origColor with:(UIColor *)newColor;

@end
