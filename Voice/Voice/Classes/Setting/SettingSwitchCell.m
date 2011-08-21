//
//  SettingSwitchCell.m
//  Voice
//
//  Created by JiaLi on 11-8-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingSwitchCell.h"


@implementation SettingSwitchCell

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
