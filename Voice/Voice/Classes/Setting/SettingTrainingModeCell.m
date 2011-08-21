//
//  SettingTrainingModeCell.m
//  Voice
//
//  Created by JiaLi on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingTrainingModeCell.h"


@implementation SettingTrainingModeCell
@synthesize label = _label;
@synthesize slider = _slider;
@synthesize timeLabel = _timeLabel;
@synthesize sliderText = _sliderText;

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
    [delegate didSettingTimeInterval:self.slider.value withTag:self.slider.tag];
    if (self.slider.tag == TAG_OF_TIME_INTEVAL) {
        NSString* str = STRING_TIME_DE_COUNT_FORMAT;
        self.timeLabel.text = [NSString stringWithFormat:str, self.slider.value];
    } else {
        NSString* str = STRING_READING_COUNT_FORMAT;
        self.timeLabel.text = [NSString stringWithFormat:str, (NSInteger)(self.slider.value)];
    }
}

- (IBAction)onChangedTimeInterval;
{
    if (self.slider.tag == TAG_OF_TIME_INTEVAL) {
        NSString* str = STRING_TIME_DE_COUNT_FORMAT;
        self.timeLabel.text = [NSString stringWithFormat:str, self.slider.value];
    } else {
        NSString* str = STRING_READING_COUNT_FORMAT;
        self.timeLabel.text = [NSString stringWithFormat:str, (NSInteger)(self.slider.value)];
    }
}

@end
