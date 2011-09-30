//
//  VoiceAppDelegate.h
//  Voice
//
//  Created by JiaLi on 11-7-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "MobClick.h"
#import "ConfigData.h"

@interface CustomUITabBarController: UITabBarController {
}
- (id)initWithColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b withAlpha:(CGFloat)a;
@end

@interface VoiceAppDelegate : NSObject <UIApplicationDelegate, MobClickDelegate> {
    CustomUITabBarController* _tabBar;
    Database* databaseQuery;
    ConfigData* _configData;
}

@property (nonatomic, retain) IBOutlet CustomUITabBarController *tabBar;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, assign) ConfigData* configData;
- (void)loadCoverFlowUI;
- (void)loadLessonUI;

@end
