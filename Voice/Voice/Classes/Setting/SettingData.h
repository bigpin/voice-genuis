//
//  SettingData.h
//  Voice
//
//  Created by JiaLi on 11-8-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KSettingVersion      @"Version"
#define kSettingTimeInterval @"TimeInterval"
#define kSettingReadingCount @"ReadingCount"
#define kSettingReadingMode @"ReadingMode"
#define kSettingisShowTranslation @"ShowTextType"

typedef enum {
	SHOW_TEXT_TYPE_SRC = 0,
	SHOW_TEXT_TYPE_SRCANDTRANS,
	SHOW_TEXT_TYPE_NONE
} SHOW_TEXT_TYPE;

typedef enum {
	READING_MODE_WHOLE_TEXT = 0,
	READING_MODE_SENTENCE,
} READING_MODE;

@interface SettingData : NSObject {
    CGFloat dTimeInterval;
    NSInteger nReadingCount;
    READING_MODE eReadingMode;
    SHOW_TEXT_TYPE eShowTextType;
    UIColor* _clrBubbleBg1;
    UIColor* _clrBubbleBg2;
    UIColor* _clrBubbleBg3;
    UIColor* _clrBubbleText1;
    UIColor* _clrBubbleText2;
    UIColor* _clrBubbleText3;
}

@property (nonatomic, assign) CGFloat dTimeInterval;
@property (nonatomic, assign) NSInteger nReadingCount;
@property (nonatomic, assign) READING_MODE eReadingMode;
@property (nonatomic, assign) SHOW_TEXT_TYPE eShowTextType;
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
