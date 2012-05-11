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

- (void)setBackground;
{
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image/aqua.png";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    UIImage* balloon = [[UIImage imageWithContentsOfFile:resourcePath] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    self.backgroundView.image = balloon;
    /*[self doAnimations];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:(5) target:self selector:@selector(doAnimations) userInfo:nil repeats:YES];*/
    //[self startAnimations];
}

- (void)doAnimations;
{
    CGRect rc = self.textLabel.frame;
    if ((rc.origin.x) < 0) {
        rc.origin.x = 0;
    }
    
    self.textLabel.frame = rc;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:10];
    [UIView setAnimationCurve: UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.textLabel cache:NO];
    // other animation properties
    //CGFloat right = rc.origin.x + rc.size.width;
    self.textLabel.frame = CGRectMake(rc.origin.x - rc.size.width, rc.origin.y, rc.size.width, rc.size.height);

    [UIView commitAnimations];
}

- (void)stopAnimations;
{
    if (updateTimer != nil) {
        [updateTimer invalidate];
        updateTimer = nil;
    }
    CGRect rc = self.textLabel.frame;
    if ((rc.origin.x) < 0) {
        rc.origin.x = 0;
    }
    
    if (rc.origin.y != 12) {
        rc.origin.y = 12;
    }
    
    self.textLabel.frame = rc;
    [self setNeedsDisplay];

}

- (void)startAnimations;
{
 /*   if (updateTimer != nil) {
        [updateTimer invalidate];
        updateTimer = nil;
    }
    CGRect rc = self.textLabel.frame;
    if ((rc.origin.x) < 0) {
        rc.origin.x = 0;
    }
    
    if (rc.origin.y != 12) {
        rc.origin.y = 12;
    }
    
    self.textLabel.frame = rc;
    [self setNeedsDisplay];
   [self doAnimations];
     updateTimer = [NSTimer scheduledTimerWithTimeInterval:(5) target:self selector:@selector(doAnimations) userInfo:nil repeats:YES];*/
}

/*- (void)drawRect:(CGRect)rect
{
    // Drawing code

   UIViewAnimationOptions options = UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat;
    
    [UIView animateWithDuration:20 delay:0.0 options:options animations:^
     {
         CGRect rc = self.textLabel.frame;
         //CGFloat right = rc.origin.x + rc.size.width;
         self.textLabel.frame = CGRectMake(rc.origin.x - rc.size.width, rc.origin.y, rc.size.width, rc.size.height);
     } completion:nil];

}*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate tap];
}
@end
