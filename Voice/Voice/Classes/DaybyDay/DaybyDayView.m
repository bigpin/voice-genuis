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
@synthesize backgroundView;

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
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image/aqua.png";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    UIImage* balloon = [[UIImage imageWithContentsOfFile:resourcePath] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    self.backgroundView.image = balloon;
   UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat;
    
    [UIView animateWithDuration:20 delay:0.0 options:options animations:^
     {
         CGRect rc = self.textLabel.frame;
         //CGFloat right = rc.origin.x + rc.size.width;
         self.textLabel.frame = CGRectMake(rc.origin.x - rc.size.width, rc.origin.y, rc.size.width, rc.size.height);
     } completion:nil];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate tap];
}
@end
