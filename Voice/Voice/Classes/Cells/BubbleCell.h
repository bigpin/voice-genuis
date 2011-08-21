//
//  BubbleCell.h
//  MessageBubbles
//
//  Created by cwiles on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FONT_SIZE_BUBBLE 17.0

// bubble image colored
@interface BubbleImageView: UIView {
    NSString *imgName;
    NSString *_selectedImgName;
    UIImageView* balloonImageView;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    BOOL bColored;
}

@property (nonatomic, retain) NSString *imgName;
@property (nonatomic, retain) NSString *selectedImgName;
@property (nonatomic, assign) BOOL bColored;

- (void)setBurnColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b;
- (UIImage*)getSrcImage;
- (UIImage*)getBurnImage;
@end

/////////////////////////////////////////////////
@interface BubbleLabel : UILabel {
    BOOL bUnderline;
}
@property (nonatomic) BOOL bUnderline;
@end

/////////////////////////////////////////////////
@interface BubbleCell : UITableViewCell {
    NSString *msgText;
    NSString *_transText;
    NSString *imgName;
    NSString *_selectedImgName;
    NSString *imgIcon;
    CGFloat bgRed;
    CGFloat bgGreen;
    CGFloat bgBlue;
    CGFloat textRed;
    CGFloat textGreen;
    CGFloat textBlue;
    BOOL    bHighlight;
    BubbleLabel *textContent;
    UIImageView* microphone;
    BubbleImageView* bubbleView;
    UIView* selectedView;
    CGSize bubbleSize;
    int nShowTextStyle;
}

@property (nonatomic, assign) int nShowTextStyle;
@property (nonatomic, retain) NSString *msgText;
@property (nonatomic, retain) NSString *transText;
@property (nonatomic, retain) NSString *imgName;
@property (nonatomic, retain) NSString *selectedImgName;
@property (nonatomic, retain) NSString *imgIcon;

- (void)cleanUp;

- (void)setBurnColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b;
- (void)setTextColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b;
- (void)setIsHighlightText:(BOOL)bHighlight;

+ (CGSize)calcTextHeight:(NSString *)str withWidth:(CGFloat)width;

@end
