//
//  ViewController.m
//  SparkCalDemo2
//
//  Created by Jeffrey Berthiaume on 7/23/15.
//  Copyright (c) 2015 Pushplay.net. All rights reserved.
//

#import "ViewController.h"

#import "ProjectTableViewCell.h"

#import "SparkCal.h"
#import "NSDate+Components.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tv;
@property (nonatomic, weak) IBOutlet UIView *legend;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ViewController

#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawLegend];
    
    [self generateData];
    [self.tv reloadData];
}

#pragma mark - Switch (at bottom of screen)

- (IBAction)changeBlend:(UISwitch *)blendSwitch {
    // go through data and switch blend values
    for (NSInteger j = 0; j < [self.data count]; j++) {
        /*
         [self.data addObject:@{
         @"name" : [self generateProjectName],
         @"timeline" : [self generateTimeline]
         }];
         */
        NSDictionary *dict = [self.data objectAtIndex:j];
        NSMutableArray *timeline = [[dict objectForKey:@"timeline"] mutableCopy];
        for (NSInteger k = 0; k < [timeline count]; k++) {
            SparkCal *cal = [timeline objectAtIndex:k];
            if (blendSwitch.on)
                [cal disableBorderBetweenDays];
            else
                [cal enableBorderBetweenDays];
            [timeline setObject:cal atIndexedSubscript:k];
        }
        [self.data setObject:@{ @"name" : [dict objectForKey:@"name"], @"timeline" : [timeline copy] } atIndexedSubscript:j];
    }
    
    // then reload table data
    [self.tv reloadData];
}

#pragma mark - Legend (at bottom of screen)

