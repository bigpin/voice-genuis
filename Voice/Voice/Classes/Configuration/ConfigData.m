//
//  ConfigData.m
//  Voice
//
//  Created by JiaLi on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ConfigData.h"

@implementation ConfigData
@synthesize naviRed;
@synthesize naviGreen;
@synthesize naviBlue;
@synthesize naviAphla;
@synthesize bLessonViewAsRootView;
@synthesize bPagination;
@synthesize nPageCountOfiPhone;
@synthesize nPageCountOfiPad;
@synthesize nLessonCellStyle;
@synthesize bShowTranslateText;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        bLessonViewAsRootView = NO;
        bPagination = NO;
        nPageCountOfiPhone = 8;
        nPageCountOfiPad = 15;
        nLessonCellStyle = 0;
        naviRed = 0.20392;
        naviGreen = 0.2235294;
        naviBlue = 0.082353;
        naviAphla = 1.0;
        bShowTranslateText = YES;
        [self loadConfiguration];
    }
    
    return self;
}

- (void)loadConfiguration 
{
    NSString* path = [[NSBundle mainBundle] resourcePath];
    path = [NSString stringWithFormat:@"%@/%@",path, @"configuration.plist"];
    NSDictionary* config = [[NSDictionary alloc] initWithContentsOfFile:path];
    if (config != nil) {
        NSNumber* isLoadCoverFlow = [config objectForKey:KEY_SETTING_USE_COVERFLOW];
        if (isLoadCoverFlow != nil) {
            bLessonViewAsRootView = ![isLoadCoverFlow boolValue];
        }
        
        NSNumber* isPagination = [config objectForKey:KEY_SETTING_LESSON_PAGINATION];
        if (isPagination != nil) {
            bPagination = [isPagination boolValue];
        }
        NSNumber* numOfiPhone = [config objectForKey:KEY_SETTING_LESSON_PAGE_OF_IPHONE];
        if (numOfiPhone != nil) {
            nPageCountOfiPhone = [numOfiPhone intValue];
        }
        
        NSNumber* numOfiPad = [config objectForKey:KEY_SETTING_LESSON_PAGE_OF_IPAD];
        if (numOfiPad != nil) {
            nPageCountOfiPad = [numOfiPad intValue];
        }
        NSNumber* numCellStyle = [config objectForKey:KEY_SETTING_LESSONCELLSTYLE];
        if (numCellStyle != 0) {
            nLessonCellStyle = [numCellStyle intValue];
        }
        NSArray* colorOfNavigation = [config objectForKey:KEY_SETTING_NAVIGATIONCOLOR];
        naviRed = [[colorOfNavigation objectAtIndex:0] floatValue];
        naviGreen = [[colorOfNavigation objectAtIndex:1] floatValue];
        naviBlue = [[colorOfNavigation objectAtIndex:2] floatValue];
        naviAphla = [[colorOfNavigation objectAtIndex:3] floatValue];
        
        NSNumber* numShowTransText = [config objectForKey:KEY_SETTING_SHOWTRANLATION];
        if (numShowTransText != nil) {
            bShowTranslateText = [numShowTransText boolValue];
        }
    } 
    [config release];
    config = nil;

}
@end
