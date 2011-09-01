//
//  ListeningViewController.m
//  Say
//
//  Created by JiaLi on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSDate.h>
#import "ListeningViewController.h"
#import "Sentence.h"
#import "Teacher.h"
#import "UACellBackgroundView.h"
#import "BubbleCell.h"
#import "ListeningVolumView.h"
#import "RecordingViewController.h"
#import "SettingViewController.h"
#import "isaybio.h"

@implementation ListeningViewController
@synthesize sentencesArray = _sentencesArray;
@synthesize teachersArray = _teachersArray;
@synthesize sentencesTableView = _sentencesTableView;
@synthesize listeningToolbar = _listeningToolbar;
@synthesize recordingItem = _recordingItem;
@synthesize progressBar;
//@synthesize timepreces;
//@synthesize timelast;
@synthesize senCount;
@synthesize updataeTimer;
@synthesize wavefile;
@synthesize player;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;

        looptype = PLAY_LOOP_TPYE_SINGLE;
        progressBar.minimumValue = 0.0;
        progressBar.maximumValue = 10.0;
        
        updateTimer = nil;
        updataUI = nil;
        timeStart = 0.0;
        nPosition = 0;
        looptype = PLAY_LOOP_TPYE_NONE;
        nLesson = PLAY_LESSON_TYPE_NONE;
        bRecording = NO;
        ePlayStatus = PLAY_STATUS_NONE;
         //SettingViewController* setting = (SettingViewController*)[self.tabBarController.viewControllers objectAtIndex:1];
        
        settingData = [[SettingData alloc] init];
        [settingData loadSettingData];
        nLesson = settingData.eReadingMode == READING_MODE_WHOLE_TEXT ?  PLAY_LESSON : PLAY_SENTENCE;
        looptype = settingData.bLoop ? PLAY_LOOP_TPYE_SINGLE : PLAY_LOOP_TPYE_LOOP;
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(willEnterToBackground:) name:NOTI_WILLENTERFOREGROUND object:nil]; 

        resourcePath = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Image"]];
    }
    return self;
}

