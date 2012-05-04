//
//  NSPhoneticSymbol.m
//  Voice
//
//  Created by@i ding on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSPhoneticSymbol.h"

@implementation NSPhoneticSymbol

- (id)init
{
    NSArray *keys = [NSArray arrayWithObjects:
                     @"ii", 
                     @"aa", 
                     @"oo", 
                     @"uu", 
                     @"ih", 
                     @"eh", 
                     @"ae", 
                     @"ex", 
                     @"ah", 
                     @"oh", 
                     @"uh", 
                     
                     @"ah ih", 
                     @"ah uh", 
                     @"eh ex", 
                     
                     @"th", 
                     @"sh", 
                     @"tg", 
                     @"tr", 
                     @"zh", 
                     @"dr", 
                     @"ng", 
                     @"dh", 
                     
                     @"pp", 
                     @"tt", 
                     @"kk", 
                     @"ff", 
                     @"ss", 
                     @"hh", 
                     @"bb", 
                     @"dd", 
                     @"gg", 
                     @"vv", 
                     @"dd", 
                     @"zz", 
                     @"rr", 
                     @"ww", 
                     @"mm", 
                     @"nn", 
                     @"ll", nil];
    NSArray *objs = [NSArray arrayWithObjects:
                     @"i:",
                     @"a:",
                     @"ɔ:",
                     @"u:",
                     @"i",
                     @"e",
                     @"æ",
                     @"ə",
                     @"ʌ",
                     @"ɔ",
                     @"u",
                     
                     @"ai",
                     @"au",
                     @"εə",
                     
                     @"θ",
                     @"ʃ",
                     @"tʃ",
                     @"tr",
                     @"dʒ",
                     @"dr",
                     @"ŋ",
                     @"ð",
                     
                     @"p",
                     @"t",
                     @"k",
                     @"f",
                     @"s",
                     @"h",
                     @"b",
                     @"d",
                     @"g",
                     @"v",
                     @"d",
                     @"z",
                     @"r",
                     @"w", 
                     @"m", 
                     @"n", 
                     @"l", nil];
    psDict = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];

    [super init];
    return self;
}

- (NSString*) getPhoneticSymbol:(NSString*)str
{
    NSMutableString* retStr = [[NSMutableString alloc] init];
    if (psDict != nil && str != nil) {
        NSString* strNext = nil;
        NSRange range;
        range.length = 2;
        for (int i = 0; i < [str length]; i = i + 2) {
            range.location = i;
            range.length = 2; 
            strNext = [str substringWithRange:range];
            if (([strNext isEqualToString:@"ah"] || [strNext isEqualToString:@"eh"]) && i + 4 < [str length]) {
                range.length = 5;
                NSString* strNextTemp = [str substringWithRange:range];
                NSString* obj = [psDict objectForKey:strNextTemp];
                if (obj != nil) {
                    [retStr appendString:obj];
                    // 多跳过一个音标
                    i = i + 3;
                }
            }
            else {
                NSString* obj = [psDict objectForKey:strNext];
                if (obj != nil) {
                    [retStr appendString:obj];
                }
            }
            // 跳过空格
            i++;
        }
    }
    return retStr;
}

- (void) dealloc
{
    [psDict release];
    [super dealloc];
}

@end
