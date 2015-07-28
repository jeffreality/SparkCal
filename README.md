# SparkCal
iOS implementation of `SparkCal` component - a tiny "sparkline" style visualizer for events that happen over calendar time

## Overview

This is a new way to visualize events occurring over time.

![default sparkcal view](README-images/sparkcal.png?raw=true)

A `sparkline` is a small graphic designed to give a quick representation of numerical or statistical information within a piece of text, taking the form of a graph without axes. They were referenced in "The Visual Display of Quantitative Information" by Edward Tufte (1982).

A `SparkCal` is the sparkline-style representation of a calendar, plotting events that happen over time in a minimal format.

![default sparkcal view](README-images/demo-timeline.png?raw=true)

(The above example shows three sample project timelines.  Different colors are used to represent different activities.  This is further explored in the second demo.)

## Quick Implementation Examples

There are two demo projects using the SparkCal library (and helper categories).

![default sparkcal view](README-images/example1.png?raw=true)

Example 1: tiny, black-and-white with only default values (all on)

    SparkCal *cal1 = [[SparkCal alloc] initWithFrame:CGRectMake(60, 60, 18, 18)];
    [self.view addSubview:cal1];

![default sparkcal view](README-images/example2.png?raw=true)

Example 2: small, with custom colors

    SparkCal *cal2 = [[SparkCal alloc] initWithFrame:CGRectMake(60, 100, 40, 40)];
    [cal2 setMainColors:@[RGB(232,237,244), RGB(149,172,202)]];
    [self.view addSubview:cal2];

![default sparkcal view](README-images/example3.png?raw=true)

Example 3: large, non-blended days, with a date range set

    SparkCal *cal3 = [[SparkCal alloc] initWithFrame:CGRectMake(60, 160, 120, 120)];
    [cal3 setDate:[NSDate date]];
    [cal3 setColor:RGB(255, 66, 44) fromDate:[[NSDate date] dateWithinCurrentMonthFor:2] toDate:[[NSDate date] dateWithinCurrentMonthFor:4]];
    [self.view addSubview:cal3];

![default sparkcal view](README-images/example4.png?raw=true)

Example 4: large with blended days, custom colors per range
This is for anyone who may need to manually set colors in specific coordinates
without using any of the date methods

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
    
## Advanced Implementation

The second demo project explores this in more detail.

It generates a tableview of random "iOS projects" (randomizing Web 2.0 style names), along with random timelines for each example.  Controls on the bottom of the screen allows toggling the different colors, as well as blending the days (or seeing each day's dot separated).

![default sparkcal view](README-images/demo2.png?raw=true)

When the colored circle of each key in the legend is clicked, it fades the other colors, so you can visually scan and see how long a particular item takes of the overall project time across all projects.

![default sparkcal view](README-images/toggle-animation.gif?raw=true)


