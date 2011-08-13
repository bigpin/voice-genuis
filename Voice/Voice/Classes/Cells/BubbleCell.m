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
#define SELECTED_COLOR_R    43.0/255.0
#define SELECTED_COLOR_G    184.0/255.0
#define SELECTED_COLOR_B    236.0/255.0

@implementation BubbleImageView
@synthesize selectedImgName = _selectedImgName;
@synthesize imgName;
@synthesize bColored;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        bColored = YES;
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
    UIImage* burn = bColored ? [self getBurnImage] : [self getSrcImage];
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
    CGContextSetBlendMode(context, kCGBlendModeColorDodge);
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


@implementation BubbleLabel
@synthesize bUnderline;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bUnderline = NO;
    }
    return self;
}

/*- (void)drawRect:(CGRect)rect {
    if (!bUnderline) {
        [super drawRect:rect];  
       return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 207.0f/255.0f, 91.0f/255.0f, 44.0f/255.0f, 1.0f); // RGBA
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 1);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - 1);
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];  
}
*/
@end

@implementation BubbleCell

@synthesize msgText;
@synthesize imgName;
@synthesize imgIcon;
@synthesize selectedImgName = _selectedImgName;
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
        // change bubble view color to blue
        UIView* bubbleParent = bubbleView.superview;
        if (selectedView == nil) {
            BubbleImageView *newImage = [[BubbleImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, textSize.width + 35, textSize.height + 18)];
            newImage.bColored = NO;
            [newImage setBurnColor:1.0 withGreen:1.0 withBlue:1.0];
            // [newImage setBurnColor:SELECTED_COLOR_R withGreen:SELECTED_COLOR_G withBlue:SELECTED_COLOR_B];
            
            newImage.imgName = self.selectedImgName;
            selectedView = newImage;
            [bubbleParent addSubview:newImage];
            [bubbleParent sendSubviewToBack:newImage];
            [newImage release];

        }
        // set text color
        /*textContent.textColor         = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        textContent.bUnderline = YES;
        [textContent setNeedsDisplay];*/
        
        // set the microphone position
        /*microphone.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:microphone cache:NO];
        [UIView setAnimationDuration:0.5];
        [UIView commitAnimations];*/
    } else {
        if (selectedView != nil) {
            [selectedView removeFromSuperview];
            selectedView = nil;
        }
        
        // set the microphone position
        /*[UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:microphone cache:NO];
        [UIView setAnimationDuration:0.5];
        microphone.hidden = YES;
        [UIView commitAnimations];*/
    }

}

- (void)layoutSubviews {
    CGFloat startDis = 24;
    CGFloat space = 0.9;
    CGFloat width = self.frame.size.width * space - startDis;
    CGSize size           = [BubbleCell calcTextHeight:self.msgText withWidth:width ];
    textSize = size;
    CGFloat bubbleImageHeight = size.height + 18;
    CGFloat iconY = bubbleImageHeight < startDis ? 0 : (bubbleImageHeight - startDis)/2;
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
    BubbleLabel *txtLabel = [[BubbleLabel alloc] initWithFrame:CGRectMake(15 + startDis, 8, size.width, size.height)];

    txtLabel.lineBreakMode   = UILineBreakModeWordWrap;
    txtLabel.numberOfLines   = 0;
    txtLabel.text            = msgText;
    txtLabel.textColor         = [UIColor colorWithRed:textRed green:textGreen blue:textBlue alpha:1.0];
    txtLabel.backgroundColor = [UIColor clearColor];
    txtLabel.font            = [UIFont systemFontOfSize:FONT_SIZE_BUBBLE];
    txtLabel.tag             = TEXTLABLETAG;
    [txtLabel sizeToFit];

    [newView addSubview:newImage];
    bubbleView = newImage;
    [self setBackgroundView:newView];
    [self.contentView addSubview:txtLabel];
    textContent = txtLabel;
    
    /*UIImageView* micro = [[UIImageView alloc] initWithFrame:CGRectMake(iconImage.frame.origin.x + iconImage.frame.size.width - 12, iconImage.frame.origin.y + iconImage.frame.size.height - 24, 24, 24)];
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
   UIImage* microimage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/microphone.png",  resourcePath]];
    micro.image = microimage;
    [self.contentView addSubview:micro];
    microphone = micro;
    [micro release];
    [microphone setHidden:YES];*/
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
    selectedView = nil;
    bubbleView = nil;
    [self.selectedImgName release];
    [msgText release];
    [imgName release];
    [imgIcon release];
    [super dealloc];
}


@end
