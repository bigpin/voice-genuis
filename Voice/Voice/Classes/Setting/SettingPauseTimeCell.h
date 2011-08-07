//
//  SettingPauseTimeCell.h
//  Voice
//
//  Created by JiaLi on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingPauseTimeCell : UITableViewCell {
    UILabel* _label;
    UISlider* _slider;
}

@property(nonatomic, retain) IBOutlet UILabel* label;
@property(nonatomic, retain) IBOutlet UISlider* slider;
@end
