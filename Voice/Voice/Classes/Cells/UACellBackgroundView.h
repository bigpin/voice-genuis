//
//  UACellBackgroundView.h
//  Voice
//
//  Created by JiaLi on 11-7-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum  {
    UACellBackgroundViewPositionSingle = 0,
    UACellBackgroundViewPositionTop, 
    UACellBackgroundViewPositionBottom,
    UACellBackgroundViewPositionMiddle
} UACellBackgroundViewPosition;

@interface UACellBackgroundView : UIView {
    UACellBackgroundViewPosition position;;
    CGFloat fromRed;
    CGFloat fromGreen;
    CGFloat fromBlue;
    CGFloat toRed;
    CGFloat toGreen;
    CGFloat toBlue;
}

@property(nonatomic) UACellBackgroundViewPosition position;
@property(nonatomic) CGFloat fromRed;
@property(nonatomic) CGFloat fromGreen;
@property(nonatomic) CGFloat fromBlue;
@property(nonatomic) CGFloat toRed;
@property(nonatomic) CGFloat toGreen;
@property(nonatomic) CGFloat toBlue;


@end