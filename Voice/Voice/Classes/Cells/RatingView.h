//
//  RatingView.h
//  Voice
//
//  Created by JiaLi on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RatingView : UIView {
    float rating;
    UIImageView *backgroundImageView;
    UIImageView *foregroundImageView;
}

@property float rating;

@end