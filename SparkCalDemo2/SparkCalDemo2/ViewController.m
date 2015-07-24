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
@property (nonatomic, strong) NSArray *legendTitles;
@property (nonatomic, strong) NSArray *legendColors;
@property (nonatomic, strong) NSMutableArray *currentColors;

@end

@implementation ViewController

#define RGB(r,g,b)                      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define MAX_PROJECTS_TO_GENERATE        20

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.legendTitles = @[@"UX/Wireframing", @"Graphic Design", @"Coding", @"Testing/QA", @"Product Launch"];
    self.legendColors = @[[UIColor redColor], [UIColor orangeColor], RGB(34,139,34), [UIColor blueColor], RGB(255,20,147)];
    self.currentColors = [self.legendColors mutableCopy];
    
    [self drawLegend];
    
    [self generateData];
    [self.tv reloadData];
}

#pragma mark - Change the look of the SparkCals

- (void) changeSparkCals:(void(^)(SparkCal *cal))calBlock {
    // go through data and switch blend values
    for (NSInteger j = 0; j < [self.data count]; j++) {
        NSDictionary *dict = [self.data objectAtIndex:j];
        NSMutableArray *timeline = [[dict objectForKey:@"timeline"] mutableCopy];
        for (NSInteger k = 0; k < [timeline count]; k++) {
            SparkCal *cal = [timeline objectAtIndex:k];
            calBlock(cal);
            [timeline setObject:cal atIndexedSubscript:k];
        }
        [self.data setObject:@{ @"name" : [dict objectForKey:@"name"], @"timeline" : [timeline copy] } atIndexedSubscript:j];
    }
    
    // then reload table data
    [self.tv reloadData];
    
}

- (IBAction)changeBlend:(UISwitch *)blendSwitch {
    [self changeSparkCals:^(SparkCal *cal) {
        if (blendSwitch.on)
            [cal disableBorderBetweenDays];
        else
            [cal enableBorderBetweenDays];
    }];
}

- (UIColor*)changeAlpha:(UIColor*)color amount:(CGFloat)amount {
    CGFloat hue, saturation, brightness, alpha;
    if ([color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:amount];
    }
    
    CGFloat white;
    if ([color getWhite:&white alpha:&alpha]) {
        return [UIColor colorWithWhite:white alpha:amount];
    }
    
    return nil;
}

- (void)fadeColorsExcept:(UIButton *)sender {
    NSInteger colorIndex = sender.tag;
    [self changeSparkCals:^(SparkCal *cal) {
        for (NSInteger c = 0; c < [self.legendColors count]; c++) {
            if (c != colorIndex) {
                UIColor *newColor = [self changeAlpha:[self.legendColors objectAtIndex:c] amount:0.2f];
                [cal replaceColor:[self.currentColors objectAtIndex:c] with:newColor];
            } else {
                [cal replaceColor:[self.currentColors objectAtIndex:c] with:[self.legendColors objectAtIndex:c]];
            }
        }
    }];
    for (NSInteger c = 0; c < [self.legendColors count]; c++) {
        if (c != colorIndex) {
            UIColor *newColor = [self changeAlpha:[self.legendColors objectAtIndex:c] amount:0.2f];
            [self.currentColors setObject:newColor atIndexedSubscript:c];
        } else {
            [self.currentColors setObject:[self.legendColors objectAtIndex:c] atIndexedSubscript:c];
        }
    }
    [self redrawColorButtons];
}

- (IBAction)restoreColors:(id)sender {
    [self changeSparkCals:^(SparkCal *cal) {
        for (NSInteger c = 0; c < [self.legendColors count]; c++) {
            [cal replaceColor:[self.currentColors objectAtIndex:c] with:[self.legendColors objectAtIndex:c]];
        }
    }];
    self.currentColors = [self.legendColors mutableCopy];
    [self redrawColorButtons];
}

#pragma mark - Legend (at bottom of screen)

- (void) redrawColorButtons {
    for (UIView *b in self.legend.subviews){
        if([b isKindOfClass:[UIButton class]] && b.tag >= 0){
            UIButton *btn = (UIButton *)b;
            [btn setBackgroundColor:[self.currentColors objectAtIndex:btn.tag]];
        }
    }
}

- (void) drawLegend {
    
    for (NSInteger j = 0; j < [self.legendTitles count]; j++) {
        UIButton *c = [UIButton buttonWithType:UIButtonTypeCustom];
        c.tag = j;
        c.frame = CGRectMake(8, 8 + ((12 + 22) * j), 22, 22);
        [c setBackgroundColor:[self.legendColors objectAtIndex:j]];
        c.layer.cornerRadius = 11;
        [c addTarget:self action:@selector(fadeColorsExcept:) forControlEvents:UIControlEventTouchUpInside];
        [self.legend addSubview:c];
        
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(38, 4 + ((4 + 30) * j), 200, 30)];
        t.text = [self.legendTitles objectAtIndex:j];
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
    for (NSInteger j = 0; j < MAX_PROJECTS_TO_GENERATE; j++) {
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
            [cal setColor:[self.legendColors objectAtIndex:0] fromDate:dateBizReqStart toDate:dateBizReqEnd];
        }
        
        if (monthIdx >= [dateDesignStart monthValue] && monthIdx <= [dateDesignEnd monthValue]) {
            // biz requirements
            [cal setColor:[self.legendColors objectAtIndex:1] fromDate:dateDesignStart toDate:dateDesignEnd];
        }
        
        if (monthIdx >= [dateDevStart monthValue] && monthIdx <= [dateDevEnd monthValue]) {
            // biz requirements
            [cal setColor:[self.legendColors objectAtIndex:2] fromDate:dateDevStart toDate:dateDevEnd];
        }
        
        if (monthIdx >= [dateTestStart monthValue] && monthIdx <= [dateTestEnd monthValue]) {
            // biz requirements
            [cal setColor:[self.legendColors objectAtIndex:3] fromDate:dateTestStart toDate:dateTestEnd];
        }
        
        if (monthIdx == [dateLaunch monthValue]) {
            // biz requirements
            [cal setColor:[self.legendColors objectAtIndex:4] fromDate:dateLaunch toDate:dateLaunch];
        }
        
        [arrViews addObject:cal];
        
    }
    
    return ([arrViews copy]);
}

@end
