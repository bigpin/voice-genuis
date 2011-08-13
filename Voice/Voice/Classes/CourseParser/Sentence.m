//
//  Sentence.m
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sentence.h"


@implementation Sentence

@synthesize starttime, endtime, orintext, transtext, techerid, ps;

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

- (void) setOrintext:(NSString *)text
{
    NSRange range = [text rangeOfString:@"]:"];
    NSString* temp = nil;
    if (range.length > 0) {
        temp = [text substringFromIndex:(range.location + range.length)];
    }
    else {
        temp = text;
    }
     orintext = [[NSString alloc] initWithString:temp];
}

@end
