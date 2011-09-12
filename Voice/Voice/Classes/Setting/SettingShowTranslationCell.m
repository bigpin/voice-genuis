//
//  SettingShowTranslationCell.m
//  Voice
//
//  Created by JiaLi on 11-9-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingShowTranslationCell.h"


@implementation SettingShowTranslationCell
@synthesize textLabelTrans = _textLabelTrans;
@synthesize selectedView = _selectedView;

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
    [self.textLabelTrans release];
    [self.selectedView release];
    [super dealloc];
}

@end
