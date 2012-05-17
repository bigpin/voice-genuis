//
//  SettingViewController.h
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingData.h"
#define LOOPCONTROL_TAG 102
#define DAYCONTROL_TAG 103

@interface SettingViewController : UITableViewController {
    SettingData* settingData;
    NSIndexPath* _pathShowText;
    NSIndexPath* _pathReadingMode;
    NSString* resourcePath;
    BOOL      bFromSence;
}
@property (nonatomic) BOOL bFromSence;
@property (nonatomic, retain) NSIndexPath* pathShowText;
@property (nonatomic, retain) NSIndexPath* pathReadingMode;

- (SettingData*)getSettingData;
- (void)backToSelectedViewController;
@end
