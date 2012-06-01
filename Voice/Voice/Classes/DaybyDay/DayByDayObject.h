//
//  DayByDayObject.h
//  Voice
//
//  Created by JiaLi on 12-5-22.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KSentenceindex @"sentenceindex"
#define KFileindex @"fileindex"
#define KDate @"date"

@interface DayByDayObject : NSObject
{
    NSMutableDictionary* _everydaySentence;
}
@property (nonatomic, assign) UINavigationController* navigationController;
- (void)loadDaybyDayView;
- (void)tap;
- (NSString*)setStringStyle:(NSString*)oriText withPro:(NSString*)pro;
@end
