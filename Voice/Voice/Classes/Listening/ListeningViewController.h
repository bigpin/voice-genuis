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
}
@property (nonatomic, retain) NSMutableArray* sentencesArray;
@property (nonatomic, retain) IBOutlet UITableView* sentencesTableView;

@end
