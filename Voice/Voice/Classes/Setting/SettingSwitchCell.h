//
//  SettingSwitchCell.h
//  Voice
//
//  Created by JiaLi on 11-8-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingSwitchCellDelegate <NSObject>

- (void)isOn:(BOOL)bOn withTag:(NSInteger)tag;

@end

@interface SettingSwitchCell : UITableViewCell {
    UILabel *_label;
    UISwitch *_switchControl;
    id<SettingSwitchCellDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel* label;
@property (nonatomic, retain) IBOutlet UISwitch* switchControl;
@property (nonatomic, assign) id<SettingSwitchCellDelegate> delegate;

- (IBAction)onClickSwitch:(id)sender;

@end
