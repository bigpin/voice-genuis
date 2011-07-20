//
//  LessonsViewController.h
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TBXML.h"
#import "Course.h"
#import "Lesson.h"
#import "Sentence.h"
#import "Teacher.h"

@class XMLAuthorsViewController;

@interface LessonsViewController : UITableViewController {
 	NSMutableArray * authors;
	
	TBXML * tbxml;
	Course* course;
    NSString* _scenesName;
}

@property (nonatomic, retain) NSString* scenesName;

- (void) loadURL;
- (void) loadXMLString;
- (void) loadXMLData;
- (void) loadBooks;
- (void) loadUnknownXML;
- (void) traverseElement:(TBXMLElement *)element;

- (void) loadCourses;
- (void) loadMetadata:(TBXMLElement*)element;
- (void) loadLessons:(TBXMLElement*)element;

- (void) loadLesson:(Lesson*)lesson;
- (void) loadSentence:(TBXMLElement*)element 
		  toSentences:(NSMutableArray*)sentences;
- (void) loadTeacher:(TBXMLElement*)element 
		  toTeachers:(NSMutableArray*)teachers;

@end
