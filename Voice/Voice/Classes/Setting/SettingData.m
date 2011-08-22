//
//  SettingData.m
//  Voice
//
//  Created by JiaLi on 11-8-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingData.h"

@implementation SettingData

@synthesize dTimeInterval;
@synthesize clrBubbleBg1 = _clrBubbleBg1;
@synthesize clrBubbleBg2 = _clrBubbleBg2;
@synthesize clrBubbleBg3 = _clrBubbleBg3;
@synthesize clrBubbleText1 = _clrBubbleText1;
@synthesize clrBubbleText2 = _clrBubbleText2;
@synthesize clrBubbleText3 = _clrBubbleText3;
@synthesize nReadingCount;
@synthesize eShowTextType;
@synthesize eReadingMode;
@synthesize bLoop;

- (id)init
{
    self = [super init];
    if (self) {
        [self initSettingData];
    }
    return self;
}

- (void)dealloc 
{
    [self.clrBubbleBg1 release];
    [self.clrBubbleBg2 release];
    [self.clrBubbleText1 release];
    [self.clrBubbleText2 release];
    [self.clrBubbleText3 release];
    [super dealloc];
}

- (void)initSettingData;
{
    self.dTimeInterval = 0.5;
    self.nReadingCount = 1.0;
    self.eShowTextType = SHOW_TEXT_TYPE_SRC;
    self.bLoop = NO;
}

- (void)loadSettingData;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *documentDIrectory = [paths objectAtIndex:0];
	NSString *path = [documentDIrectory stringByAppendingString:PATH_USERDATA];
	if (![fileManager fileExistsAtPath:path isDirectory:nil])  
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];	
	
	path = [path stringByAppendingPathComponent:DIR_SETTING];
	if (![fileManager fileExistsAtPath:path isDirectory:nil])  
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];	
	
	NSString *settingPList = [path stringByAppendingPathComponent:FILE_SETTING_PLIST];
	[self initSettingData];
	
	// load general settings.
	BOOL hasFile;
	hasFile = [fileManager fileExistsAtPath:settingPList];
    
	if (!hasFile) {
		[fileManager createFileAtPath:settingPList contents:nil attributes:nil];
		[self saveSettingData];
	} else {
        NSMutableDictionary * tempsetting = [NSMutableDictionary dictionaryWithContentsOfFile:settingPList];
        NSNumber *timerValueTemp = [tempsetting objectForKey:kSettingTimeInterval];
        if (timerValueTemp != nil) {
			self.dTimeInterval = [timerValueTemp floatValue];
        }

        NSNumber *readingCountTemp = [tempsetting objectForKey:kSettingReadingCount];
        if (readingCountTemp != nil) {
			self.nReadingCount = [readingCountTemp intValue];
        }

        NSNumber *showTranslationTemp = [tempsetting objectForKey:kSettingisShowTranslation];
        if (showTranslationTemp != nil) {
			self.eShowTextType = [showTranslationTemp intValue];
        }
        NSNumber *readingModeTemp = [tempsetting objectForKey:kSettingReadingMode];
        if (readingModeTemp != nil) {
			self.eReadingMode = [readingModeTemp intValue];
        }
        
        NSNumber* loopTemp = [tempsetting objectForKey:kSettingLoopReading];
        if (loopTemp != nil) {
            self.bLoop = [loopTemp boolValue];
        }
    
	}
}

- (void)saveSettingData;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *path = [documentDirectory stringByAppendingString:PATH_USERDATA];
	if (![fileManager fileExistsAtPath:path isDirectory:nil])  
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];	
	
	path = [path stringByAppendingPathComponent:DIR_SETTING];
	if (![fileManager fileExistsAtPath:path isDirectory:nil])  
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];	
	
	path = [path stringByAppendingPathComponent:FILE_SETTING_PLIST];
	
	BOOL hasFile = [fileManager fileExistsAtPath:path];
	if (!hasFile) {
		[fileManager createFileAtPath:path contents:nil attributes:nil];
	}
    
    NSMutableDictionary * settingdictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (settingdictionary == nil) {
        settingdictionary = [[NSMutableDictionary alloc] init];
    }
    [settingdictionary setObject:[NSNumber numberWithFloat:1.0] forKey:KSettingVersion];
    [settingdictionary setObject:[NSNumber numberWithFloat:self.dTimeInterval] forKey:kSettingTimeInterval];
    [settingdictionary setObject:[NSNumber numberWithInt:self.nReadingCount] forKey:kSettingReadingCount];
    [settingdictionary setObject:[NSNumber numberWithInt:self.eReadingMode] forKey:kSettingReadingMode];
    [settingdictionary setObject:[NSNumber numberWithInt:self.eShowTextType] forKey:kSettingisShowTranslation];
    [settingdictionary setObject:[NSNumber numberWithBool:self.bLoop] forKey:kSettingLoopReading];
	[settingdictionary writeToFile:path atomically:YES];
    [settingdictionary release];
}

@end
