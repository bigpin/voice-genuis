//
//  WaveView.m
//  Voice
//
//  Created by JiaLi on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WaveView.h"


@implementation WaveView

@synthesize wavefilename;
@synthesize starttime;
@synthesize endtime;

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

- (bool)loadwavedata
{
    // 波形图宽高
    int nWidth = 100;
    int nHeight = 100;
    
    char strtemp[256];
    [wavefilename getCString:strtemp maxLength:256 encoding:NSUTF8StringEncoding];
    if (!wavefile) {
        wavefile = new CWaveFile();
    }
    wavefile->Open(strtemp);
    WAVEFORMATEX waveformatex = wavefile->GetWaveFormat();
    
    unsigned char* pBuffer = nil;
//    unsigned long nBufferSize = 0;
    wavefile->ReadWaveData(starttime, endtime, pBuffer, buffertotal);
//   unsigned long bytesperHDR = (waveformatex.nAvgBytesPerSec / 10) * 2;
    dwavesecond = (double)buffertotal / (double)waveformatex.nAvgBytesPerSec;
    
    unsigned long wavesecond = (unsigned long)dwavesecond + 1;
    dwWidPerSencond = nWidth / wavesecond;
    
    //waveSampleVector.clear();
    GetWaveSample(waveformatex, pBuffer, buffertotal, dwWidPerSencond, nHeight, waveSampleVector);
    [self setNeedsDisplay];
    return true;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();    
    UIColor* c = [UIColor blackColor];
    CGContextSetStrokeColorWithColor(context, [c CGColor]);
    /*CGPathRef halfPath = [self giveAPath];
    
    // Build the destination path
    CGMutablePathRef path = CGPathCreateMutable();
    
    // Transform to fit the waveform ([0,1] range) into the vertical space 
    // ([halfHeight,height] range)
    double halfHeight = floor(rect.size.height  / 2.0 );
    CGAffineTransform xf = CGAffineTransformIdentity;
    xf = CGAffineTransformTranslate( xf, 0.0, halfHeight );
    xf = CGAffineTransformScale( xf, 1.0, halfHeight );
    
    // Add the transformed path to the destination path
    CGPathAddPath( path, &xf, halfPath );
    
    // Transform to fit the waveform ([0,1] range) into the vertical space
    // ([0,halfHeight] range), flipping the Y axis
    xf = CGAffineTransformIdentity;
    xf = CGAffineTransformTranslate( xf, 0.0, halfHeight );
    xf = CGAffineTransformScale( xf, 1.0, -halfHeight );
    
    // Add the transformed path to the destination path
    CGPathAddPath( path, &xf, halfPath );
    CGContextStrokePath(context);
    
    CGPathRelease( halfPath ); // clean up!
     */
    if (waveSampleVector.size() > 0) {
        int x = waveSampleVector[0].first;
        int y = waveSampleVector[0].second;
        for(size_t i = 1; i < waveSampleVector.size(); i++)
        {
            CGContextMoveToPoint(context, x, y);
            CGContextAddLineToPoint(context, waveSampleVector[i].first, waveSampleVector[i].second);
            x = waveSampleVector[i].first;
            y = waveSampleVector[i].second;
        }
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
