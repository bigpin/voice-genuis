//
//  Lesson.m
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Lesson.h"


@implementation Lesson

@synthesize lessonid, title, order, path, file, teachers, wavfile, setences, bParsed;

- (id) init
{
    lessonid = nil;
    title = nil;
    order = 999;
    path = nil;
    bParsed = NO;
    file = nil;
    teachers = nil;
    wavfile = nil;
    setences = nil;
    
    return self;
}

@end
