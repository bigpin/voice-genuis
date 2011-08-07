//
//  CourseParser.m
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CourseParser.h"
#import "TBXML.h"
#import "Course.h"
#import "Lesson.h"
#import "Sentence.h"
#import "Teacher.h"

@implementation CourseParser

@synthesize resourcePath, tbxml, course;

- (id)init
{
    course = nil;
    [super init];
    return self;
}

- (void)loadCourses:(NSString*)filename
{
	// Load and parse the index.xml file
    NSString* fullFilename = [resourcePath stringByAppendingPathComponent:filename];
    //NSLog(@"%@", fullFilename);
    NSData* filedata = [NSData dataWithContentsOfFile:fullFilename];
	tbxml = [[TBXML tbxmlWithXMLData:filedata] retain];
	
	// Obtain root element
	TBXMLElement * root = tbxml.rootXMLElement;
	
	if (root) {
		TBXMLElement * body = [TBXML childElementNamed:@"body" parentElement:root];
		if (body) {
			if (!course) {
				course = [[Course alloc]init];
			}
			// metas
			TBXMLElement* metas = [TBXML childElementNamed:@"metas" parentElement:body];
			[self loadMetadata:metas];
			// lessons
			TBXMLElement* lessons = [TBXML childElementNamed:@"lessons" parentElement:body];
			[self loadLessons:lessons];
		}
		
	}
	[tbxml release];
	
}

- (void)loadMetadata:(TBXMLElement*)element
{
	if (element) {
		TBXMLElement* meta = [TBXML childElementNamed:@"meta" parentElement:element];
		while (meta) {
			// title
			TBXMLElement* title = [TBXML childElementNamed:@"title" parentElement:meta];
			if (title) {
				course.title = [TBXML textForElement:title];
			}
			// subject
			TBXMLElement* subject = [TBXML childElementNamed:@"subject" parentElement:meta];
			if (subject) {
				course.subject = [TBXML textForElement:subject];
			}
			// level
			TBXMLElement* level = [TBXML childElementNamed:@"level" parentElement:meta];
			if (level) {
				course.level = [[TBXML textForElement:level] integerValue];
			}
			// language
			TBXMLElement* language = [TBXML childElementNamed:@"language" parentElement:meta];
			if (language) {
				course.language = [TBXML textForElement:language];
			}
			
			meta = nil; // [TBXML nextSiblingNamed:@"meta" searchFromElement:meta];
		} 
	}
}

- (void)loadLessons:(TBXMLElement*)element
{
	if (element) {
		int lessonsCount = [[TBXML valueOfAttributeNamed:@"count" forElement:element] integerValue];
		course.lessons = [[NSMutableArray alloc]initWithCapacity:lessonsCount];
		
		TBXMLElement* lessonElement = [TBXML childElementNamed:@"lesson" parentElement:element];
		while (lessonElement) {
			Lesson* lesson = [[Lesson alloc]init];
			lesson.title = [TBXML valueOfAttributeNamed:@"title" forElement:lessonElement];
			lesson.lessonid = [TBXML valueOfAttributeNamed:@"id" forElement:lessonElement];
			lesson.order = [[TBXML valueOfAttributeNamed:@"order" forElement:lessonElement] integerValue];
			lesson.path = [TBXML valueOfAttributeNamed:@"path" forElement:lessonElement];
			lesson.file = [TBXML valueOfAttributeNamed:@"file" forElement:lessonElement];
			[course.lessons addObject:lesson];
			lessonElement = [TBXML nextSiblingNamed:@"lesson" searchFromElement:lessonElement];
		}
	}
}

