//
//  WaveView.m
//  Voice
//
//  Created by JiaLi on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WaveView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WaveView

@synthesize wavefilename;
@synthesize starttime;
@synthesize endtime;
@synthesize bReadfromTime;
@synthesize dwWidPerSencond;
@synthesize dwavesecond;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        if (_points == nil) {
            _points = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)dealloc
{
    if (_points != nil) {
        [_points release];
        _points = nil;
    }
    [super dealloc];
}

- (void)clearwavedata;
{
    if (wavefile) {
        delete wavefile;
        wavefile = NULL;
    }
    
    dwWidPerSencond = 0;
    dwavesecond = 0;
    buffertotal = 0;
    waveSampleVector.clear();   
}

- (bool)loadwavedata
{
    [self clearwavedata];
    // 波形图宽高
    int nWidth = self.frame.size.width;
    int nHeight = self.frame.size.height;
    
    char strtemp[256];
    [wavefilename getCString:strtemp maxLength:256 encoding:NSUTF8StringEncoding];
    if (!wavefile) {
        wavefile = new CWaveFile();
    }
    wavefile->Open(strtemp);
    WAVEFORMATEX waveformatex = wavefile->GetWaveFormat();
    
    unsigned char* pBuffer = nil;
//    unsigned long nBufferSize = 0;
    wavefile->ReadAllWaveData(pBuffer, buffertotal);
    //wavefile->ReadWaveData(starttime, endtime, pBuffer, buffertotal);
//   unsigned long bytesperHDR = (waveformatex.nAvgBytesPerSec / 10) * 2;
    dwavesecond = (double)buffertotal / (double)waveformatex.nAvgBytesPerSec;
    
    // unsigned long wavesecondtemp = (unsigned long)dwavesecond + 1;
    dwWidPerSencond = nWidth / dwavesecond;
    
    //waveSampleVector.clear();
    GetWaveSample(waveformatex, pBuffer, buffertotal, dwWidPerSencond, nHeight, waveSampleVector);
    [self setNeedsDisplay];
    return true;
}