- (void)dealloc
{
    [settingData release];
    settingData = nil;
    [resourcePath release];
    resourcePath = nil;
    [self.listeningToolbar release];
    [self.sentencesArray release];
    [self.teachersArray release];
    [progressBar release];
    [updateTimer release];
    [updataUI release];
    [self.senCount release];
    [resourcePath release];
    [self.player stop];
    [self.player release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* bkimage = [[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/background_gray.png", resourcePath]] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bkimage];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(settingChanged:) name:NOTI_CHANGED_SETTING_VALUE object:nil]; 
   [self.listeningToolbar loadToolbar:self];
    
    UIImage* imageThumb = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/slider-handle.png", resourcePath]];
   
    [self.progressBar setThumbImage:imageThumb forState:UIControlStateNormal];

    UIImage* imageTrack = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/slider-track-right.png", resourcePath]];
    [self.progressBar setMaximumTrackImage:imageTrack forState:UIControlStateNormal];
    [self.progressBar setMinimumTrackImage:imageTrack forState:UIControlStateNormal];
   // self.navigationController.navigationBar.hidden = YES;
    //self.sentencesTableView.contentOffset = CGPointMake(0, 44);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // init the player
    // 解压wave
    if (![[NSFileManager defaultManager] fileExistsAtPath:wavefile]) {
        char strwavefile[256];
        [wavefile getCString:strwavefile maxLength:256 encoding:NSUTF8StringEncoding];
        
        NSString* isbfile = [[wavefile substringToIndex:wavefile.length - 4] stringByAppendingPathExtension:@"isb"];
        char strisbfile[256];
        [isbfile getCString:strisbfile maxLength:256 encoding:NSUTF8StringEncoding];
        if ([isaybio ISB_LoadFile:strisbfile])
            [isaybio ISB_SaveFile:strwavefile];
    }
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: wavefile];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    [fileURL release];
    
    self.player = newPlayer;
    [player prepareToPlay];
    [player setDelegate:(id<AVAudioPlayerDelegate>)self];
    [newPlayer release];
    
    progressBar.maximumValue = [self.player duration];
    progressBar.value = timeStart;
    self.player.currentTime = timeStart;
    self.senCount.text = [NSString stringWithFormat:@"%d / %d ", nPosition, [self.sentencesArray count]];
    //[timepreces setText:[NSString stringWithFormat:@"%.1f", self.player.currentTime]];
    //[timelast setText:[NSString stringWithFormat:@"%.1f", self.player.duration ]];
    loopstarttime = 0.0;
    loopendtime = self.player.duration;
    fVolumn = 0.8;
    
    NSString* recordingTitle = STRING_LISTENING;
    UIBarButtonItem* recordingItem = [[UIBarButtonItem alloc] initWithTitle:recordingTitle style:UIBarButtonItemStyleDone target:self action:@selector(onRecording)];
    self.navigationItem.rightBarButtonItem = recordingItem;
    self.recordingItem = recordingItem;
     [recordingItem release];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:NOTI_CHANGED_SETTING_VALUE object:nil]; 
    [self.recordingItem release];
    self.recordingItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    timeStart = 0.0;
    [self updateViewForPlayer];
    if (ePlayStatus == PLAY_STATUS_PLAYING) {
        // if playing, pause.
        [self onStart:nil];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
     //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
{
    ListeningVolumView* volumView = (ListeningVolumView*)[self.view viewWithTag:(NSInteger)VOLUMNVIEW_TAG];
    if (volumView != nil) {
        [volumView removeFromSuperview];
    }

    [self reloadTableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sentencesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"MsgListCell";
    
    BubbleCell *cell = (BubbleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[BubbleCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    } else {
        [cell cleanUp];
    }
    
    int nTeacher = 0;
    Teacher* teacher1 = nil;
    Teacher* teacher2 = nil;
    Teacher* teacher3 = nil;
    Sentence * sentence = [self.sentencesArray objectAtIndex:indexPath.section];
    CGFloat colorvalueR = 0.83;
    CGFloat colorvalueG = 0.83;
    CGFloat colorvalueBlue = 0.83;
    CGFloat r = 159.0/255.0;
    CGFloat g = 208.0/255.0;
    CGFloat b = 54.0/255.0;
    CGFloat txtColor1 = 0.0;
    CGFloat txtColor2 = 0.0;
    if ([self.teachersArray count] > 0) {
        if ([self.teachersArray count] == 2) {
            teacher1 = [self.teachersArray objectAtIndex:0];
            if ([teacher1.teacherid isEqualToString:sentence.techerid]) {
                nTeacher = 1;
                [cell setBurnColor:colorvalueR withGreen:colorvalueG withBlue:colorvalueBlue];
                [cell setTextColor:txtColor1 withGreen:txtColor1 withBlue:txtColor1];
            } else {
                nTeacher = 2;
                [cell setBurnColor:r withGreen:g withBlue:b];
                [cell setTextColor:txtColor2 withGreen:txtColor2 withBlue:txtColor2];
            }
            
        } else {
            if ([self.teachersArray count] == 3) {
                teacher1 = [self.teachersArray objectAtIndex:0];
                teacher2 = [self.teachersArray objectAtIndex:1];
                teacher3 = [self.teachersArray objectAtIndex:2];
                if ([teacher1.teacherid isEqualToString:sentence.techerid]) {
                    nTeacher = 1;
                    [cell setBurnColor:colorvalueR withGreen:colorvalueG withBlue:colorvalueBlue];
                    [cell setTextColor:txtColor1 withGreen:txtColor1 withBlue:txtColor1];
                } else if ([teacher2.teacherid isEqualToString:sentence.techerid]) {
                    nTeacher = 2;
                    [cell setBurnColor:r withGreen:b withBlue:b];
                    [cell setTextColor:txtColor2 withGreen:txtColor2 withBlue:txtColor2];
                } else {
                    nTeacher = 2;
                    [cell setBurnColor:0.92 withGreen:0.92 withBlue:0.92];
                    [cell setTextColor:txtColor1 withGreen:txtColor1 withBlue:txtColor1];
                    
                }
                
            }
            
        }
    } else {
        if (indexPath.section % 2 == 0) {
            nTeacher = 1;
            [cell setBurnColor:colorvalueR withGreen:colorvalueG withBlue:colorvalueBlue];
            [cell setTextColor:txtColor1 withGreen:txtColor1 withBlue:txtColor1];
        } else {
            nTeacher = 2;
            [cell setBurnColor:r withGreen:b withBlue:b];
            [cell setTextColor:txtColor2 withGreen:txtColor2 withBlue:txtColor2];
        }
        
    }
    switch (nTeacher) {
        case 1:
        { 
            if ([[teacher1 gender] isEqualToString:@"female"]) {
                cell.imgIcon = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"teachers/female1.png"]];;
            } else {
                cell.imgIcon = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"teachers/male1.png"]];;
            }
            
             
            NSString* imgName = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"bubble1.png"]];
            cell.imgName = imgName;
            [imgName release];
        }
            
            break;
        case 2:
        {
            if ([[teacher1 gender] isEqualToString:@"female"]) {
                cell.imgIcon = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"teachers/female1.png"]];;
            } else {
                cell.imgIcon = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"teachers/male1.png"]];;
            }

            if ([[teacher2 gender] isEqualToString:@"female"]) {
                cell.imgIcon = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"teachers/female2.png"]];;
            } else {
                cell.imgIcon = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"teachers/male2.png"]];;
            }

            NSString* imgName = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"bubble2.png"]];
            cell.imgName = imgName;
            [imgName release];
            break;
        }
        default:
            break;
    }
    /*NSString* imgName = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"aqua.png"]];
     cell.imgName = imgName;
     [imgName release];
     */
    cell.selectedImgName = [NSString stringWithFormat:@"%@/aqua_playing.png", resourcePath];
    cell.msgText = sentence.orintext;
    cell.transText = sentence.transtext;
    cell.nShowTextStyle = settingData.eShowTextType;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Sentence * sentence = [self.sentencesArray objectAtIndex:indexPath.section];
   	NSString *aMsg = sentence.orintext;
    NSString *transText = sentence.transtext;
    CGFloat divide = 0.9;
    CGFloat width = self.view.bounds.size.width * divide - 2*MAGIN_OF_BUBBLE_TEXT_START;
	CGSize size    = [BubbleCell calcTextHeight:aMsg withWidth:width];
    if (settingData.eShowTextType == 1 && sentence.transtext != nil) {
        CGSize szTrans = [BubbleCell calcTextHeight:transText withWidth:width];
        size = CGSizeMake(size.width, size.height + szTrans.height + MAGIN_OF_TEXTANDTRANSLATE);
    }
	size.height += 5;
	
	CGFloat height = (size.height < 44) ? 44 : size.height;
	
	return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    // create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(2, 0.0, self.view.bounds.size.width, 5.0)] autorelease];
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 5.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (int)getSentenceIndex:(NSTimeInterval)time
{
    Sentence* sentence = nil;
    for (int i = 0; i < [_sentencesArray count]; i++) {
        sentence = [_sentencesArray objectAtIndex:i];
        if (time < [sentence endTime]) {
           // NSLog(@"%d", i);
            return i;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Sentence* sentence = [self.sentencesArray objectAtIndex:indexPath.section];
  
    NSIndexPath * lastpath = [NSIndexPath indexPathForRow:0  inSection:nPosition];
    BubbleCell* cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:lastpath];
    [cell setIsHighlightText:NO];
    nPosition = indexPath.section;
    
    [_sentencesTableView scrollToRowAtIndexPath:indexPath
                               atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:indexPath];
    [cell setIsHighlightText:YES];
    
    if (bRecording) {
        RecordingViewController *detailViewController = [[RecordingViewController alloc] initWithNibName:@"RecordingViewController" bundle:nil];
        detailViewController.recordingdelegate = (id)self;
        detailViewController.sentence = sentence;
        detailViewController.wavefile = wavefile;
        detailViewController.resourcePath = resourcePath;
        // ...
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];

    } else {
        if (nLesson != 1) {
            loopstarttime = [sentence startTime];
            loopendtime = [sentence endTime];
        }
        player.currentTime = [sentence startTime];
        ePlayStatus = PLAY_STATUS_PLAYING;
        [self.player play];
        [self updateViewForPlayer];
    }

 }

