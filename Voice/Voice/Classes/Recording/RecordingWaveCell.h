//
//  RecordingWaveCell.h
//  Voice
//
//  Created by JiaLi on 11-8-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveView.h"

@interface RecordingWaveCell : UITableViewCell {
    UIButton* _playingButton;
    WaveView* _waveView;
}
@property (nonatomic, retain) IBOutlet UIButton* playingButton;
@property (nonatomic, retain) IBOutlet WaveView* waveView;

@end
