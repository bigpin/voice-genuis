//
//  ScenesViewController.h
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScenesViewController : UITableViewController {
    NSMutableArray* _scenesArray;
}

@property (nonatomic, retain) NSMutableArray* scenesArray;
- (void)loadScenes;

@end
