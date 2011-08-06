//
//  BubbleCell.m
//  MessageBubbles
//
//  Created by cwiles on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BubbleCell.h"
#define TEXTLABLETAG    2003
@implementation BubbleImageView
@synthesize imgName;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        red = green = blue = 1.0;
        //self.backgroundColor = nil;
    }
    return self;
}

- (void)setBurnColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b;
{
    red = r;
    green = g;
    blue = b;
}

- (void)setImgName:(NSString *)img
{
    imgName = img;
    UIImage* balloon = [[UIImage imageWithContentsOfFile:img] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    balloonImageView = [[UIImageView alloc] initWithFrame:self.frame];
    balloonImageView.backgroundColor = [UIColor clearColor];
    balloonImageView.image = balloon;
    UIImage* burn = [self getBurnImage];
    UIImageView* v = [[UIImageView alloc] initWithFrame:self.frame];
    v.image = burn;
    [self addSubview:v];
    [v release];
    [balloonImageView release];
    balloonImageView = nil;
    //[self addSubview:balloonImageView];
    //[balloonImageView release];
}

- (UIImage*)getSrcImage
{
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	CALayer *l = balloonImageView.layer;
    [l renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)getBurnImage
{
    UIImage* img = [self getSrcImage];
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // set the fill color
    UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:0.5];
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImg;
}

@end

@implementation BubbleCell

@synthesize msgText;
@synthesize imgName;
@synthesize imgIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.accessoryType   = UITableViewCellAccessoryNone;
    self.backgroundColor = [UIColor clearColor];
      textRed = textGreen = textBlue = 0.0;
      bHighlight = NO;
  }
  
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)setBurnColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b;
{
    bgRed = r;
    bgGreen = g;
    bgBlue = b;
}

- (void)setTextColor:(CGFloat)r withGreen:(CGFloat)g withBlue:(CGFloat)b;
{
    textRed = r;
    textGreen = g;
    textBlue = b;
}

- (void)setIsHighlightText:(BOOL)b;
{
    bHighlight = b;
    if (bHighlight) {
        textContent.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
    } else {
        textContent.backgroundColor = [UIColor clearColor];
    }

}

- (void)layoutSubviews {
    CGFloat startDis = 44;
    CGFloat space = 0.9;
    CGFloat width = self.frame.size.width * space - startDis;
    CGSize size           = [BubbleCell calcTextHeight:self.msgText withWidth:width ];
      
    CGFloat bubbleImageHeight = size.height + 18;
    CGFloat iconY = bubbleImageHeight < startDis ? 0 : bubbleImageHeight - startDis;
    UIImageView* iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, iconY, startDis, startDis)];
    iconImage.image = [UIImage imageWithContentsOfFile:self.imgIcon];
    [self.contentView addSubview:iconImage];
    [iconImage release];
    
    BubbleImageView *newImage = [[BubbleImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width + 35, bubbleImageHeight)];

    [newImage setBurnColor:bgRed withGreen:bgGreen withBlue:bgBlue];
    newImage.imgName = self.imgName;
    UIView *newView       = [[UIView alloc] initWithFrame:CGRectMake(startDis, 0.0, width, self.frame.size.height)];
    newView.backgroundColor = [UIColor clearColor];
    newView.backgroundColor = nil;
    UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + startDis, 8, size.width, size.height)];

    txtLabel.lineBreakMode   = UILineBreakModeWordWrap;
    txtLabel.numberOfLines   = 0;
    txtLabel.text            = msgText;
    txtLabel.textColor         = [UIColor colorWithRed:textRed green:textGreen blue:textBlue alpha:1.0];
    if (bHighlight) {
        txtLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
    } else {
        txtLabel.backgroundColor = [UIColor clearColor];
    }
    txtLabel.font            = [UIFont systemFontOfSize:FONT_SIZE_BUBBLE];
    txtLabel.tag             = TEXTLABLETAG;
    [txtLabel sizeToFit];

    [newView addSubview:newImage];

    [self setBackgroundView:newView];
    [self.contentView addSubview:txtLabel];
    textContent = txtLabel;
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
