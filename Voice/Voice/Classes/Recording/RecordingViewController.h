//
//  RecordingViewController.h
//  Voice
//
//  Created by JiaLi on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Sentence.h"
#import "WaveView.h"

@protocol RecordingDelegate <NSObject>
@optional

@end

@interface RecordingViewController : UIViewController {
    id<RecordingDelegate>   recordingdelegate;
    Sentence*               _sentence;
    UITextView*             _sentenceView;
    NSString*               wavefile;
    
    AVAudioRecorder*        recorder;
    NSMutableDictionary*    recordSetting;
    NSString*               recorderFilePath;
    WaveView*               _waveView;
    UIToolbar*              _toolbar;
    
    UIBarButtonItem*        _recordingItem;
    UIBarButtonItem*        _playingItem;
    UISlider*               _timeSlider;
    UILabel*                _costTimelabel;
    UILabel*                _totalTimelabel;
}

@property (nonatomic, assign) id<RecordingDelegate> recordingdelegate;
@property (nonatomic, retain) Sentence* sentence;
@property (nonatomic, retain) IBOutlet UITextView* sentenceView;
@property (nonatomic, retain) NSString* wavefile;
@property (nonatomic, retain) IBOutlet WaveView* waveView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) UIBarButtonItem* recordingItem;
@property (nonatomic, retain) UIBarButtonItem* playingItem;
@property (nonatomic, retain) UILabel*         costTimelabel;
@property (nonatomic, retain) UILabel*         totalTimelabel;
@property (nonatomic, retain) UISlider*        timeSlider;

- (void) loadToolbar;
- (void) prepareToRecord;
- (void) startrecorder;
- (void) stopRecording;

- (void) updateAudioDisplay;

- (void) onRecording:(id)sender;
- (void) onPlaying:(id)sender;
@end
