//
//  SettingViewController.h
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingData.h"

@interface SettingViewController : UITableViewController {
    SettingData* settingData;
}

- (SettingData*)getSettingData;
@end
