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

@protocol RecordingDelegate <NSObject>
@optional

@end

@interface RecordingViewController : UIViewController {
    id<RecordingDelegate> recordingdelegate;
    Sentence* _sentence;
    UITextView* _sentenceView;
    NSString* wavefile;
    
    AVAudioRecorder* recorder;
    NSMutableDictionary* recordSetting;
    NSString* recorderFilePath;
}

@property (nonatomic, assign) id<RecordingDelegate> recordingdelegate;
@property (nonatomic, retain) Sentence* sentence;
@property (nonatomic, retain) IBOutlet UITextView* sentenceView;
@property (nonatomic, retain) NSString* wavefile;

- (void) prepareToRecord;
- (void)startrecorder;
- (void) stopRecording;

- (void) updateAudioDisplay;
@end
