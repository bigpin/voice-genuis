//
//  LessonCell.h
//  Voice
//
//  Created by JiaLi on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface LessonCell : UITableViewCell {
    NSString* _lessonTitle;
    UILabel* _label;
    RatingView* _ratingView;
    UILabel* _scoreLabel;
    UIImageView* _board;
    BOOL useDarkBackground;
    NSInteger nIndex;
    CGFloat fRating;
    NSInteger nStyle;
    NSInteger nCellPosition;
}
@property (nonatomic) BOOL useDarkBackground;
@property (nonatomic) NSInteger nIndex;
@property (nonatomic, retain) NSString* lessonTitle;
@property (nonatomic, retain) IBOutlet UILabel* lessonLabel;
@property (nonatomic, retain) IBOutlet RatingView* ratingView;
@property (nonatomic, retain) IBOutlet UIImageView* board;
@property (nonatomic, retain) IBOutlet UILabel* scoreLabel;
@property (nonatomic) CGFloat fRating;
@property (nonatomic) NSInteger nStyle;
@property (nonatomic) NSInteger nCellPosition;

- (void)cleanUp;

@end
