//
//  RecordingWaveCell.h
//  Voice
//
//  Created by JiaLi on 11-8-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveView.h"

@protocol RecordingWaveCellDelegate <NSObject>

- (void)playing:(NSInteger)buttonTag;

@end

@interface RecordingWaveCell : UITableViewCell {
    UIButton* _playingButton;
    WaveView* _waveView;
    UIImageView* _icon;
    UILabel* _timelabel;
    id < RecordingWaveCellDelegate> delegate;
}
@property (nonatomic, retain) IBOutlet UIButton* playingButton;
@property (nonatomic, retain) IBOutlet WaveView* waveView;
@property (nonatomic, retain) IBOutlet UIImageView* icon;
@property (nonatomic, retain) IBOutlet UILabel* timelabel;
@property (nonatomic, assign) id < RecordingWaveCellDelegate> delegate;

- (IBAction)onPlaying:(id)sender;

@end
