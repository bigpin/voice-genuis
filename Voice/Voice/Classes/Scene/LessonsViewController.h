//
//  LessonsViewController.h
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LessonsViewController : UITableViewController {
    NSMutableArray* _lessonsArray;
}
@property (nonatomic, retain) NSMutableArray* lessonsArray;

@end
