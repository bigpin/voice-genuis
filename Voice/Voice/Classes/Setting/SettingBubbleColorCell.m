//
//  SettingBubbleColorCell.m
//  Voice
//
//  Created by JiaLi on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingBubbleColorCell.h"


@implementation SettingBubbleColorCell
@synthesize label = _label;
@synthesize bubbleView = _bubbleView;
@synthesize bubbleText = _bubbleText;

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
    [super dealloc];
}

@end
