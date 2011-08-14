//
//  SettingPauseTimeCell.m
//  Voice
//
//  Created by JiaLi on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingPauseTimeCell.h"


@implementation SettingPauseTimeCell
@synthesize label = _label;
@synthesize slider = _slider;
@synthesize timeLabel = _timeLabel;
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [self.label release];
    [self.slider release];
    [self.timeLabel release];
    [super dealloc];
}

- (IBAction)onSettingTimeInterval;
{
    [delegate didSettingTimeInterval:self.slider.value];
    self.timeLabel.text = [NSString stringWithFormat:@"%0.1fs", self.slider.value];
    
}

- (IBAction)onChangedTimeInterval;
{
    self.timeLabel.text = [NSString stringWithFormat:@"%0.1fs", self.slider.value];
  
}

@end
