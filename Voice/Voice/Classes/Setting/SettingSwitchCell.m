//
//  SettingSwitchCell.m
//  Voice
//
//  Created by JiaLi on 11-8-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingSwitchCell.h"


@implementation SettingSwitchCell
@synthesize label = _label;
@synthesize switchControl = _switchControl;
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
    delegate = nil;
    [self.label release];
    [self.switchControl release];
    [super dealloc];
}

- (IBAction)onClickSwitch:(id)sender;
{
    [delegate isOn:self.switchControl.on withTag:self.switchControl.tag];
}
@end
