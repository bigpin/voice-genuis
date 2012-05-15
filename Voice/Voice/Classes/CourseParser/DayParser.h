//
//  DayParser.h
//  Voice
//
//  Created by JiaLi on 12-5-15.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

/*
 <ot>Wonders are many, and nothing is more wonderful then man.</ot>
 <tt>天下奇迹无数，却无一比人更奇妙。</tt>
 <wd v="4">
 <w>
 <txt>wonder</txt>
 <pro>['wʌndə]</pro>
 <pos></pos>
 <def>n. 惊奇；奇迹；惊愕</def>
 <clon>
 <c>wonders</c>
 </clon>
 </w>
*/
@interface EveryDay :NSObject
{
    NSString* _orintext;
	NSString* _transtext;
    NSMutableArray* _wordsArray;
}
@property (nonatomic, retain) NSString* orintext;
@property (nonatomic, retain) NSString* transtext;
@property (nonatomic, retain) NSMutableArray* wordsArray;

@end

@interface DayParser : NSObject
{
    NSMutableArray* _everydaySentences;
    NSString* _resourcePath;
}

@property (nonatomic, retain) NSMutableArray* everydaySentences;

- (void)loadData:(NSString*)path;
@end
