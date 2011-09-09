//
//  Lesson.m
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Lesson.h"


@implementation Lesson

@synthesize lessonid, title, order, path, file, teachers, wavfile, setences, bParsed, isbfile;

- (id) init
{
    self = [super init];
    lessonid = nil;
    title = nil;
    order = 999;
    path = nil;
    bParsed = NO;
    file = nil;
    teachers = nil;
    wavfile = nil;
    setences = nil;
    isbfile = nil;
    return self;
}

- (void)dealloc 
{
    [self.lessonid release];
    [self.title release];
    [self.path release];
    [self.file release];
    [self.teachers release];
    [self.wavfile release];
    [self.setences release];
    [self.isbfile release];
    [super dealloc];
}
@end
