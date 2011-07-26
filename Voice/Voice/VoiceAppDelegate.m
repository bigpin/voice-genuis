//
//  VoiceAppDelegate.m
//  Voice
//
//  Created by JiaLi on 11-7-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "VoiceAppDelegate.h"
#import "ScenesViewController.h"
#import "ScenesCoverViewController.h"
#import "FavorViewController.h"
#import "SettingViewController.h"

@implementation VoiceAppDelegate

@synthesize window=_window;
@synthesize  tabBar = _tabBar;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITabBarController* tb = [[UITabBarController alloc] init];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    
    // lessons
    /*ScenesViewController* lessons = [[ScenesViewController alloc] initWithNibName:@"ScenesViewController" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:lessons];
    nav.navigationBar.tintColor = [UIColor blackColor];
    lessons.title = @"Scenes root";
	lessons.tabBarItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/world.png", resourcePath]];
    
    nav.title = @"Scenes";
    [viewControllers addObject:nav];
    
    [lessons release];
    [nav release];*/
    ScenesCoverViewController* scenes = [[ScenesCoverViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:scenes];
    nav.navigationBar.tintColor = [UIColor blackColor];
    scenes.title = @"Scenes root";
	scenes.tabBarItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/world.png", resourcePath]];
    
    nav.title = @"Scenes";
    [viewControllers addObject:nav];
    
    [scenes release];
    [nav release];
    
    
    // favor
    FavorViewController* favor = [[FavorViewController alloc] initWithNibName:@"FavorViewController" bundle:nil];
    
	favor.tabBarItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/clock.png", resourcePath]];
    nav = [[UINavigationController alloc] initWithRootViewController:favor];
    nav.navigationBar.tintColor = [UIColor blackColor];
    [viewControllers addObject:nav];
    favor.title = @"Favor root";
    nav.title = @"Favor";
    [favor release];
    [nav release];
    
    // settings
    SettingViewController* setting = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
 	setting.tabBarItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/preferences.png", resourcePath]];
    nav = [[UINavigationController alloc] initWithRootViewController:setting];
    nav.navigationBar.tintColor = [UIColor blackColor];
    [viewControllers addObject:nav];
    setting.title = @"Setting root";
    nav.title = @"Setting";
    [setting release];
    [nav release];
    
    [tb setViewControllers:viewControllers];
    
    self.tabBar = tb;
    [self.window addSubview:self.tabBar.view];
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
