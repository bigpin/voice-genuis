//
//  DayByDayObject.m
//  Voice
//
//  Created by JiaLi on 12-5-22.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import "DayByDayObject.h"
#import "DaybyDayView.h"
#import "DaybyDayViewController.h"
#import "DayParser.h"
#import "SettingData.h"

@implementation DayByDayObject
@synthesize navigationController;

- (void)loadDaybyDayView;
{
    SettingData* data = [[SettingData alloc] init];
    [data loadSettingData];
    if (!data.bShowDay) {
        [data release];
        return;
    }
    [data release];

    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *path = [documentDirectory stringByAppendingString:PATH_USERDATA];
	if (![fileManager fileExistsAtPath:path isDirectory:nil])  
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];	
	
	path = [path stringByAppendingPathComponent:DIR_SETTING];
	if (![fileManager fileExistsAtPath:path isDirectory:nil])  
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];	
	
	path = [path stringByAppendingPathComponent:@"daytime.plist"];
	
	BOOL hasFile = [fileManager fileExistsAtPath:path];
	if (!hasFile) {
		[fileManager createFileAtPath:path contents:nil attributes:nil];
	}     
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = [NSString stringWithFormat:@"%@/%@",resourcePath,@"DaybyDay/"];
    NSInteger nFileListIndex = 0;
    NSInteger nSentenceIndex = 0;
    NSString* dayPath = nil;
    NSString* dateString = nil;
    NSMutableDictionary * settingdictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (settingdictionary == nil) {
        settingdictionary = [[NSMutableDictionary alloc] init];
    } else {
        nFileListIndex = [[settingdictionary objectForKey:KFileindex] intValue];
        dateString = [settingdictionary objectForKey:KDate];
        if (dateString == nil) {
            nSentenceIndex = 0;
        } else {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *now = [[NSDate alloc] init];
            
            NSString *theDate = [dateFormat stringFromDate:now];
            if ([theDate isEqualToString:dateString]) {
                nSentenceIndex = [[settingdictionary objectForKey:KSentenceindex] intValue];
            } else {
                nSentenceIndex = [[settingdictionary objectForKey:KSentenceindex] intValue] + 1;
            }
            dateString = theDate;
            [now release];
            [dateFormat release];
        }
    }
    if (nSentenceIndex > 4) {
        nFileListIndex++;
        nSentenceIndex = 0;
    }
    NSFileManager* manager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:stringResource];
    NSInteger i = 0;
    NSString* file = [dirEnum nextObject];
    while (file) {
        if (nFileListIndex == i) {
            NSString* filePath = [NSString stringWithFormat:@"%@%@", stringResource, file];
            dayPath = filePath;
            break;
        }
        i++;
        file = [dirEnum nextObject];
    }
    if (i > nFileListIndex) {
         return;
    }
    if (dateString == nil) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *now = [[NSDate alloc] init];
        
        NSString *theDate = [dateFormat stringFromDate:now];
        dateString = theDate;
        [now release];
        [dateFormat release];
    }
    [settingdictionary setObject:dateString forKey:KDate];
    [settingdictionary setObject:[NSNumber numberWithInteger:nFileListIndex] forKey:KFileindex];
    [settingdictionary setObject:[NSNumber numberWithInteger:nSentenceIndex]forKey:KSentenceindex];
	[settingdictionary writeToFile:path atomically:YES];
    [settingdictionary release];
    
    if (dayPath == nil) {
        return;
    }
    DayParser* parser = [[DayParser alloc] init];
    [parser loadData:dayPath];
    NSLog(@"file: %d, sentence: %d", nFileListIndex, nSentenceIndex);
    if (nSentenceIndex < [parser.everydaySentences count]) 
    {
        NSMutableDictionary* dic = [parser.everydaySentences objectAtIndex:nSentenceIndex];
        _everydaySentence = [dic retain];
        [self performSelector:@selector(tap) withObject:nil afterDelay:0.3];
    }
     [parser release];
    parser = nil;
     // get the sentence
    /*NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DaybyDayView" owner:self options:NULL];
     if ([array count] > 0) {
     DaybyDayView* dayView = [array objectAtIndex:0];
     [self.view addSubview:dayView];
     dayView.tag = 201;
     dayView.frame = CGRectMake(dayView.frame.origin.x, dayView.frame.origin.y, self.view.frame.size.width, dayView.frame.size.height);
     if ([parser.everydaySentences count] > 0) {
     NSMutableDictionary* dic = [parser.everydaySentences objectAtIndex:0];
     _everydaySentence = [dic retain];
     NSString* oritext = [dic objectForKey:@"orintext"];
     if (oritext != nil) {
     dayView.textLabel.text = oritext;
     }
     }
     [dayView setBackground];
     dayView.delegate = (id)self;
     }*/
}