#pragma Action
- (IBAction)onOther:(id)sender;
{
    ListeningVolumView* volumView = (ListeningVolumView*)[self.view viewWithTag:(NSInteger)VOLUMNVIEW_TAG];
    if (volumView != nil) {
        return;
    }
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ListeningVolumView" owner:self options:NULL];
    if ([array count] > 0) {
        volumView = [array objectAtIndex:0];
        volumView.frame = self.view.frame;
        volumView.centerView.center = CGPointMake(self.view.center.x, self.view.center.y - 25);
        volumView.viewDelegate = (id)self;
        [volumView loadResource];
        [volumView setVolumnDisplay:fVolumn];
        volumView.tag = VOLUMNVIEW_TAG;
        [self.view addSubview:volumView];
    }
}

- (IBAction)onPrevious:(id)sender;
{
    int index = [self getSentenceIndex:self.player.currentTime];
    if (index > 0) {
        Sentence* sentence = [_sentencesArray objectAtIndex:index - 1];
        player.currentTime = [sentence startTime];
       // NSLog(@"%d, %f", index - 1, player.currentTime);
    }
}

- (IBAction)onStart:(id)sender;
{
    switch (ePlayStatus) {
        case PLAY_STATUS_NONE:
        {
            if (looptype == PLAY_LOOP_TPYE_SINGLE && player.currentTime + 0.1 >= loopendtime) {
                player.currentTime = loopstarttime;
            }
           ePlayStatus = PLAY_STATUS_PLAYING;
            nLesson = PLAY_LESSON;
            [player play];
        }
            break;
        case PLAY_STATUS_PLAYING:
            ePlayStatus = PLAY_STATUS_PAUSING;
            [player pause];
            break;
        case PLAY_STATUS_PAUSING:
        {
            ePlayStatus = PLAY_STATUS_PLAYING;
            if (looptype == PLAY_LOOP_TPYE_SINGLE && player.currentTime + 0.1 >= loopendtime) {
                player.currentTime = loopstarttime;
            }
            [player play];
        }
            break;
        default:
            break;
    }
    /*if (player.playing) {
        [player pause];
    } else {
        if (bLoop == PLAY_LOOP_TPYE_SINGLE && player.currentTime + 0.1 >= loopendtime) {
            player.currentTime = loopstarttime;
        }
        [player play];
    }*/
    [self updateViewForPlayer];
}

