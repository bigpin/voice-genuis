//
//  ListeningViewController.h
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ListeningToolbar.h"
#import "SettingData.h"

#define VOLUMNVIEW_TAG  50001
enum {
    PLAY_LOOP_TPYE_NONE      = 0,
    PLAY_LOOP_TPYE_SINGLE    = 1,
    PLAY_LOOP_TPYE_LOOP      = 2,
};
typedef NSInteger PLAY_LOOP_TPYE;

enum {
    PLAY_LESSON_TYPE_NONE = 0,
    PLAY_LESSON = 1,
    PLAY_SENTENCE = 2,
};
typedef NSInteger PLAY_LESSON_TYPE;

typedef enum {
	PLAY_STATUS_NONE = 0,
	PLAY_STATUS_PLAYING,
	PLAY_STATUS_PAUSING,
	PLAY_STATUS_PAUSING_END
} PLAY_STATUS;

@interface ListeningViewController : UIViewController {
    NSMutableArray* _sentencesArray;
    NSMutableArray* _teachersArray;
    UITableView* _sentencesTableView;
    ListeningToolbar* _listeningToolbar;
    UIBarButtonItem* _recordingItem;
    UISlider* progressBar;
    //UILabel* timepreces;
    //UILabel* timelast;
    UILabel* senCount;
    NSTimer* updateTimer;
    NSTimer* updataUI;
    int nLesson;
    BOOL bRecording;
    NSString* wavefile;             // 音频文件
    NSString* resourcePath;
    AVAudioPlayer *player;
    
    // 循环控制
    PLAY_LOOP_TPYE looptype;         // 循环类型
    NSTimeInterval loopstarttime;   // 循环开始时间
    NSTimeInterval loopendtime;     // 循环结束时间
    
    NSTimeInterval timeStart;       // 起始时间
    
    NSInteger nPosition;            // 滚动位置
    CGFloat fVolumn;
    PLAY_STATUS ePlayStatus;
    SettingData* settingData;
    BOOL bFirstToolbar;
}

@property (nonatomic, retain) NSMutableArray* sentencesArray;
@property (nonatomic, retain) NSMutableArray* teachersArray;
@property (nonatomic, retain) IBOutlet ListeningToolbar* listeningToolbar;
@property (nonatomic, retain) IBOutlet UITableView* sentencesTableView;
@property (nonatomic, retain) IBOutlet UISlider* progressBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* recordingItem;
//@property (nonatomic, retain) IBOutlet UILabel* timepreces;
//@property (nonatomic, retain) IBOutlet UILabel* timelast;
@property (nonatomic, retain) IBOutlet UILabel* senCount;
@property (nonatomic, retain) NSTimer* updataeTimer;
@property (nonatomic, retain) NSString* wavefile;
@property (nonatomic, retain) AVAudioPlayer* player;

- (IBAction)onPrevious:(id)sender;
- (IBAction)onOther:(id)sender;
- (IBAction)onStart:(id)sender;
- (IBAction)onNext:(id)sender;
- (IBAction)onLoop:(id)sender;
- (IBAction)onMore:(id)sender;
- (IBAction)onSetting:(id)sender;
- (void)onRecording;
- (void)updateCurrentTime;
- (void)updateViewForPlayer;
- (void)updateUI;

- (int)getSentenceIndex:(NSTimeInterval)time;

@end
