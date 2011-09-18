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
    NSIndexPath* pathShowText;
    NSIndexPath* pathReadingMode;
    NSString* resourcePath;
    BOOL      bFromSence;
}
@property (nonatomic) BOOL bFromSence;

- (SettingData*)getSettingData;
- (void)backToSelectedViewController;
@end
