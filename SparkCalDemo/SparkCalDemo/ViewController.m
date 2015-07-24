//
//  ViewController.m
//  SparkCalDemo
//
//  Created by Jeffrey Berthiaume on 7/21/15.
//  Copyright (c) 2015 Pushplay.net. All rights reserved.
//

#import "ViewController.h"

#import "SparkCal.h"
#import "NSDate+Components.h"

@implementation ViewController

#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Example 1: tiny, black-and-white with only default values
    SparkCal *cal1 = [[SparkCal alloc] initWithFrame:CGRectMake(60, 60, 18, 18)];
    [self.view addSubview:cal1];
    
    
    
    
    // Example 2: small, with custom colors
    SparkCal *cal2 = [[SparkCal alloc] initWithFrame:CGRectMake(60, 100, 40, 40)];
    [cal2 setMainColors:@[RGB(232,237,244), RGB(149,172,202)]];
    [self.view addSubview:cal2];
    
    
    
    
    // Example 3: large, non-blended days, with a date range set
    SparkCal *cal3 = [[SparkCal alloc] initWithFrame:CGRectMake(60, 160, 120, 120)];
    [cal3 setDate:[NSDate date]];
    [cal3 setColor:RGB(255, 66, 44) fromDate:[[NSDate date] dateWithinCurrentMonthFor:2] toDate:[[NSDate date] dateWithinCurrentMonthFor:4]];
    [self.view addSubview:cal3];
    
    
    
    // Example 4: large with blended days, custom colors per range
    // This is for anyone who may need to manually set colors in specific coordinates
    // without using any of the date methods
    SparkCal *cal4 = [[SparkCal alloc] initWithFrame:CGRectMake(60, 300, 120, 120)];
    
    NSNull *n = [NSNull null];
    
    [cal4 disableBorderBetweenDays];
    [cal4 setColors:@[
                      [UIColor whiteColor],
                      RGB(247,249,249),
                      RGB(99, 210, 255),
                      RGB(32, 129, 195),
                      RGB(120, 213, 215),
                      RGB(35, 181, 211),
                      RGB(86, 114, 124),
                      RGB(190, 216, 212)
                      ]
            forDays:@[
                      n, @[@1], @[@1], @[@1], @[@1, @2], @[@2], @[@2],
                      @[@2], @[@2], @[@2], @[@2], @[@2], @[@3], @[@3],
                      @[@3], @[@3, @4], @[@4], @[@4], @[@4], @[@4], @[@4],
                      @[@4], @[@4], @[@4], @[@4, @5], @[@5], @[@5], @[@5],
                      @[@6], @[@6,@7], @[@7], @[@7], n, n, n
                      ]];
    [self.view addSubview:cal4];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