- (IBAction)onNext:(id)sender;
{
    int index = [self getSentenceIndex:self.player.currentTime];
    if (index < [_sentencesArray count] - 1) {
        Sentence* sentence = [_sentencesArray objectAtIndex:index + 1];
        player.currentTime = [sentence startTime];
       // NSLog(@"%d,%f", index + 1, player.currentTime);
    }
}

- (void)onRecording;
{
    bRecording = !bRecording;
    if (bRecording) {
        NSString* t = STRING_RECORDING;
        self.recordingItem.title = t;
        self.recordingItem.style = UIBarButtonItemStyleDone;
        [self.player pause];
    } else {
        NSString* t = STRING_LISTENING;
        self.recordingItem.title = t;
        self.recordingItem.style = UIBarButtonItemStyleBordered;
    }

}

- (IBAction)onSetting:(id)sender;
{
    SettingViewController* setting = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    NSString* settingTitle = STRING_SETTING_TITLE;
    setting.title = settingTitle;
    [self.navigationController pushViewController:setting animated:YES];
    [setting release];
}

#pragma mark - Update timer

- (void)updateCurrentTime
{
    if (ePlayStatus != PLAY_STATUS_PLAYING) {
        return;
    }
    
    if (self.player.currentTime > loopendtime + 0.1 || self.player.currentTime < loopstarttime - 0.1) {
        if (looptype == PLAY_LOOP_TPYE_SINGLE) {
            [self.player pause];
            self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
        }
        else {
            self.player.currentTime = loopstarttime;
        }
    }
    
    int nCurrentIndex = [self getSentenceIndex:self.player.currentTime];
    
    // 如果是不是单句循环才滚动
    if (nLesson == PLAY_LESSON) {
        if (nCurrentIndex != nPosition) {
            // scroll to cell
            NSIndexPath * path = [NSIndexPath  indexPathForRow:0  inSection:nCurrentIndex];
            [_sentencesTableView scrollToRowAtIndexPath:path
                                       atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            BubbleCell* cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:path];
            [cell setIsHighlightText:YES];
            NSIndexPath * lastpath = [NSIndexPath indexPathForRow:0  inSection:nPosition];
            cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:lastpath];
            if (cell != nil && [cell isKindOfClass:[BubbleCell class]]) {
                // interrupted somtimes.
                [cell setIsHighlightText:NO];
            }
            nPosition = nCurrentIndex;
            
            // set the time Interval
            [player pause];
            [NSTimer scheduledTimerWithTimeInterval:settingData.dTimeInterval target:self selector:@selector(continueReading) userInfo:nil repeats:NO];
        } else if (nCurrentIndex == 0 && nPosition == 0) {
            // scroll to cell
           NSIndexPath * path = [NSIndexPath  indexPathForRow:0  inSection:nCurrentIndex];
            [_sentencesTableView scrollToRowAtIndexPath:path
                                       atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            BubbleCell* cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:path];
            [cell setIsHighlightText:YES];
         }

    }
}

