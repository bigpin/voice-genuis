//
//  SettingTrainingModeCell.h
//  Voice
//
//  Created by JiaLi on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingPauseTimeDelegate <NSObject>

- (void)didSettingTimeInterval:(CGFloat)dTimeInterval withTag:(NSInteger)tag;

@end

@interface SettingTrainingModeCell : UITableViewCell {
    UILabel* _label;
    UILabel* _sliderText;
    UISlider* _slider;
    UILabel* _timeLabel;
    id<SettingPauseTimeDelegate> delegate;
    UIImageView* _selectedView;
}

@property(nonatomic, retain) IBOutlet UILabel* label;
@property(nonatomic, retain) IBOutlet UILabel* timeLabel;
@property(nonatomic, retain) IBOutlet UILabel* sliderText;
@property(nonatomic, retain) IBOutlet UISlider* slider;
@property(nonatomic, assign) id<SettingPauseTimeDelegate> delegate;
@property(nonatomic, retain) IBOutlet UIImageView* selectedView;

- (IBAction)onSettingTimeInterval;
- (IBAction)onChangedTimeInterval;

@end
