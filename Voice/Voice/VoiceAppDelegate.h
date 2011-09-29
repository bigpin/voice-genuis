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
- (id)initWithColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b withAlpha:(CGFloat)a;
@end

@interface VoiceAppDelegate : NSObject <UIApplicationDelegate, MobClickDelegate> {
    CustomUITabBarController* _tabBar;
    Database* databaseQuery;
    CGFloat naviRed;
    CGFloat naviGreen;
    CGFloat naviBlue;
    CGFloat naviAphla;
    BOOL bLessonViewAsRootView;
    BOOL bPagination;
    NSInteger nPageCountOfiPhone;
    NSInteger nPageCountOfiPad;
    NSInteger nLessonCellStyle;
}

@property (nonatomic, retain) IBOutlet CustomUITabBarController *tabBar;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property CGFloat naviRed;
@property CGFloat naviGreen;
@property CGFloat naviBlue;
@property CGFloat naviAphla;
@property BOOL bLessonViewAsRootView;
@property BOOL bPagination;
@property NSInteger nPageCountOfiPhone;
@property NSInteger nPageCountOfiPad;
@property NSInteger nLessonCellStyle;

- (void)loadCoverFlowUI;
- (void)loadLessonUI;

@end
