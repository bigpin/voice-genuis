//
//  CourseParser.h
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class Course;
@class Lesson;

@interface CourseParser : NSObject {
    NSString* resourcePath; // resource path
    TBXML* tbxml;
	Course* course;         // data after parsed
    NSString* wavePath;
}

@property (nonatomic, retain) NSString* resourcePath;
@property (nonatomic, retain) TBXML* tbxml;
@property (nonatomic, retain) Course* course;

// Load course by filename  "index.xml"
- (void) loadCourses:(NSString*)filename;
- (void) loadMetadata:(TBXMLElement*)element;
- (void) loadLessons:(TBXMLElement*)element;

// Load in ....xml
- (void) loadLesson:(NSInteger)lessonindex;
- (void) loadSentence:(TBXMLElement*)element
                   to:(NSMutableArray*)sentences;
- (void) loadTeacher:(TBXMLElement*)element 
                  to:(NSMutableArray*)teachers;

@end
