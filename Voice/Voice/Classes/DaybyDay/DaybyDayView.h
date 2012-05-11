//
//  DaybyDayView.h
//  Voice
//
//  Created by JiaLi on 12-5-11.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DabyDayViewDelegate <NSObject>

- (void)tap;

@end
@interface DaybyDayView : UIView
{
    NSTimer*           updateTimer;

}
@property (nonatomic, assign) id<DabyDayViewDelegate>delegate;
@property (nonatomic, retain) IBOutlet UILabel* textLabel;
@property (nonatomic, retain) IBOutlet UIImageView* backgroundView;

- (void)setBackground;
- (void)startAnimations;
- (void)stopAnimations;
- (void)doAnimations;
@end
