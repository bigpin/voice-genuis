//
//  BubbleCell.m
//  MessageBubbles
//
//  Created by cwiles on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BubbleCell.h"


@implementation BubbleCell

@synthesize msgText;
@synthesize imgName;
@synthesize imgIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.accessoryType   = UITableViewCellAccessoryNone;
    self.backgroundColor = [UIColor clearColor];
  }
  
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    CGFloat startDis = 44;
    CGFloat space = 0.9;
    CGFloat width = self.frame.size.width * space - startDis;
    CGSize size           = [BubbleCell calcTextHeight:self.msgText withWidth:width ];
    UIImage *balloon      = [[UIImage imageWithContentsOfFile:self.imgName] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
      
    UIImageView* iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, startDis, startDis)];
    iconImage.image = [UIImage imageWithContentsOfFile:self.imgIcon];
    [self.contentView addSubview:iconImage];
    [iconImage release];
    
    UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width + 35, size.height + 10)];
    UIView *newView       = [[UIView alloc] initWithFrame:CGRectMake(startDis, 0.0, width, self.frame.size.height)];

    UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + startDis, 2, size.width, size.height)];

    txtLabel.lineBreakMode   = UILineBreakModeWordWrap;
    txtLabel.numberOfLines   = 0;
    txtLabel.text            = msgText;
    txtLabel.backgroundColor = [UIColor clearColor];
    txtLabel.font            = [UIFont systemFontOfSize:FONT_SIZE_BUBBLE];

    [txtLabel sizeToFit];

    [newImage setImage:balloon];
    [newView addSubview:newImage];

    [self setBackgroundView:newView];
    [self.contentView addSubview:txtLabel];

    [txtLabel release];

    [newImage release];
    [newView release];
}

+ (CGSize)calcTextHeight:(NSString *)str withWidth:(CGFloat)width;
{
  
  CGSize textSize = {width, 20000.0};
  CGSize size     = [str sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE_BUBBLE] 
                    constrainedToSize:textSize];
  
  return size;
}

- (void)dealloc {
    [msgText release];
    [imgName release];
    [imgIcon release];
    [super dealloc];
}


@end
