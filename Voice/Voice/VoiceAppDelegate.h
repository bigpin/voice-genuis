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

@interface CustomUITabBarController: UITabBarController {
}
@end

@interface VoiceAppDelegate : NSObject <UIApplicationDelegate, MobClickDelegate> {
    CustomUITabBarController* _tabBar;
    Database* databaseQuery;
}

@property (nonatomic, retain) IBOutlet CustomUITabBarController *tabBar;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
