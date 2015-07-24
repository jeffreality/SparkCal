//
//  SparkCal.m
//  SparkCal
//
//  Created by Jeffrey Berthiaume on 5/26/15.
//  Copyright (c) 2015 Pushplay.net. All rights reserved.
//

#import "SparkCal.h"

#import "UIColor+Comparison.h"
#import "NSDate+Components.h"

@interface SparkCal () {
    NSDate *currentMonthYear;
    UIColor *backgroundColor, *mainColor;
    NSArray *colorList, *dayMatrix;
    BOOL blendDays;
}

@end

@implementation SparkCal


// ================================
// ==
// ==
// == Initialization
// ==
// ==
// ================================

- (void) initializeColors {
    backgroundColor = [UIColor whiteColor];
    mainColor = [UIColor blackColor];
    blendDays = NO;
}

-(id) init {
    self = [super init];
    if (self) { [self initializeColors]; }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) { [self initializeColors]; }
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { [self initializeColors]; }
    return self;
}

// ================================
// ==
// ==
// == Set date/day display colors
// ==
// ==
// ================================

- (void) enableBorderBetweenDays {
    blendDays = NO;
}

- (void) disableBorderBetweenDays {
    blendDays = YES;
}

- (void) setBackgroundColor:(UIColor *)bgColor {
    backgroundColor = bgColor;
}

- (void) setForegroundColor:(UIColor *)fgColor {
    mainColor = fgColor;
}

- (void) setMainColors:(NSArray *)colorArray {
    /*
     colorArray : an array of two UIColors
       - first entry: background color for the SparkCal view
       - second entry: primary color for the view
     */
    if ([colorArray count]) {
        if ([colorArray objectAtIndex:0] && [[colorArray objectAtIndex:0] isKindOfClass:[UIColor class]]) {
            backgroundColor = [colorArray objectAtIndex:0];
        }
        if ([colorArray objectAtIndex:1] && [[colorArray objectAtIndex:1] isKindOfClass:[UIColor class]]) {
            mainColor = [colorArray objectAtIndex:1];
        }
    }
}


- (void) setColors:(NSArray *)colorArray forDays:(NSArray *)dayArray {
    /*
     colorArray : an array of n UIColors
       - each entry will be referred in the dayArray by its index
     
     dayArray : an array of an array of color indices based on location in a 7 x 5 grid
     - each entry corresponds with one dot within the SparkCal view
     - each sub-array will be the colors to represent that day (colored sections within the dot)
     */
    
    colorList = colorArray;
    dayMatrix = dayArray;
}

- (void) setDate:(NSDate *)date {
    /*
     Sets the date for the sparkCal view (by zeroing out days from the first and last week to be displayed)
     */
    
    // get dow for first day
    // increment across until there
    // count rows down
    // get dow for last day
    // increment to end of array
    
    currentMonthYear = date;
    
    NSNumber *colorId = @([self addColor:mainColor]);
    
    NSMutableArray *dayMatrixMutable = [@[] mutableCopy];
    
    for (NSInteger j = 0; j < (5 * 7); j++)
        [dayMatrixMutable addObject:@[colorId]]; // This sets each day to "mainColor"
    
    NSDate *firstDay = [date firstDayOfMonth];
    
    NSInteger weekday = [firstDay dayOfWeekIndex] - 1; // weekday 1 = Sunday for Gregorian calendar
    
    for (NSInteger j = 0; j < weekday; j++)
        [dayMatrixMutable setObject:[NSNull null] atIndexedSubscript:j]; // This sets each previous month day to "backgroundColor"
    
    NSDate *lastDay = [date lastDayOfMonth];
    weekday = [lastDay dayOfWeekIndex] - 1;
    
    NSInteger weeksCount = [date numberOfWeeksInCurrentMonth] - 1;
    NSInteger dayPosition = 7 * weeksCount + weekday;
    
    for (NSInteger j = dayPosition; j < [dayMatrixMutable count]; j++)
        [dayMatrixMutable setObject:[NSNull null] atIndexedSubscript:j];
    
    dayMatrix = [dayMatrixMutable copy];
}

- (NSInteger) addColor:(UIColor *)color {
    /*
     Adds the color to the color list if it doesn't exist.
     Returns the index of the color within colorList.
     */
    NSMutableArray *colorListMutable = [colorList mutableCopy];
    if (!colorListMutable)
        colorListMutable = [@[] mutableCopy];
    
    NSInteger position = [colorList count];
    for (NSInteger j = 0; j < [colorList count]; j++) {
        if ([color isEqualToColor:[colorList objectAtIndex:j]]) {
            position = j;
            break;
        }
    }
    
    if (position < [colorList count]) {
        return position;
    }
    
    [colorListMutable addObject:color];
    
    colorList = [colorListMutable copy];
    
    return (position);
}

