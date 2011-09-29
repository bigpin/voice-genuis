//
//  VoiceAppDelegate.m
//  Voice
//
//  Created by JiaLi on 11-7-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "VoiceAppDelegate.h"
#import "ScenesCoverViewController.h"
#import "FavorViewController.h"
#import "SettingViewController.h"
#import "LessonsViewController.h"

@implementation CustomUITabBarController

- (id)init
{
    self = [super init];
    CGRect frame = CGRectMake(0.0, 0, self.view.bounds.size.width, 48);
    
    UIView *v = [[UIView alloc] initWithFrame:frame];
    
    [v setBackgroundColor:[[UIColor alloc] initWithRed:NAVI_COLOR_R
                                                 green:NAVI_COLOR_G
                                                  blue:NAVI_COLOR_B
                                                 alpha:0.2]];
    
    v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.tabBar insertSubview:v atIndex:0];
    [v release];

    return self;
}
@end

@implementation VoiceAppDelegate

@synthesize window=_window;
@synthesize  tabBar = _tabBar;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*if (databaseQuery == nil) {
        databaseQuery = [Database database];
    }*/
    
    NSString* path = [[NSBundle mainBundle] resourcePath];
    path = [NSString stringWithFormat:@"%@/%@",path, @"configuration.plist"];
    NSDictionary* config = [[NSDictionary alloc] initWithContentsOfFile:path];
    if (config != nil) {
        NSNumber* isLoadCoverFlow = [config objectForKey:KEY_SETTING_USE_COVERFLOW];
        if (isLoadCoverFlow != nil) {
            if ([isLoadCoverFlow boolValue]) {
                [self loadCoverFlowUI];
            } else {
                [self loadLessonUI];
            }
        } else {
            [self loadCoverFlowUI];           
        }
    } else {
        [self loadCoverFlowUI];
        
    }
    [config release];
    config = nil;
    // Override point for customization after application launch.
    
    // UMeng setting
    [MobClick setDelegate:self];
    [MobClick appLaunched];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [MobClick appTerminated];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_WILLENTERFOREGROUND object:nil];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [MobClick setDelegate:self];
    [MobClick appLaunched];
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
    [MobClick appTerminated];
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

- (void)loadCoverFlowUI;
{
    CustomUITabBarController* tb = [[CustomUITabBarController alloc] init];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    
    ScenesCoverViewController* scenes = [[ScenesCoverViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:scenes];
    
    nav.navigationBar.tintColor = [UIColor colorWithRed:NAVI_COLOR_R green:NAVI_COLOR_G blue:NAVI_COLOR_B alpha:1.0];
    //scenes.title = @"Scenes root";
	scenes.tabBarItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/world.png", resourcePath]];
    
    NSString* scenetitle = STRING_SCENE_TITLE;
    scenes.tabBarItem.title = scenetitle;
    [viewControllers addObject:nav];
    
    [scenes release];
    [nav release];
    
    // settings
    SettingViewController* setting = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
 	setting.tabBarItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/preferences.png", resourcePath]];
    setting.bFromSence = YES;
    nav = [[UINavigationController alloc] initWithRootViewController:setting];
    nav.navigationBar.tintColor = [UIColor blackColor];
    [viewControllers addObject:nav];
    NSString* settingTitle = STRING_SETTING_TITLE;
    setting.title = settingTitle;
    setting.tabBarItem.title = settingTitle;
    [setting release];
    [nav release];
    
    [tb setViewControllers:viewControllers];
    
    self.tabBar = tb;
    [self.window addSubview:self.tabBar.view];
}

- (void)loadLessonUI;
{
    LessonsViewController* scenes = [[LessonsViewController alloc] initWithNibName:@"LessonsViewController" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:scenes];
    
    nav.navigationBar.tintColor = [UIColor colorWithRed:NAVI_COLOR_R green:NAVI_COLOR_G blue:NAVI_COLOR_B alpha:1.0];
    nav.toolbarHidden = YES;
    nav.toolbar.tintColor = [UIColor colorWithRed:NAVI_COLOR_R green:NAVI_COLOR_G blue:NAVI_COLOR_B alpha:1.0];
    NSString* scenetitle = STRING_SCENE_TITLE;
    scenes.tabBarItem.title = scenetitle;
    
    [scenes release];
    self.window.rootViewController = nav;
    [nav release];
    
}

#pragma Mark - UMeng

- (NSString *)appKey{
    return @"4e40ccaa431fe35a6e00014f";
}

@end
