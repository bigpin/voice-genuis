//
//  LessonCell.m
//  Voice
//
//  Created by JiaLi on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LessonCell.h"
#import "BubbleCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation LessonCell
@synthesize lessonTitle = _lessonTitle;
@synthesize lessonLabel = _lessonLabel;
@synthesize useDarkBackground;
@synthesize ratingView = _ratingView;
@synthesize board = _board;
@synthesize nIndex;
@synthesize scoreLabel = _scoreLabel;
@synthesize fRating;

- (void)setUseDarkBackground:(BOOL)flag
{
    if (flag != useDarkBackground || !self.backgroundView)
    {
        useDarkBackground = flag;
        NSString* darkPath = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@/Cells/DarkBackground.png", [[NSBundle mainBundle] resourcePath], @"Image"]];
        
        NSString* lightPath = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@/Cells/LightBackground.png", [[NSBundle mainBundle] resourcePath], @"Image"]];
        
        NSString *backgroundImagePath = useDarkBackground ? darkPath : lightPath ;
        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
        fRating = MAX_RATING;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

- (void)cleanUp;
{
    self.backgroundView = nil;
    while ([[self.contentView subviews] count] > 0) {
        UIView *sub = [[self.contentView subviews] objectAtIndex:0];
        if (sub != nil) {
            [sub removeFromSuperview];
        }
    } 
    
    self.lessonLabel = nil;
    self.ratingView = nil;
    self.board = nil;
    self.scoreLabel = nil;
}

- (void)layoutSubviews {
    
    if (self.board == nil) {
        CGFloat iconWidth = MAGIN_OF_LESSON_TITLE - 20;
        
        UIImageView* boardIndex = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5 + (self.frame.size.height - iconWidth) / 2, iconWidth, iconWidth)];
        NSString* path = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@/Cells/board.png", [[NSBundle mainBundle] resourcePath], @"Image"]];
        boardIndex.image = [UIImage imageWithContentsOfFile:path];
        [self.contentView addSubview:boardIndex];
         self.board = boardIndex;
        [boardIndex release];
        [path release];
        UILabel* labelLessonIndex = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iconWidth, iconWidth - 5)];
        labelLessonIndex.backgroundColor = [UIColor clearColor];
        labelLessonIndex.text = [NSString stringWithFormat:@"%d", (nIndex+1)];
        labelLessonIndex.textColor = [UIColor whiteColor];
        labelLessonIndex.textAlignment = UITextAlignmentCenter;
        [self.board addSubview:labelLessonIndex];
        [labelLessonIndex release];
        CGFloat playIconWidth = 24;
        UIImageView* playIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - MAGIN_OF_RIGHT, (self.frame.size.height - playIconWidth) / 2, playIconWidth, playIconWidth)];
        path = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@/Cells/play.png", [[NSBundle mainBundle] resourcePath], @"Image"]];
        playIcon.image = [UIImage imageWithContentsOfFile:path];
        [self.contentView addSubview:playIcon];
        [playIcon release];
        [path release];
   }
    if (self.lessonLabel == nil) {
           CGSize size   = [BubbleCell calcTextHeight:self.lessonTitle withWidth:self.frame.size.width  - CELL_CONTENT_MARGIN*2 - MAGIN_OF_LESSON_TITLE - MAGIN_OF_RIGHT];
        UILabel* txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAGIN_OF_LESSON_TITLE, 10, size.width, size.height)];
        txtLabel.lineBreakMode   = UILineBreakModeWordWrap;
        txtLabel.numberOfLines   = 0;
        txtLabel.text            = self.lessonTitle;
        txtLabel.backgroundColor = [UIColor clearColor];
        txtLabel.font            = [UIFont systemFontOfSize:FONT_SIZE_BUBBLE];
        [txtLabel sizeToFit];
        [self.contentView addSubview:txtLabel];
        self.lessonLabel = txtLabel;
        [txtLabel release];
    }
    
    if (self.ratingView == nil) {
        RatingView* rating = [[RatingView alloc] initWithFrame:CGRectMake(self.lessonLabel.frame.origin.x, self.frame.size.height - 16 - 5, 70, 16)];
        rating.rating = fRating;
        [self.contentView addSubview:rating];
        self.ratingView = rating;
        [rating release];
        
        UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ratingView.frame.origin.x + self.ratingView.frame.size.width, self.ratingView.frame.origin.y, 60, 14)];
        scoreLabel.font = [UIFont systemFontOfSize:11];
        scoreLabel.textAlignment = UITextAlignmentCenter;
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textColor = [UIColor blackColor];
        NSString* s = STRING_SCORE_STRING;
        scoreLabel.text = [NSString stringWithFormat:s, self.ratingView.rating*100/MAX_RATING];
        [self.contentView addSubview:scoreLabel];
        self.scoreLabel = scoreLabel;
        [scoreLabel release];
        
    }
}

@end
