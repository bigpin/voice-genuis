//
//  WaveView.m
//  Voice
//
//  Created by JiaLi on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WaveView.h"


@implementation WaveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    /*CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor* c = [UIColor grayColor];
    CGContextSetFillColorWithColor(context, [c CGColor]);
    CGContextFillRect(context, rect);
    UIGraphicsEndImageContext();*/
}


- (void)dealloc
{
    [super dealloc];
}

@end
