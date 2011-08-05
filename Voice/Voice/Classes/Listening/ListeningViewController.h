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

#define VOLUMNVIEW_TAG  50001
enum {
    PLAY_LOOPTYPE_LESSON    = 1,
    PLAY_LOOPTYPE_SENTENCE  = 2,
};
typedef NSInteger PLAY_LOOPTPYE;

@interface ListeningViewController : UIViewController {
    NSMutableArray* _sentencesArray;
    NSMutableArray* _teachersArray;
    UITableView* _sentencesTableView;
    ListeningToolbar* _listeningToolbar;
    
    UISlider* progressBar;
    UILabel* timepreces;
    UILabel* timelast;
    NSTimer* updateTimer;
    BOOL bStart;
    BOOL bLoopLessons;
    
    NSString* wavefile;             // 音频文件
    AVAudioPlayer *player;
    
    // 循环控制
    PLAY_LOOPTPYE looptype;         // 循环类型
    NSTimeInterval loopstarttime;   // 循环开始时间
    NSTimeInterval loopendtime;     // 循环结束时间
    
    NSTimeInterval timeStart;       // 起始时间
    
    NSInteger nPosition;            // 滚动位置
    CGFloat fVolumn;
}

@property (nonatomic, retain) NSMutableArray* sentencesArray;
@property (nonatomic, retain) NSMutableArray* teachersArray;
@property (nonatomic, retain) IBOutlet ListeningToolbar* listeningToolbar;
@property (nonatomic, retain) IBOutlet UITableView* sentencesTableView;
@property (nonatomic, retain) IBOutlet UISlider* progressBar;
@property (nonatomic, retain) IBOutlet UILabel* timepreces;
@property (nonatomic, retain) IBOutlet UILabel* timelast;
@property (nonatomic, retain) NSTimer* updataeTimer;
@property (nonatomic, retain) NSString* wavefile;
@property (nonatomic, retain) AVAudioPlayer* player;

- (IBAction)onPrevious:(id)sender;
- (IBAction)onOther:(id)sender;
- (IBAction)onStart:(id)sender;
- (IBAction)onNext:(id)sender;
- (IBAction)onLoop:(id)sender;

- (void)updateCurrentTime;
- (void)updateViewForPlayer;

- (int)getSentenceIndex:(NSTimeInterval)time;

@end
