//
//  ListeningViewController.h
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

enum {
    PLAY_LOOPTYPE_LESSON    = 1,
    PLAY_LOOPTYPE_SENTENCE  = 2,
};
typedef NSInteger PLAY_LOOPTPYE;

@interface ListeningViewController : UIViewController {
    NSMutableArray* _sentencesArray;
    UITableView* _sentencesTableView;
    UIBarButtonItem* previousItem;
    UIBarButtonItem* nextItem;
    UIBarButtonItem* playItem;
    UIBarButtonItem* loopSingle;
    UIBarButtonItem* loopLesson;
    
    UISlider* progressBar;
    UISlider* volumBar;
   	
    NSTimer* updateTimer;
    BOOL bStart;
    
    NSString* wavefile;             // 音频文件
    AVAudioPlayer *player;
    PLAY_LOOPTPYE looptype;
    NSTimeInterval timeStart;       // 起始时间
    
    NSInteger nPlayingIndex;
}

@property (nonatomic, retain) NSMutableArray* sentencesArray;
@property (nonatomic, retain) IBOutlet UITableView* sentencesTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* previousItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* nextItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* playItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* loopSingle;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* loopLesson;
@property (nonatomic, retain) IBOutlet UISlider* progressBar;
@property (nonatomic, retain) IBOutlet UISlider* volumBar;
@property (nonatomic, retain) NSTimer* updataeTimer;
@property (nonatomic, retain) NSString* wavefile;
@property (nonatomic, retain) AVAudioPlayer* player;

- (IBAction)onPrevious:(id)sender;
- (IBAction)onStart:(id)sender;
- (IBAction)onNext:(id)sender;
- (IBAction)onLoopLesson:(id)sender;
- (IBAction)onLoopSentence:(id)sender;

- (void)updateCurrentTime;
- (void)updateViewForPlayer;

@end
