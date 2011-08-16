//
//  SettingShowTranslationCell.h
//  Voice
//
//  Created by JiaLi on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SettingShowTranslationCellDelegate <NSObject>

- (void)isOn:(BOOL)isOn;

@end

@interface SettingShowTranslationCell : UITableViewCell {
    UILabel*  _label;
    UISwitch* _switchControll;
    id<SettingShowTranslationCellDelegate> delegate;
}
@property(nonatomic, retain) IBOutlet UILabel* label;
@property(nonatomic, retain) IBOutlet UISwitch* switchControll;
@property(nonatomic, assign) id<SettingShowTranslationCellDelegate> delegate;

- (IBAction)onSwith:(id)sender;
@end
