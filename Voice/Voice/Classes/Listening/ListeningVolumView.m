//
//  ListeningVolumView.m
//  Voice
//
//  Created by JiaLi on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ListeningVolumView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ListeningVolumView
@synthesize centerView = _centerView;
@synthesize volumndown = _volumndown;
@synthesize volumnup = _volumnup;
@synthesize volumImage = _volumImage;
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