- (bool)loadwavedatafromTime;
{
    [self clearwavedata];
    // 波形图宽高
    int nWidth = self.frame.size.width;
    int nHeight = self.frame.size.height;
    
    char strtemp[256];
    [wavefilename getCString:strtemp maxLength:256 encoding:NSUTF8StringEncoding];
    if (!wavefile) {
        wavefile = new CWaveFile();
    }
    wavefile->Open(strtemp);
    WAVEFORMATEX waveformatex = wavefile->GetWaveFormat();
    
    unsigned char* pBuffer = nil;
    wavefile->ReadWaveData(starttime, endtime, pBuffer, buffertotal);
    dwavesecond = (double)buffertotal / (double)waveformatex.nAvgBytesPerSec;
    
    // unsigned long wavesecondtemp = (unsigned long)dwavesecond + 1;
    dwWidPerSencond = nWidth / dwavesecond;
    
    //waveSampleVector.clear();
    GetWaveSample(waveformatex, pBuffer, buffertotal, dwWidPerSencond, nHeight, waveSampleVector);
    return true;

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (wavefilename == nil) {
        return;
    }
    NSFileManager* mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:wavefilename]) {
        return;
    }
    if (colorImage == nil) {
        NSString* resourcePath = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Image/color.png"]];
        
        colorImage = [[UIImage alloc] initWithContentsOfFile:resourcePath];
        [resourcePath release];
    }

    CGContextRef context = UIGraphicsGetCurrentContext();  
    
    if (bReadfromTime) {
        [self loadwavedatafromTime];
    } else {
        [self loadwavedata];
    }
    if (waveSampleVector.size() > 0) {
        UIColor* c = [UIColor whiteColor];
        CGContextSetStrokeColorWithColor(context, [c CGColor]);
        CGContextSetFillColorWithColor(context, [c CGColor]);
        
        int nCount = waveSampleVector.size() * 2;
        CGPoint *points = (CGPoint*)malloc(sizeof(CGPoint) * nCount);
        int minvalue = 1024;    // 波形最小值
        int maxvalue = 0;       // 波形最大值
        for (size_t i  = 0; i < waveSampleVector.size(); i++) {
            points[i].x = i;
            points[i].y = waveSampleVector.at(i).first;
            points[nCount - i - 1].x = i;
            points[nCount - i - 1].y = waveSampleVector.at(i).second;
            if (minvalue > waveSampleVector.at(i).first) {
                minvalue = waveSampleVector.at(i).first;
            }
            if (maxvalue < waveSampleVector.at(i).second) {
                maxvalue = waveSampleVector.at(i).second;
            }
        }
        // draw shadow
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 2, -1);
        CGContextBeginPath(context);
        CGContextAddLines(context, points, nCount);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        //free(points);
        CGContextClosePath(context);
        //CGContextClip(context);
        CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
        CGContextFillPath(context);
        CGContextRestoreGState(context);

        /*CGContextSaveGState(context);
        CGContextTranslateCTM(context, 1, -1);
        CGContextBeginPath(context);
        CGContextAddLines(context, points, nCount);
        CGContextSetLineJoin(context, kCGLineJoinBevel);
        //free(points);
        CGContextClosePath(context);
        //CGContextClip(context);
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillPath(context);
        CGContextRestoreGState(context);*/

        // draw color image
        CGContextSaveGState(context);
        CGContextBeginPath(context);
        CGContextAddLines(context, points, nCount);
        CGContextSetLineJoin(context, kCGLineJoinBevel);
        //free(points);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawImage(context, rect, colorImage.CGImage);
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        free(points);
    }    

    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextMoveToPoint(context, 0, rect.size.height/2 - 1);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2 - 1);
    CGContextStrokePath(context);
    
    UIColor *clr = [UIColor colorWithRed:147.0/255.0 green:194.0/255.0 blue:34.0/255.0 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, [clr CGColor]);
    
    CGContextMoveToPoint(context, 0, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
    CGContextStrokePath(context);   
    
    if (dwWidPerSencond != 0) {
        NSInteger nTimeCount = rect.size.width / dwWidPerSencond;
        CGFloat h = rect.size.height - 10;
        /// CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextSelectFont(context, "Helvetica", 16, kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetFillColorWithColor(context, [clr CGColor]);
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        for (NSInteger i = 0; i < nTimeCount; i++) {
            CGFloat w = (i+1) * dwWidPerSencond;
            CGContextMoveToPoint(context, w, h);
            CGContextAddLineToPoint(context, w, rect.size.height);
            
            CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
            CGContextSetTextMatrix(context, xform);
            NSString* str = [NSString stringWithFormat:@"%d.00", (i+1)];
            CGContextSetTextPosition(context, w + 2, rect.size.height - 2);
            CGContextShowText(context, [str UTF8String], strlen([str UTF8String]));
        }
        CGContextStrokePath(context);
    }
    UIGraphicsEndImageContext();
 /*
    if (waveSampleVector.size() > 0) {
        UIColor* c = [UIColor whiteColor];
        CGContextSetStrokeColorWithColor(context, [c CGColor]);
        CGContextSetFillColorWithColor(context, [c CGColor]);
        
        int nCount = waveSampleVector.size() * 2;
        CGPoint *points = (CGPoint*)malloc(sizeof(CGPoint) * nCount);
        int minvalue = 1024;    // 波形最小值
        int maxvalue = 0;       // 波形最大值
        for (size_t i  = 0; i < waveSampleVector.size(); i++) {
            points[i].x = i;
            points[i].y = waveSampleVector.at(i).first;
            points[nCount - i - 1].x = i;
            points[nCount - i - 1].y = waveSampleVector.at(i).second;
            if (minvalue > waveSampleVector.at(i).first) {
                minvalue = waveSampleVector.at(i).first;
            }
            if (maxvalue < waveSampleVector.at(i).second) {
                maxvalue = waveSampleVector.at(i).second;
            }
        }
        
        CGContextSaveGState(context);
        CGContextBeginPath(context);
        CGContextAddLines(context, points, nCount);
        free(points);
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = { 0.0, 1.0 };
        
        // 渐变颜色区间
        NSArray *colors = [NSArray arrayWithObjects:(id)[[UIColor blueColor] CGColor], (id)[[UIColor redColor] CGColor], nil];
        
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), minvalue);
        CGPoint midPoint = CGPointMake(CGRectGetMidX(rect), (maxvalue + minvalue) / 2);
        CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), maxvalue);
        
        CGContextDrawLinearGradient(context, gradient, midPoint, startPoint, 0);
        CGContextDrawLinearGradient(context, gradient, midPoint, endPoint, 0);
      
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        CGContextRestoreGState(context);
    }

    // CGContextFillPath(context);
    // CGContextStrokePath(context);
   
//    if (waveSampleVector.size() > 0) {
//         for(size_t i = 1; i < waveSampleVector.size(); i++)
//        {
//            CGContextMoveToPoint(context, i, waveSampleVector[i].first);
//            CGContextAddLineToPoint(context, i, waveSampleVector[i].second);
//        }
//        CGContextStrokePath(context);
//    }
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextMoveToPoint(context, 0, rect.size.height/2 - 1);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2 - 1);
    CGContextStrokePath(context);

    UIColor *clr = [UIColor colorWithRed:147.0/255.0 green:194.0/255.0 blue:34.0/255.0 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, [clr CGColor]);
    
    CGContextMoveToPoint(context, 0, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
    CGContextStrokePath(context);
    
    if (dwWidPerSencond != 0) {
        NSInteger nTimeCount = rect.size.width / dwWidPerSencond;
        CGFloat h = rect.size.height - 10;
       /// CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextSelectFont(context, "Helvetica", 16, kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetFillColorWithColor(context, [clr CGColor]);
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
       for (NSInteger i = 0; i < nTimeCount; i++) {
            CGFloat w = (i+1) * dwWidPerSencond;
            CGContextMoveToPoint(context, w, h);
            CGContextAddLineToPoint(context, w, rect.size.height);
            
           CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
           CGContextSetTextMatrix(context, xform);
           NSString* str = [NSString stringWithFormat:@"%d.00", (i+1)];
           CGContextSetTextPosition(context, w + 2, rect.size.height - 2);
           CGContextShowText(context, [str UTF8String], strlen([str UTF8String]));
        }
        CGContextStrokePath(context);
    }
    UIGraphicsEndImageContext();
  */
}

- (CGPathRef)giveAPath
{
    // Assume mAudioPoints is a float* with your audio points 
    // (with {sampleIndex,value} pairs), and mAudioPointCount 
    // contains the # of points in the buffer.
    NSInteger nCount = [_points count];
    if (nCount == 0) {
        return nil;
    }
    CGPoint *pts = (CGPoint *)malloc(sizeof(CGPoint) * nCount);
    for (NSInteger i = 0; i < nCount; i++) {
        NSValue *val = [_points objectAtIndex:i];
        pts[i] = [val CGPointValue];
        
    }

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, pts, nCount ); // magic!
    free(pts);
    return path;
    
    
}
- (void)setPower:(CGFloat)fPower peak:(CGFloat)fPeak;
{
    if (_points == nil) {
        _points = [[NSMutableArray alloc] init];
    }
    power = fPower;
    peak  = fPeak;
    [_points addObject:[NSValue valueWithCGPoint:CGPointMake(power, peak)]];
    [self setNeedsDisplay];
    NSLog(@"power %f", power);
    NSLog(@"peak %f", peak);
}

@end
