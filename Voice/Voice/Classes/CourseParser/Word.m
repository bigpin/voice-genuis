//
//  Word.m
//  Voice
//
//  Created by li ding on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Word.h"

@implementation Word

@synthesize text, starttime, endtime, fayin, jiezou, yinliang, yingao;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        text = nil;
        starttime = nil;
        endtime = nil;
        fayin = jiezou = yinliang = yingao = 0.0;
    }
    
    return self;
}

- (NSTimeInterval) transTotime:(NSString*)str
{
    NSRange range = [str rangeOfString:@":"];
    NSTimeInterval minute = 0.0;
    if (range.length > 0) {
        minute = [[str substringToIndex:range.location] doubleValue];
    }
    return minute * 60 + [[str substringFromIndex:(range.location + range.length)] doubleValue];
}

- (NSTimeInterval) startTime
{
    return [self transTotime:starttime];
}

- (NSTimeInterval) endTime
{
    return [self transTotime:endtime];
}
@end