- (void) drawLegend {
    NSArray *titles = @[@"UX/Wireframing", @"Graphic Design", @"Coding", @"Testing/QA", @"Product Launch"];
    NSArray *colors = @[[UIColor redColor], [UIColor orangeColor], RGB(34,139,34), [UIColor blueColor], RGB(255,20,147)];
    
    for (NSInteger j = 0; j < [titles count]; j++) {
        float downBlend = 2.4;
        if (j + 1 == [titles count])
            downBlend = 1;
        UIView *c = [[UIView alloc] initWithFrame:CGRectMake(8, 8 + ((12 + 22) * j), 22, 22*downBlend)];
        [c setBackgroundColor:[colors objectAtIndex:j]];
        c.layer.cornerRadius = 11;
        [self.legend addSubview:c];
        
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(38, 4 + ((4 + 30) * j), 200, 30)];
        t.text = [titles objectAtIndex:j];
        [self.legend addSubview:t];
    }
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"projectCell";
    ProjectTableViewCell *cell = (ProjectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ProjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setupData:[self.data objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Data generator

- (void) generateData {
    self.data = [@[] mutableCopy];
    for (NSInteger j = 0; j < 20; j++) {
        [self.data addObject:@{
                               @"name" : [self generateProjectName],
                               @"timeline" : [self generateTimeline]
                               }];
    }
}

- (NSString *)generateProjectName {
    // Web 2.0 style names from http://www.dotomator.com/
    NSArray *prefixes = @[@"Co", @"Cogi", @"Do", @"Fa", @"Ka", @"Ki", @"My", @"Pho", @"Pro", @"Qua", @"Ska", @"Twi", @"Vi", @"Wa", @"Ya", @"Yo"];
    NSArray *suffixes = @[@"ble", @"ba", @"deo", @"do", @"hoo", @"jo", @"mbo", @"ndo", @"nix", @"tz", @"vee", @"yo", @"zio", @"zu", @"zzle"];
    
    return  ([NSString stringWithFormat:@"%@%@",
              [prefixes objectAtIndex:arc4random() % [prefixes count]],
              [suffixes objectAtIndex:arc4random() % [suffixes count]]
              ]);
}

- (NSArray *) generateTimeline {
    // return an array of SparkCal views
    NSMutableArray *arrViews = [@[] mutableCopy];
    
    NSInteger startMonth = arc4random() % 4 + 1; // jan to apr, so I don't have to worry about faking wrapping around a year
    NSInteger startDay = arc4random() % 22 + 2; // range from 2 to 24
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear = [[formatter stringFromDate:[NSDate date]] integerValue];
    
    NSDate *dateBizReqStart = [[NSDate date] dateFromDay:startDay andMonth:startMonth andYear:currentYear];
    NSDate *dateBizReqEnd = [dateBizReqStart dateByAddingTimeInterval:60*60*24*(arc4random() % 7 + 7)]; // between 1-2 weeks
    
    NSDate *dateDesignStart = [dateBizReqEnd dateByAddingTimeInterval:60*60*24*(arc4random() % 4)];
    NSDate *dateDesignEnd = [dateDesignStart dateByAddingTimeInterval:60*60*24*(arc4random() % 21 + 21)]; // between 3-6 weeks
    
    NSDate *dateDevStart = [dateDesignEnd dateByAddingTimeInterval:60*60*24*(arc4random() % 8)];
    NSDate *dateDevEnd = [dateDevStart dateByAddingTimeInterval:60*60*24*(arc4random() % 28 + 28)]; // between 4-8 weeks
    
    NSDate *dateTestStart = [dateDevEnd dateByAddingTimeInterval:60*60*24*1];
    NSDate *dateTestEnd = [dateTestStart dateByAddingTimeInterval:60*60*24*(arc4random() % 7 + 7)]; // between 1-2 weeks
    
    NSDate *dateLaunch = [dateTestEnd dateByAddingTimeInterval:60*60*24*1];
    
    //NSLog(@"\nPROJECT\nbizreq : %@ - %@\ndesign : %@ - %@\ndevelop: %@ - %@\ntesting: %@ - %@\nlaunch : %@", dateBizReqStart, dateBizReqEnd, dateDesignStart, dateDesignEnd, dateDevStart, dateDevEnd, dateTestStart, dateTestEnd, dateLaunch);
    
    NSInteger endMonth = [dateLaunch monthValue];
    
    for (NSInteger monthIdx = startMonth; monthIdx <= endMonth; monthIdx++) {
        
        SparkCal *cal = [[SparkCal alloc] initWithFrame:CGRectMake(4 + ((4 + 30) * monthIdx), 4, 30, 30)];
        [cal disableBorderBetweenDays];
        [cal setForegroundColor:RGB(220, 220, 220)];
        
        NSDate *currentDate = [[NSDate date] dateFromDay:1 andMonth:monthIdx andYear:currentYear];
        [cal setDate:currentDate];
        
        if (monthIdx >= [dateBizReqStart monthValue] && monthIdx <= [dateBizReqEnd monthValue]) {
            // biz requirements
            [cal setColor:[UIColor redColor] fromDate:dateBizReqStart toDate:dateBizReqEnd];
        }
        
        if (monthIdx >= [dateDesignStart monthValue] && monthIdx <= [dateDesignEnd monthValue]) {
            // biz requirements
            [cal setColor:[UIColor orangeColor] fromDate:dateDesignStart toDate:dateDesignEnd];
        }
        
        if (monthIdx >= [dateDevStart monthValue] && monthIdx <= [dateDevEnd monthValue]) {
            // biz requirements
            [cal setColor:RGB(34,139,34) fromDate:dateDevStart toDate:dateDevEnd];
        }
        
        if (monthIdx >= [dateTestStart monthValue] && monthIdx <= [dateTestEnd monthValue]) {
            // biz requirements
            [cal setColor:[UIColor blueColor] fromDate:dateTestStart toDate:dateTestEnd];
        }
        
        if (monthIdx == [dateLaunch monthValue]) {
            // biz requirements
            [cal setColor:RGB(255,20,147) fromDate:dateLaunch toDate:dateLaunch];
        }
        
        [arrViews addObject:cal];
        
    }
    
    return ([arrViews copy]);
}

@end