- (void)tap
{
    DaybyDayViewController* dayViewController = [[DaybyDayViewController alloc] initWithNibName:@"DaybyDayViewController" bundle:nil];
    dayViewController.delegate = (id)self;
    NSString * orintext = [_everydaySentence objectForKey:@"orintext"];
    NSString * transtext = [_everydaySentence objectForKey:@"transtext"];
    NSString* txtContent = nil;
    if (transtext != nil && orintext != nil) {
         txtContent = [NSString stringWithFormat:@"%@<br>%@", orintext, transtext];
    } 
    NSMutableArray* wordsArray = [_everydaySentence objectForKey:@"words"];
    NSString* proText = @"";
    if (wordsArray != nil && [wordsArray count] > 0) {
        for (NSInteger i = 0; i < [wordsArray count]; i++) {
            NSMutableDictionary* dic = [wordsArray objectAtIndex:i];
            NSString* txt = [dic objectForKey:@"txt"];
            if (txt != nil) {
                proText = [NSString stringWithFormat:@"%@<br>%@", proText, txt];
            }
            NSString* pro = [dic objectForKey:@"pro"];
            if (pro != nil) {
                proText = [NSString stringWithFormat:@"%@ %@", proText, pro];
            }
            NSString* def = [dic objectForKey:@"def"];
            if (def != nil) {
                proText = [NSString stringWithFormat:@"%@<br>%@", proText, def];
            }
        }
    }
    txtContent = [self setStringStyle:txtContent withPro:proText];
     dayViewController.txtContent = txtContent;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:dayViewController];
	if (IS_IPAD) {
		[nav setModalPresentationStyle:UIModalPresentationFormSheet];
	}
    [self.navigationController presentModalViewController:nav animated:YES];
    [dayViewController release];
    [nav release];
}

- (void)dealloc
{
    [_everydaySentence release];
    [super dealloc];
}

- (void)setClosedDay
{
    SettingData* data = [[SettingData alloc] init];
    [data loadSettingData];
    if (data.bShowDay) {
        data.bShowDay = NO;
        [data saveSettingData];
    }
    [data release];
}

- (NSString*)setStringStyle:(NSString*)oriText withPro:(NSString*)pro;
{
    NSInteger fontSizeOri = IS_IPAD ? 24 :18;
    NSInteger fontSizePro = IS_IPAD ? 18 :14;
    NSString* txtContent = [NSString stringWithFormat:@"<html><style type='text/css\'> body { background-color:transparent; font-family:Helvetica; color: #c8b981; font-size:%dpx;text-align:left} .class1 { background-color:transparent; font-family:Helvetica; color: #564b44; font-size:%dpx; } .class2 { background-color:transparent; font-family:Helvetica; color: #88766b ; font-size:%dpx; font-style: italic;}' </style><body> <p class='class1'> %@ </p><p class='class2'> %@ </p></body></html>", fontSizeOri, fontSizeOri,fontSizePro,oriText, pro];
    
    return txtContent;
}
@end