- (void)continueReading
{
    if (ePlayStatus == PLAY_STATUS_PLAYING) {
        [player play];
    }
}

- (void)updateUI
{
    //    NSLog(@"%f, volume:%f", p.currentTime, volumBar.value);
    // 	currentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
    self.player.volume = fVolumn;
	progressBar.value = self.player.currentTime;
    //   NSLog(@"%f, %f === %f",p.currentTime, loopstarttime, loopendtime);
    
    self.senCount.text = [NSString stringWithFormat:@"%d / %d ", nPosition + 1, [self.sentencesArray count]];
    //[timepreces setText:[NSString stringWithFormat:@"%.1f", self.player.currentTime]];
    //[timelast setText:[NSString stringWithFormat:@"%.1f", self.player.duration]];
}

- (void)updateViewForPlayer
{
    switch (looptype) {
        case PLAY_LOOP_TPYE_SINGLE:
            self.player.numberOfLoops = 1;    // Loop playback until invoke stop method
            break;
        case PLAY_LOOP_TPYE_LOOP:
            self.player.numberOfLoops = -1;
            break;
            
        default:
            break;
    }
    
    if (ePlayStatus == PLAY_STATUS_PLAYING) {
        self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/pause.png", resourcePath]];
    } else {
        self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
    }
       
	if (updateTimer) 
		[updateTimer invalidate];

    updateTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
    
    if (updataUI) 
		[updataUI invalidate];
    
    updataUI = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
}

- (void)removeView:(ListeningVolumView*)volumnView;
{
 	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(finishedRemovePromptAnimation:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
	volumnView.transform = transform;
	transform = CGAffineTransformMakeScale(0.1, 0.1);
	volumnView.transform = transform;
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:volumnView cache:NO];
	[UIView commitAnimations]; 
    
}

- (void)setVolumn:(CGFloat)fV;
{
    fVolumn = fV;
}

- (void)finishedRemovePromptAnimation:(NSString*)animationID finished:(BOOL)finished context:(void *)context {
    [UIView setAnimationDelegate:nil];
    ListeningVolumView* volumView = (ListeningVolumView*)[self.view viewWithTag:(NSInteger)VOLUMNVIEW_TAG];
    if (volumView != nil) {
        [volumView removeFromSuperview];
    }
}

#pragma Notifications
- (void)settingChanged:(NSNotification *)aNotification
{
    [settingData loadSettingData];
    if (settingData.bLoop) {
        looptype = PLAY_LOOP_TPYE_LOOP;
        self.player.numberOfLoops = -1;
    } else {
        looptype = PLAY_LOOP_TPYE_SINGLE;
        self.player.numberOfLoops = 1;
    }
    
    if (settingData.eReadingMode == 0) {
        // 设置起始终止时间
        loopstarttime = 0.0;
        loopendtime = self.player.duration;
        nLesson = PLAY_LESSON;
   } else {
       // 设置单句起始和终止时间
       int nCurrentIndex = [self getSentenceIndex:self.player.currentTime];
       Sentence* sentence = [_sentencesArray objectAtIndex:nCurrentIndex];
       loopstarttime = [sentence startTime];
       loopendtime = [sentence endTime];    
       nLesson = PLAY_SENTENCE;
    }
    [self reloadTableView];
}

- (void)willEnterToBackground:(NSNotification *)aNotification
{
    if (ePlayStatus == PLAY_STATUS_PLAYING) {
        [self onStart:nil];
    }
}

#pragma Toolbar
- (BOOL)isPlaying
{
    return (ePlayStatus == PLAY_STATUS_PLAYING);
}

- (BOOL)isLesson
{
    return (nLesson == PLAY_LESSON);
}

- (BOOL)isLoop
{
    return (looptype == PLAY_LOOP_TPYE_SINGLE);
}

- (void)reloadTableView;
{
    [self.sentencesTableView reloadData];
    if (ePlayStatus != PLAY_STATUS_NONE) {
        NSIndexPath * path = [NSIndexPath  indexPathForRow:0  inSection:nPosition];
        [_sentencesTableView scrollToRowAtIndexPath:path
                                   atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        BubbleCell* cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:path];
        [cell setIsHighlightText:YES];
    }
}
@end
