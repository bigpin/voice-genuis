//
//  ListeningVolumView.m
//  Voice
//
//  Created by JiaLi on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ListeningVolumView.h"
#import <QuartzCore/QuartzCore.h>
#define kCustomProgressViewFillOffsetX 1
#define kCustomProgressViewFillOffsetTopY 1
#define kCustomProgressViewFillOffsetBottomY 3
#define DEFALUT_VOLUM_LEVEL 5

@implementation ListeningVolumProgressView
@synthesize nMaxLevel, nCurrentLevel, bDisabledVolumn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        nMaxLevel = DEFALUT_VOLUM_LEVEL;
        nCurrentLevel = 2;
    }
    return self;
}

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
     // Drawing code
     if (nMaxLevel == 0) {
         nMaxLevel = DEFALUT_VOLUM_LEVEL;
     }
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGFloat fSpace = 12;
     CGFloat fWidth = (self.frame.size.width - ((nMaxLevel - 1) * fSpace))/ nMaxLevel;
     NSInteger nPosCountY = 5;
     CGFloat fStartHeight = self.frame.size.height / nPosCountY;
     CGFloat fHeight = (self.frame.size.height * (1 - 1/nPosCountY)) / ((nMaxLevel+1));
     if (context != nil) {
          for (NSInteger i = 0; i < nMaxLevel; i++) {
              if (bDisabledVolumn) {
                  UIColor* c = [UIColor grayColor];
                  CGContextSetFillColorWithColor(context, [c CGColor]);
              } else {
                   if (i <= (nCurrentLevel - 1)) {
                      UIColor* c = [UIColor whiteColor];
                      CGContextSetFillColorWithColor(context, [c CGColor]);
                  } else {
                      UIColor* c = [UIColor grayColor];
                      CGContextSetFillColorWithColor(context, [c CGColor]);
                  }
              }

             CGRect rc = CGRectMake(i * (fWidth + fSpace), self.frame.size.height - (fStartHeight + i * fHeight), fWidth, fStartHeight + i * fHeight);
             CGContextFillRect(context, rc);
         }
     }
     UIGraphicsEndImageContext();
 }


- (void)dealloc
{
    [super dealloc];
}

@end


//////////////////////////////////////////////////////
@implementation ListeningVolumView
@synthesize centerView = _centerView;
@synthesize volumndown = _volumndown;
@synthesize volumnup = _volumnup;
@synthesize volumImage = _volumImage;
@synthesize volumProgress = _volumProgress;

@synthesize viewDelegate;
@synthesize bDisabeldVolumn;

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

- (void)dealloc
{
    [super dealloc];
}

- (void)loadResource;
{
    self.centerView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    self.centerView.layer.cornerRadius = 10;
    
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];

    [self.volumImage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/volumn.png", resourcePath]] forState:UIControlStateNormal];
    [self.volumnup setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/icon_volume_up.png", resourcePath]] forState:UIControlStateNormal];
    [self.volumndown setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/icon_volume_down.png", resourcePath]] forState:UIControlStateNormal];
    self.volumProgress.nCurrentLevel = 2;
    self.volumProgress.nMaxLevel = DEFALUT_VOLUM_LEVEL;
    self.bDisabeldVolumn = NO;
    self.volumProgress.bDisabledVolumn = self.bDisabeldVolumn;
    [self.volumProgress setNeedsDisplay];
}

- (void)setVolumnDisplay:(CGFloat)fv;
{
    self.volumProgress.nCurrentLevel = self.volumProgress.nMaxLevel*fv;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint pt = [touch locationInView:self];
    if ((pt.x > self.centerView.frame.origin.x && pt.y > self.centerView.frame.origin.y && pt.x < (self.centerView.frame.size.width + self.centerView.frame.origin.x) && pt.y < (self.centerView.frame.size.height + self.centerView.frame.origin.y))) {
    } else {
        [viewDelegate removeView:self];
    }
}

- (IBAction)onIncreaseVolumn;
{
    if (self.bDisabeldVolumn) {
        return;
    }
    self.volumProgress.nCurrentLevel++;
    if (self.volumProgress.nCurrentLevel > self.volumProgress.nMaxLevel) {
        self.volumProgress.nCurrentLevel = self.volumProgress.nMaxLevel;
    }
    [self.volumProgress setNeedsDisplay];

}

- (IBAction)onDisableVolumn;
{
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    if (!bDisabeldVolumn) {
        [self.volumImage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/volumn_disable.png", resourcePath]] forState:UIControlStateNormal];
    } else {
        [self.volumImage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/volumn.png", resourcePath]] forState:UIControlStateNormal];
    }
    self.bDisabeldVolumn = !self.bDisabeldVolumn;
    self.volumProgress.bDisabledVolumn = self.bDisabeldVolumn;
    [self.volumProgress setNeedsDisplay];
    
}

- (IBAction)onDecreseVolumn;
{
    if (self.bDisabeldVolumn) {
        return;
    }
    self.volumProgress.nCurrentLevel--;
    if (self.volumProgress.nCurrentLevel < 1) {
        self.volumProgress.nCurrentLevel = 1;
    }
    [self.volumProgress setNeedsDisplay];
}

@end
