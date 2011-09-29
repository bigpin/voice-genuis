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
    NSInteger nSelectedPage;
    NSInteger nPageCount;
    UISegmentedControl* _pageSegment;
    BOOL bLessonViewAsRootView;
    BOOL bPagination;
    NSInteger nPageCountOfiPhone;
    NSInteger nPageCountOfiPad;
    NSInteger nLessonCellStyle;
}

@property (nonatomic, retain) NSString* scenesName;
@property (nonatomic, retain) UISegmentedControl* pageSegment;

- (void) loadCourses;
- (void) loadToolbarItems;
- (void) onPrevious:(id)sender;
- (void) onNext:(id)sender;
- (void) onSelectedPage:(id)sender;
- (void) onSetting:(id)sender;

@end
