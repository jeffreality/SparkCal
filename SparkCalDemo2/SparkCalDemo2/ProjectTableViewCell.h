//
//  ProjectTableViewCell.h
//  SparkCalDemo2
//
//  Created by Jeffrey Berthiaume on 7/23/15.
//  Copyright (c) 2015 Pushplay.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *timeline;

- (void) setupData:(NSDictionary *)data;

@end
