//
//  DaybyDayView.m
//  Voice
//
//  Created by JiaLi on 12-5-11.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import "DaybyDayView.h"

@implementation DaybyDayView
@synthesize textLabel;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate tap];
}
@end
