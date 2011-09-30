//
//  ConfigData.h
//  Voice
//
//  Created by JiaLi on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigData : NSObject {
    CGFloat     naviRed;
    CGFloat     naviGreen;
    CGFloat     naviBlue;
    CGFloat     naviAphla;
    BOOL        bLessonViewAsRootView;
    BOOL        bPagination;
    NSInteger   nPageCountOfiPhone;
    NSInteger   nPageCountOfiPad;
    NSInteger   nLessonCellStyle;
    BOOL        bShowTranslateText;
}
@property CGFloat   naviRed;
@property CGFloat   naviGreen;
@property CGFloat   naviBlue;
@property CGFloat   naviAphla;
@property BOOL      bLessonViewAsRootView;
@property BOOL      bPagination;
@property NSInteger nPageCountOfiPhone;
@property NSInteger nPageCountOfiPad;
@property NSInteger nLessonCellStyle;
@property BOOL      bShowTranslateText;

- (void)loadConfiguration;
@end
