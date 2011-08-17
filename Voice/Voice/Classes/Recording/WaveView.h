//
//  WaveView.h
//  Voice
//
//  Created by JiaLi on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaveView : UIView {
    CGFloat power;
    CGFloat peak;
    NSMutableArray* _points;
}

- (void)setPower:(CGFloat)fPower peak:(CGFloat)fPeak;
- (CGPathRef)giveAPath;

@end
