//
//  SettingShowTranslationCell.m
//  Voice
//
//  Created by JiaLi on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingShowTranslationCell.h"


@implementation SettingShowTranslationCell
@synthesize label = _label;
@synthesize switchControll = _switchControll;
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
    [self.switchControll release];
    [super dealloc];
}

- (IBAction)onSwith:(id)sender;
{
    [delegate isOn:self.switchControll.on];
}
@end
