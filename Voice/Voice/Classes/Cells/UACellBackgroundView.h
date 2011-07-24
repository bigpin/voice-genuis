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
    UACellBackgroundViewPosition position;
}

@property(nonatomic) UACellBackgroundViewPosition position;

@end