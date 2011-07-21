//
//  ListeningViewController.h
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListeningViewController : UIViewController {
    NSMutableArray* _sentencesArray;
    UITableView* _sentencesTableView;
    UIBarButtonItem* previousItem;
    UIBarButtonItem* nextItem;
    UIBarButtonItem* playItem;
    UIBarButtonItem* loopSingle;
    UIBarButtonItem* loopLesson;
    BOOL bStart;
}
@property (nonatomic, retain) NSMutableArray* sentencesArray;
@property (nonatomic, retain)IBOutlet UITableView* sentencesTableView;
@property (nonatomic, retain)IBOutlet UIBarButtonItem* previousItem;
@property (nonatomic, retain)IBOutlet UIBarButtonItem* nextItem;
@property (nonatomic, retain)IBOutlet UIBarButtonItem* playItem;
@property (nonatomic, retain)IBOutlet UIBarButtonItem* loopSingle;
@property (nonatomic, retain)IBOutlet UIBarButtonItem* loopLesson;

- (IBAction)onPrevious:(id)sender;
- (IBAction)onStart:(id)sender;
- (IBAction)onNext:(id)sender;
- (IBAction)onLoopLesson:(id)sender;
- (IBAction)onLoopSentence:(id)sender;

@end
