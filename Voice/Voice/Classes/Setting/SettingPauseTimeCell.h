//
//  SettingPauseTimeCell.h
//  Voice
//
//  Created by JiaLi on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingPauseTimeDelegate <NSObject>

- (void)didSettingTimeInterval:(CGFloat)dTimeInterval;

@end

@interface SettingPauseTimeCell : UITableViewCell {
    UILabel* _label;
    UISlider* _slider;
    UILabel* _timeLabel;
    id<SettingPauseTimeDelegate> delegate;
}

@property(nonatomic, retain) IBOutlet UILabel* label;
@property(nonatomic, retain) IBOutlet UILabel* timeLabel;
@property(nonatomic, retain) IBOutlet UISlider* slider;
@property(nonatomic, assign) id<SettingPauseTimeDelegate> delegate;

- (IBAction)onSettingTimeInterval;
- (IBAction)onChangedTimeInterval;

@end
