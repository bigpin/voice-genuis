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

- (id)init
{
    self = [super init];
    if (self) {
        
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
		NSMutableArray *arrOptions = [NSMutableArray arrayWithContentsOfFile:settingPList];
        
		int count = [arrOptions count];
		// if only one element, must be Apabi Reader v1.0.2.
		if (count == 0) {
            [self saveSettingData];
        } else {
            NSDictionary * tempsetting = [arrOptions objectAtIndex:0];
			NSNumber *timerValueTemp = [tempsetting objectForKey:kSettingTimeInterval];
			self.dTimeInterval = [timerValueTemp floatValue];
		} 
	}
	
}

- (void)saveSettingData;
{
    
}

@end
