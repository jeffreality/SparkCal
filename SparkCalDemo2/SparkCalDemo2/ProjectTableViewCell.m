//
//  ProjectTableViewCell.m
//  SparkCalDemo2
//
//  Created by Jeffrey Berthiaume on 7/23/15.
//  Copyright (c) 2015 Pushplay.net. All rights reserved.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell

@synthesize timeline;

- (void) setupData:(NSDictionary *)data {
    self.textLabel.text = [data objectForKey:@"name"];
    
    if (timeline) {
        [timeline removeFromSuperview];
        timeline = nil;
    }
    
    timeline = [[UIView alloc] initWithFrame:(CGRect){ 100.0f, 0, self.frame.size }];
    
    // I'm not handling scrolling; I'm just going to keep adding months in sequence for this demo
    NSArray *months = [data objectForKey:@"timeline"];
    for (NSInteger j = 0; j < [months count]; j++) {
        [[months objectAtIndex:j] setNeedsDisplay];
        [timeline addSubview:[months objectAtIndex:j]];
    }
    
    [self.contentView addSubview:timeline];
}

@end
