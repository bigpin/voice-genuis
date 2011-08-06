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
    UIImageView* balloonImageView;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
}

@property (nonatomic, retain) NSString *imgName;

- (void)setBurnColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b;
- (UIImage*)getSrcImage;
- (UIImage*)getBurnImage;
@end

@interface BubbleCell : UITableViewCell {
    NSString *msgText;
    NSString *imgName;
    NSString *imgIcon;
    CGFloat bgRed;
    CGFloat bgGreen;
    CGFloat bgBlue;
    CGFloat textRed;
    CGFloat textGreen;
    CGFloat textBlue;
    BOOL    bHighlight;
    UILabel *textContent;
}

@property (nonatomic, retain) NSString *msgText;
@property (nonatomic, retain) NSString *imgName;
@property (nonatomic, retain) NSString *imgIcon;
- (void)setBurnColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b;
- (void)setTextColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b;
- (void)setIsHighlightText:(BOOL)bHighlight;

+ (CGSize)calcTextHeight:(NSString *)str withWidth:(CGFloat)width;

@end
