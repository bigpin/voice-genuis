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

@property (nonatomic, assign) id<DabyDayViewDelegate>delegate;
@property (nonatomic, retain) IBOutlet UILabel* textLabel;
@end
