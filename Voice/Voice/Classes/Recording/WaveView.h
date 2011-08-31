//
//  WaveView.h
//  Voice
//
//  Created by JiaLi on 11-8-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveFile.h"

@interface WaveView : UIView {
    CGFloat power;
    CGFloat peak;
    NSMutableArray* _points;
    
    NSString* wavefilename;
    unsigned long starttime;
    unsigned long endtime;
    
    // wave data
    unsigned long dwWidPerSencond;
    double dwavesecond;
    unsigned long buffertotal;
    CWaveFile* wavefile;
    IntPairVector waveSampleVector;
}

@property (nonatomic, retain) NSString* wavefilename;
@property (nonatomic) unsigned long starttime;
@property (nonatomic) unsigned long endtime;

- (void)setPower:(CGFloat)fPower peak:(CGFloat)fPeak;
- (CGPathRef)giveAPath;

- (bool)loadwavedata;
- (void)clearwavedata;
@end
