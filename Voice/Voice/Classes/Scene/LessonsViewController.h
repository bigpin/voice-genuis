//
//  LessonsViewController.h
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseParser.h"
#import "Course.h"
#import "Lesson.h"

@class XMLAuthorsViewController;

@interface LessonsViewController : UITableViewController {
     NSString* _scenesName;
    CourseParser* _courseParser;
}

@property (nonatomic, retain) NSString* scenesName;

- (void) loadCourses;

@end
