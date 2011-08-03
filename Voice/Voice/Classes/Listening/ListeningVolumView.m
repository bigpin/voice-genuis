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


@implementation ListeningVolumProgressView
- (void)drawRect:(CGRect)rect {
    
    CGSize backgroundStretchPoints = {4, 9}, fillStretchPoints = {3, 8};
    
    // Initialize the stretchable images.
    UIImage *background = [[UIImage imageNamed:@"progress-bar-bg.png"] stretchableImageWithLeftCapWidth:backgroundStretchPoints.width topCapHeight:backgroundStretchPoints.height];     
    UIImage *fill = [[UIImage imageNamed:@"progress-bar-fill.png"] stretchableImageWithLeftCapWidth:fillStretchPoints.width topCapHeight:fillStretchPoints.height];    // Draw the background in the current rect
    [background drawInRect:rect];
    
    // Compute the max width in pixels for the fill.  Max width being how
    // wide the fill should be at 100% progress.
    NSInteger maxWidth = rect.size.width - (2 * kCustomProgressViewFillOffsetX);
    
    // Compute the width for the current progress value, 0.0 - 1.0 corresponding 
    // to 0% and 100% respectively.
    NSInteger curWidth = floor([self progress] * maxWidth);
    
    // Create the rectangle for our fill image accounting for the position offsets,
    // 1 in the X direction and 1, 3 on the top and bottom for the Y.
    CGRect fillRect = CGRectMake(rect.origin.x + kCustomProgressViewFillOffsetX,
                                 rect.origin.y + kCustomProgressViewFillOffsetTopY,
                                 curWidth,
                                 rect.size.height - kCustomProgressViewFillOffsetBottomY);
    
    // Draw the fill
    [fill drawInRect:fillRect];
}

@end

@implementation ListeningVolumView
@synthesize centerView = _centerView;
@synthesize volumndown = _volumndown;
@synthesize volumnup = _volumnup;
@synthesize volumImage = _volumImage;
@synthesize volumProgress = _volumProgress;

@synthesize viewDelegate;

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

    self.volumImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/volumn.png", resourcePath]];
    [self.volumnup setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/icon_volume_up.png", resourcePath]] forState:UIControlStateNormal];
    [self.volumndown setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/icon_volume_down.png", resourcePath]] forState:UIControlStateNormal];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [viewDelegate removeView:self];
}

@end
