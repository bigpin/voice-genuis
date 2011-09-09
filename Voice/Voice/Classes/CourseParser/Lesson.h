//
//  Lesson.h
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Lesson : NSObject {

	NSString* lessonid;
	NSString* title;
	NSInteger order;
	NSString* path;
	NSString* file;
	NSMutableArray* teachers;
	NSString* wavfile;
    NSString* isbfile;
	NSMutableArray* setences;
    
    BOOL bParsed;
}

@property (nonatomic, retain) NSString* lessonid;
@property (nonatomic, retain) NSString* title;
@property (nonatomic) NSInteger order;
@property (nonatomic, retain) NSString* path;
@property (nonatomic, retain) NSString* file;
@property (nonatomic, retain) NSMutableArray* teachers;
@property (nonatomic, retain) NSString* wavfile;
@property (nonatomic, retain) NSString* isbfile;
@property (nonatomic, retain) NSMutableArray* setences;

@property (nonatomic) BOOL bParsed;

@end
