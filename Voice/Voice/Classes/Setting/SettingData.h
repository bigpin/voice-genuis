//
//  SettingData.h
//  Voice
//
//  Created by JiaLi on 11-8-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kSettingTimeInterval @"TimeInterval"
#define kSettingisShowTranslation @"ShowTranslation"

@interface SettingData : NSObject {
    CGFloat dTimeInterval;
    BOOL isShowTranslation;
    UIColor* _clrBubbleBg1;
    UIColor* _clrBubbleBg2;
    UIColor* _clrBubbleBg3;
    UIColor* _clrBubbleText1;
    UIColor* _clrBubbleText2;
    UIColor* _clrBubbleText3;
}

@property (nonatomic, assign) CGFloat dTimeInterval;
@property (nonatomic, assign) BOOL isShowTranslation;
@property (nonatomic, retain) UIColor* clrBubbleBg1;
@property (nonatomic, retain) UIColor* clrBubbleBg2;
@property (nonatomic, retain) UIColor* clrBubbleBg3;
@property (nonatomic, retain) UIColor* clrBubbleText1;
@property (nonatomic, retain) UIColor* clrBubbleText2;
@property (nonatomic, retain) UIColor* clrBubbleText3;

- (void)initSettingData;
- (void)loadSettingData;
- (void)saveSettingData;

@end
