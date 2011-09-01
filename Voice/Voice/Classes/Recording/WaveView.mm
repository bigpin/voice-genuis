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
    
    unsigned long wavesecondtemp = (unsigned long)dwavesecond + 1;
    dwWidPerSencond = nWidth / wavesecondtemp;
    
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
    
    unsigned long wavesecondtemp = (unsigned long)dwavesecond + 1;
    dwWidPerSencond = nWidth / wavesecondtemp;
    
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
    CGContextRef context = UIGraphicsGetCurrentContext();  
    
    if (bReadfromTime) {
        [self loadwavedatafromTime];
    } else {
        [self loadwavedata];
    }

    UIColor* c = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(context, [c CGColor]);
    if (waveSampleVector.size() > 0) {
         for(size_t i = 1; i < waveSampleVector.size(); i++)
        {
            CGContextMoveToPoint(context, i, waveSampleVector[i].first);
            CGContextAddLineToPoint(context, i, waveSampleVector[i].second);
        }
        CGContextStrokePath(context);
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
        CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
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
