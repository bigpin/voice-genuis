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

- (id)initWithColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b withAlpha:(CGFloat)a;
{
    self = [super init];
    CGRect frame = CGRectMake(0.0, 0, self.view.bounds.size.width, 48);
    
    UIView *v = [[UIView alloc] initWithFrame:frame];
    
    [v setBackgroundColor:[[UIColor alloc] initWithRed:r
                                                 green:g
                                                  blue:b
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
@synthesize configData = _configData;

- (void)dayNotification
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];   
    
    if (notification!=nil) { 
        
        
        NSDate *now=[NSDate new]; 
        
        notification.fireDate=[now dateByAddingTimeInterval:10];
        
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        
        notification.alertBody=@"学习口语，每日一句！";//提示信息 
        
        notification.applicationIconBadgeNumber=1; //应用的红色数字 
        
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf" 
        
        notification.alertAction = @"学习";  //提示框按钮 
        
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        
        //        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        
        //        localNotif.userInfo = infoDict; 添加额外的信息，这个功能我没有用到过
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];      
    }
    [notification release];
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    app.applicationIconBadgeNumber=0;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*if (databaseQuery == nil) {
        databaseQuery = [Database database];
    }*/
    if (_configData == nil) {
        _configData = [[ConfigData alloc] init];
        self.configData = _configData;
    }
    // Override point for customization after application launch.
    if (!_configData.bLessonViewAsRootView) {
        [self loadCoverFlowUI];
    } else {
        [self loadLessonUI];
    }

    // UMeng setting
    [MobClick setDelegate:self];
    [MobClick appLaunched];
    
    [self.window makeKeyAndVisible];
    //[self dayNotification];
    
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
    if (_configData != nil) {
        [_configData release];
        _configData = nil;
        self.configData = nil;
    }
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
    
    nav.navigationBar.tintColor = [UIColor colorWithRed:self.configData.naviRed green:self.configData.naviGreen blue:self.configData.naviBlue alpha:self.configData.naviAphla];
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
    
    nav.navigationBar.tintColor = [UIColor colorWithRed:self.configData.naviRed green:self.configData.naviGreen blue:self.configData.naviBlue alpha:self.configData.naviAphla];
    nav.toolbarHidden = YES;
    nav.toolbar.tintColor = [UIColor colorWithRed:self.configData.naviRed green:self.configData.naviGreen blue:self.configData.naviBlue alpha:self.configData.naviAphla];
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