- (void)loadLesson:(NSInteger)lessonindex
{
    Lesson* lesson = [course.lessons objectAtIndex:lessonindex];
    // is parsed?
    if (lesson.bParsed) {
        return;
    }
    
	if (lessonindex < [course.lessons count]) {
		// load file
        NSString* fullFilename = [resourcePath stringByAppendingPathComponent:lesson.path];
        fullFilename = [fullFilename stringByAppendingPathComponent:lesson.file];
       // NSLog(@"%@", fullFilename);
        NSData* filedata = [NSData dataWithContentsOfFile:fullFilename];
        tbxml = [[TBXML tbxmlWithXMLData:filedata] retain];
		
		TBXMLElement* root = tbxml.rootXMLElement;
		if (root) {
			TBXMLElement* body = [TBXML childElementNamed:@"body" parentElement:root];
			if (body) {
				// load sentences
				TBXMLElement* textStream = [TBXML childElementNamed:@"textstream" parentElement:body];
				if (textStream) {
					lesson.setences = [[NSMutableArray alloc] init];
					[self loadSentence:textStream to:lesson.setences];
				}
				// load teachers
				TBXMLElement* teachers = [TBXML childElementNamed:@"teachers" parentElement:body];
				if (teachers) {
					lesson.teachers = [[NSMutableArray alloc] init];
					[self loadTeacher:teachers to:lesson.teachers];
				}
				// get wav file
				TBXMLElement* media = [TBXML childElementNamed:@"media" parentElement:body];
				if (media) {
					TBXMLElement* file = [TBXML childElementNamed:@"file" parentElement:media];
					if (file) {
						lesson.wavfile = [resourcePath stringByAppendingPathComponent: [TBXML valueOfAttributeNamed:@"src" forElement:file]];
					}
				}
                lesson.bParsed = YES;
			}
		}
		[tbxml release];
	}
}

- (void)loadSentence:(TBXMLElement *)element to:(NSMutableArray *)sentences
{
	if (element) {
		// paragraph
		TBXMLElement* para = [TBXML childElementNamed:@"p" parentElement:element];
		while (para) {
			TBXMLElement* sentenceEle = [TBXML childElementNamed:@"s" parentElement:para];
			while (sentenceEle) {
				Sentence* sentence = [[Sentence alloc] init];
				sentence.starttime = [TBXML valueOfAttributeNamed:@"st" forElement:sentenceEle];
				sentence.endtime = [TBXML valueOfAttributeNamed:@"et" forElement:sentenceEle];
				sentence.techerid = [TBXML valueOfAttributeNamed:@"t" forElement:sentenceEle];
				TBXMLElement* orintext = [TBXML childElementNamed:@"ot" parentElement:sentenceEle];
				if (orintext) {
					sentence.orintext = [TBXML textForElement:orintext];
				}
				TBXMLElement* transtext = [TBXML childElementNamed:@"tt" parentElement:sentenceEle];
				if (transtext) {
					sentence.transtext = [TBXML textForElement:transtext];
				}
				TBXMLElement* ps = [TBXML childElementNamed:@"ps" parentElement:sentenceEle];
				if (ps) {
					sentence.ps = [TBXML textForElement:ps];
				}
				[sentences addObject:sentence];
				sentenceEle = [TBXML nextSiblingNamed:@"s" searchFromElement:sentenceEle];
			}
			para = [TBXML nextSiblingNamed:@"p" searchFromElement:para];
		}
	}
}

- (void) loadTeacher:(TBXMLElement *)element to:(NSMutableArray *)teachers
{
	if (element) {
		TBXMLElement* teacherEle = [TBXML childElementNamed:@"teacher" parentElement:element];
		while (teacherEle) {
			Teacher* teacher = [[Teacher alloc] init];
			teacher.teacherid = [TBXML valueOfAttributeNamed:@"id" forElement:teacherEle];
			TBXMLElement* surname = [TBXML childElementNamed:@"surname" parentElement:teacherEle];
			teacher.surname = [TBXML textForElement:surname];
			TBXMLElement* name = [TBXML childElementNamed:@"name" parentElement:teacherEle];
			teacher.name = [TBXML textForElement:name];
			TBXMLElement* description = [TBXML childElementNamed:@"description" parentElement:teacherEle];
			teacher.description = [TBXML textForElement:description];
			TBXMLElement* gender = [TBXML childElementNamed:@"gender" parentElement:teacherEle];
			teacher.gender = [TBXML textForElement:gender];
			TBXMLElement* avatar = [TBXML childElementNamed:@"avatar" parentElement:teacherEle];
			teacher.avatar = [TBXML textForElement:avatar];
			[teachers addObject:teacher];
			teacherEle = [TBXML nextSiblingNamed:@"teacher" searchFromElement:teacherEle];
		}
	}
}

- (void)dealloc {
	
	for (int i = 0; i < [course.lessons count]; i++) {
		[[course.lessons objectAtIndex:i] release];
	}
	[course.lessons release];
	
    [super dealloc];
}

@end
