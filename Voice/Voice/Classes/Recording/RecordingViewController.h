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
#import "AQRecorder.h"
#import "AQPlayer.h"
#import "RecordingWaveCell.h"

#define FAILEDRECORDINGVIEW_TAG 45505
#define PLAY_SRC_VOICE_BUTTON_TAG 50001
#define PLAY_USER_VOICE_BUTTON_TAG 50002

@protocol RecordingDelegate <NSObject>
@optional
- (Sentence*)getSentencefromPos:(NSInteger)pos;
@end

@interface RecordingViewController : UIViewController {
    UITableView*            _recordingTableView;
    id<RecordingDelegate>   recordingdelegate;
    Sentence*               _sentence;
    UITextView*             _sentenceView;
    NSString*               wavefile;
    
	//AQPlayer*				player;
	AQRecorder*				recorder;
    AVAudioPlayer *         player;
    NSMutableDictionary*    recordSetting;
    NSString*               recorderFilePath;
    WaveView*               _waveView;
    UIToolbar*              _toolbar;
    
    UIBarButtonItem*        _recordingItem;
    UIBarButtonItem*        _previousItem;
    UIBarButtonItem*        _nextItem;
    UIProgressView*         _timeProgress;
    UILabel*                _costTimelabel;
    UILabel*                _totalTimelabel;
    NSString*               resourcePath;
    BOOL					playbackWasInterrupted;
	BOOL					playbackWasPaused;
	
	CFStringRef				recordFilePath;
    RecordingWaveCell *     recordCell;
    BOOL                    isStopPlaySrc;
    NSInteger               nPos;
    NSInteger               nTotalCount;
    NSMutableString*         _psContent;
}

@property (nonatomic, assign) NSString* resourcePath;
@property (nonatomic, retain) IBOutlet UITableView* recordingTableView;
@property (nonatomic, assign) id<RecordingDelegate> recordingdelegate;
@property (nonatomic, retain) Sentence* sentence;
@property (nonatomic, retain) IBOutlet UITextView* sentenceView;
@property (nonatomic, retain) NSString* wavefile;
@property (nonatomic, retain) IBOutlet WaveView* waveView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) UIBarButtonItem* recordingItem;
@property (nonatomic, retain) UIBarButtonItem* previousItem;
@property (nonatomic, retain) UIBarButtonItem* nextItem;
@property (nonatomic, retain) UILabel*         costTimelabel;
@property (nonatomic, retain) UILabel*         totalTimelabel;
@property (nonatomic, retain) UIProgressView*        timeProgress;
//@property (readonly)			AQPlayer			*player;
@property (readonly)			AQRecorder			*recorder;
@property						BOOL				playbackWasInterrupted;
@property (nonatomic, assign) NSInteger nPos;
@property (nonatomic, assign) NSInteger nTotalCount;

- (void)initMembers;
- (void) loadToolbar;
- (void) updateAudioDisplay;
- (void) playingSrcVoice;
- (void) stop;
- (void) start;
- (void) onRecording:(id)sender;
- (void) onPrevious:(id)sender;
- (void) onNext:(id)sender;
- (void)animationProgress;
- (void)stopPlayingSrcVoice:(NSMutableDictionary*)dic;
- (void) playingRecordingVoice;
- (void)removeRecordingFile;
- (void)startRecordingView;
- (void)removeStartRecordingView;
- (void)addFailedRecordingView;
- (void)removeFailedRecordingView;
- (void)setpscontent;
- (NSString*)getSrcTextString;
@end
