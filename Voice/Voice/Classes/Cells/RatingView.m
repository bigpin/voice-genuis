//
//  RatingView.m
//  Voice
//
//  Created by JiaLi on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

- (void)_commonInit
{
    NSString* resourcePath = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Image"]];

    UIImage* imageB1 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Cells/StarsBackground.png", resourcePath]];
    backgroundImageView = [[UIImageView alloc] initWithImage:imageB1];
    backgroundImageView.contentMode = UIViewContentModeLeft;
    [self addSubview:backgroundImageView];
    
    UIImage* imageB2 = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Cells/StarsForeground.png", resourcePath]];
    foregroundImageView = [[UIImageView alloc] initWithImage:imageB2];
    foregroundImageView.contentMode = UIViewContentModeLeft;
    foregroundImageView.clipsToBounds = YES;
    [self addSubview:foregroundImageView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self _commonInit];
    }
    
    return self;
}

- (void)setRating:(float)newRating
{
    rating = newRating;
    foregroundImageView.frame = CGRectMake(0.0, 0.0, backgroundImageView.frame.size.width * (rating / MAX_RATING), foregroundImageView.bounds.size.height);
}

- (float)rating
{
    return rating;
}

- (void)dealloc
{
    [backgroundImageView release];
    [foregroundImageView release];
    
    [super dealloc];
}

@end