- (void) setColor:(UIColor *)color fromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSMutableArray *dayMatrixMutable = [dayMatrix mutableCopy];
    
    // add color to array if it doesn't exist
    NSNumber *colorId = @([self addColor:color]);
    
    // trim startDate to begin for current month
    // trim endDate to end on current month
    if (currentMonthYear) {
        // if startDate month is prior to current month, set startDate to day 1 of current month
        if ([startDate monthValue] < [currentMonthYear monthValue]) {
            startDate = [currentMonthYear firstDayOfMonth];
        }
        // if endDate month is after current month, set endDate to last day of current month
        if ([endDate monthValue] > [currentMonthYear monthValue]) {
            endDate = [currentMonthYear lastDayOfMonth];
        }
    }
    
    // day of week for item 1
    NSInteger startDay = ([[startDate firstDayOfMonth] dayOfWeekIndex] - 1); // move position to first "day" entry
    
    // skip forward to fromDate day
    startDay += [startDate dayValue] - 1;
    
    NSInteger endDay = [endDate dayValue];
    
    // set color until endDate day
    for (NSInteger j = startDay; j <= endDay; j++) {
        NSArray *day = [dayMatrixMutable objectAtIndex:j];
        if (!day || [day isEqual:[NSNull null]] || [day isEqual:@[@0]]) {
            day = @[];
        }
        day = [day arrayByAddingObject:colorId];
        [dayMatrixMutable setObject:day atIndexedSubscript:j];
    }
    
    dayMatrix = [dayMatrixMutable copy];
}

// ================================
// ==
// ==
// == Display method for drawing view
// ==
// ==
// ================================

- (void)drawRect:(CGRect)rect {
    
    // based on 18x18 pixel grid
    float pixelWidth = rect.size.width/18.0f;
    float pixelHeight = rect.size.height/18.0f;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
    CGContextFillRect(ctx, rect);
    
    // draw header background
    CGRect margin = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, pixelHeight * 4);
    CGContextSetFillColorWithColor(ctx, mainColor.CGColor);
    CGContextFillRect(ctx, margin);
    
    // draw left margin
    margin = CGRectMake(rect.origin.x, rect.origin.y, pixelWidth * 1, rect.size.height);
    CGContextSetFillColorWithColor(ctx, mainColor.CGColor);
    CGContextFillRect(ctx, margin);
    
    // draw bottom margin
    margin = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - pixelHeight * 1, rect.size.width, pixelHeight * 1);
    CGContextSetFillColorWithColor(ctx, mainColor.CGColor);
    CGContextFillRect(ctx, margin);
    
    // draw right margin
    margin = CGRectMake(rect.origin.x + rect.size.width - pixelWidth * 1, rect.origin.y, pixelWidth * 1, rect.size.height);
    CGContextSetFillColorWithColor(ctx, mainColor.CGColor);
    CGContextFillRect(ctx, margin);
    
    // set colors for days
    if (!colorList || ![colorList count])
        colorList = @[ backgroundColor, mainColor];
    if (!dayMatrix || ![dayMatrix count])
        dayMatrix = @[@[@1]];
    
    // draw each of the day boxes
    CGPoint topOrigin = (CGPoint){ pixelWidth * 2.25, pixelHeight * 4.75 };
    
    UIColor *lastColor = mainColor;
    
    for (NSInteger y = 0; y < 6; y++) {
        for (NSInteger x = 0; x < 7; x++) {
            
            NSArray *colors = @[];
            
            NSInteger currDay = y * 7 + x;
            if ([dayMatrix count] > currDay) {
                UIColor *newColor;
                NSArray *storedColorIndexes = [dayMatrix objectAtIndex:currDay];
                
                if ([storedColorIndexes isEqual:[NSNull null]])
                    newColor = backgroundColor;
                else {
                    if (colorList)
                        newColor = [colorList objectAtIndex:[[storedColorIndexes objectAtIndex:0] longValue]];
                    else
                        newColor = mainColor;
                }
                if (newColor && [newColor isKindOfClass:[UIColor class]])
                    lastColor = newColor;
                
                if (![storedColorIndexes isEqual:[NSNull null]] && [storedColorIndexes count] > 1) {
                    // set colors
                    for (NSInteger idx = 0; idx < [storedColorIndexes count]; idx++) {
                        lastColor = [colorList objectAtIndex:[[storedColorIndexes objectAtIndex:idx] longValue]];
                        colors = [colors arrayByAddingObject:lastColor];
                    }
                } else {
                    colors = @[lastColor];
                }
            }
            
            if (![colors count]) {
                colors = @[lastColor];
            }
                
            float blendShift = 0.0f;
            if (blendDays) {
                blendShift = 0.25 * pixelWidth;
            }
            
            for (NSInteger colorIdx = 0; colorIdx < [colors count]; colorIdx++) {
                float heightBox = (pixelHeight * 1.5) / [colors count];
                float heightOffset = heightBox * colorIdx;
                CGRect dayBox = CGRectMake(
                                           topOrigin.x + (pixelWidth * 2 * x) - blendShift,
                                           topOrigin.y + (pixelHeight * 2 * y) + heightOffset,
                                           pixelWidth * 1.5 + (blendShift * 2),
                                           heightBox
                                           );
                CGContextSetFillColorWithColor(ctx, ((UIColor *)[colors objectAtIndex:colorIdx]).CGColor);
                CGContextFillRect(ctx, dayBox);
            }
        }
    }
    
}

@end
