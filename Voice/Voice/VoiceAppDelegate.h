//
//  VoiceAppDelegate.h
//  Voice
//
//  Created by JiaLi on 11-7-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceAppDelegate : NSObject <UIApplicationDelegate> {
    UITabBarController* _tabBar;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBar;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
