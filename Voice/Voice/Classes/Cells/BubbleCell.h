//
//  BubbleCell.h
//  MessageBubbles
//
//  Created by cwiles on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FONT_SIZE_BUBBLE 17.0

@interface BubbleCell : UITableViewCell {
    NSString *msgText;
    NSString *imgName;
    NSString *imgIcon;
}

@property (nonatomic, retain) NSString *msgText;
@property (nonatomic, retain) NSString *imgName;
@property (nonatomic, retain) NSString *imgIcon;

+ (CGSize)calcTextHeight:(NSString *)str withWidth:(CGFloat)width;

@end
