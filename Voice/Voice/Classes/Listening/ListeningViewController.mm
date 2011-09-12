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
@synthesize isbfile = _isbfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;

        progressBar.minimumValue = 0.0;
        progressBar.maximumValue = 10.0;
        
        updateTimer = nil;
        timeStart = 0.0;
        nPosition = 0;
        nLesson = PLAY_LESSON_TYPE_NONE;
        bRecording = NO;
        ePlayStatus = PLAY_STATUS_NONE;
         //SettingViewController* setting = (SettingViewController*)[self.tabBarController.viewControllers objectAtIndex:1];
        
        settingData = [[SettingData alloc] init];
        [settingData loadSettingData];
        nCurrentReadingCount = 1;
        nLesson = settingData.eReadingMode == READING_MODE_WHOLE_TEXT ?  PLAY_LESSON : PLAY_SENTENCE;
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(willEnterToBackground:) name:NOTI_WILLENTERFOREGROUND object:nil]; 
        bAlReadyPaused = NO;
        nLastScrollPos = 0;
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
    [self.isbfile release];
    [self.listeningToolbar release];
    [self.sentencesArray release];
    [self.teachersArray release];
    [progressBar release];
    [updateTimer release];
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
    NSString* backString = STRING_BACK;
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle:backString style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];

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
    [self.progressBar setMaximumValue:[_sentencesArray count]];
    [self.progressBar setMinimumValue:1];
    [self.progressBar addTarget:self action:@selector(onGotoSentence:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressBar addTarget:self action:@selector(onChangingGotoSentence:) forControlEvents:UIControlEventTouchDragInside];
    
    self.progressBar.continuous = NO;
   // self.navigationController.navigationBar.hidden = YES;
    //self.sentencesTableView.contentOffset = CGPointMake(0, 44);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // init the player
    // 解压wave
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:wavefile]) {
        NSString* wavePath = [wavefile substringToIndex:(wavefile.length - 4)];
        NSFileManager* mgr = [NSFileManager defaultManager];
        if (![mgr fileExistsAtPath:wavePath]) {
            [mgr createDirectoryAtPath:wavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //NSLog(@"%@", wavePath);
        char strwavefile[256];
        [wavefile getCString:strwavefile maxLength:256 encoding:NSUTF8StringEncoding];
       
        char strisbfile[256];
        [self.isbfile getCString:strisbfile maxLength:256 encoding:NSUTF8StringEncoding];
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
    
    self.player.currentTime = timeStart;
    self.senCount.text = [NSString stringWithFormat:@"%d / %d ", (nPosition+1), [self.sentencesArray count]];
    //[timepreces setText:[NSString stringWithFormat:@"%.1f", self.player.currentTime]];
    //[timelast setText:[NSString stringWithFormat:@"%.1f", self.player.duration ]];
    loopstarttime = 0.0;
    loopendtime = self.player.duration;
    fVolumn = 0.8;
    
    NSString* recordingTitle = STRING_SINGLE_TRAINING;
    UIBarButtonItem* recordingItem = [[UIBarButtonItem alloc] initWithTitle:recordingTitle style:UIBarButtonItemStyleDone target:self action:@selector(onRecording)];
    self.navigationItem.rightBarButtonItem = recordingItem;
    self.recordingItem = recordingItem;
     [recordingItem release];

    self.listeningToolbar.previousItem.enabled = (nPosition != 0);
    self.listeningToolbar.nextItem.enabled = ((nPosition + 1) != [_sentencesArray count]);

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
        
        ePlayStatus = PLAY_STATUS_PAUSING;
        [player pause];
        self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
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
    if (ePlayStatus != PLAY_STATUS_NONE && nPosition == indexPath.section) {
        NSIndexPath * path = [NSIndexPath  indexPathForRow:0  inSection:nPosition];
            [_sentencesTableView scrollToRowAtIndexPath:path
                                       atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [cell setIsHighlightText:YES];
        nLastScrollPos = nPosition;
    } else {
        [cell setIsHighlightText:NO];
    }

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
  
    NSIndexPath * lastpath = [NSIndexPath indexPathForRow:0  inSection:nLastScrollPos];
    BubbleCell* cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:lastpath];
    [cell setIsHighlightText:NO];
    nPosition = indexPath.section;
    
    [_sentencesTableView scrollToRowAtIndexPath:indexPath
                               atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:indexPath];
    [cell setIsHighlightText:YES];
    nLastScrollPos = nPosition;

    RecordingViewController *detailViewController = [[RecordingViewController alloc] initWithNibName:@"RecordingViewController" bundle:nil];
    detailViewController.recordingdelegate = (id)self;
    detailViewController.sentence = sentence;
    detailViewController.nPos = nPosition;
    detailViewController.nTotalCount = [_sentencesArray count];
    detailViewController.wavefile = wavefile;
    detailViewController.resourcePath = resourcePath;
    [self updateUI];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];

   /* if (bRecording) {
        RecordingViewController *detailViewController = [[RecordingViewController alloc] initWithNibName:@"RecordingViewController" bundle:nil];
        detailViewController.recordingdelegate = (id)self;
        detailViewController.sentence = sentence;
        detailViewController.nPos = nPosition;
        detailViewController.nTotalCount = [_sentencesArray count];
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
        nCurrentReadingCount = 1;
        player.currentTime = [sentence startTime];
        ePlayStatus = PLAY_STATUS_PLAYING;
        [self.player play];
        [self updateViewForPlayer];
    }*/

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
    nCurrentReadingCount = 1;
    if (nPosition > 0) {
        [self highlightCell:(nPosition-1)];
        nLastScrollPos = nPosition-1;
        
        nPosition = nPosition - 1;
        [self updateUI];
        Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
        loopstarttime = [sentence startTime];
        loopendtime = [sentence endTime];    
        player.currentTime = loopstarttime;
        [player play];
        // NSLog(@"%d,%f", nPosition, player.currentTime);
    }

}

- (void)scrollCell
{
    if (bAlReadyPaused) {
        return;
    }
    int nCurrentIndex = [self getSentenceIndex:self.player.currentTime];
    
   if (nLesson == PLAY_SENTENCE) {
        if (nCurrentIndex != nPosition) {
            bAlReadyPaused = YES;
            // NSLog(@"pause sentence");
            [player pause];
            Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
            NSTimeInterval inter = [sentence endTime] - [sentence startTime];
            inter = inter + inter * 0.1;
            
            [NSTimer scheduledTimerWithTimeInterval:inter target:self selector:@selector(continueReading) userInfo:nil repeats:NO];
            
            if (nCurrentReadingCount == settingData.nReadingCount) {
                // scroll to cell
                [self highlightCell:nCurrentIndex];
                nPosition = nCurrentIndex;
                nCurrentReadingCount = 0;
                // NSLog(@"scroll to cell %d", nCurrentIndex);
            } 
            

            // set the time Interval
        } else if (nCurrentIndex == nPosition) {
            [self highlightCell:nPosition];
        }

    } else {
        if (nCurrentIndex != nPosition) {
            // scroll to cell
            
            bAlReadyPaused = YES;
            NSLog(@"highlightCell");
            [self highlightCell:nCurrentIndex];
            NSInteger nLast = nPosition;
            nPosition = nCurrentIndex;
            
            // set the time Interval
            [player pause];
            if (nLast == ([_sentencesArray count] - 1) && !settingData.bLoop) {
                ePlayStatus = PLAY_STATUS_NONE;
                [player stop];
                bAlReadyPaused = NO;
                self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
                [self updateUI];
                
            } else {
                [NSTimer scheduledTimerWithTimeInterval:settingData.dTimeInterval target:self selector:@selector(continueReading) userInfo:nil repeats:NO];
            }
        } else if (nCurrentIndex == nPosition) {
            // scroll to cell
            [self highlightCell:nCurrentIndex];
        }
    }
}

- (IBAction)onStart:(id)sender;
{
    Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
    loopstarttime = [sentence startTime];
    loopendtime = [sentence endTime];    
    nCurrentReadingCount = 1;
    switch (ePlayStatus) {
        case PLAY_STATUS_NONE:
        {
            //if (looptype == PLAY_LOOP_TPYE_SINGLE && player.currentTime + 0.1 >= loopendtime) {
            //    player.currentTime = loopstarttime;
            //}
            [self highlightCell:nPosition];
            ePlayStatus = PLAY_STATUS_PLAYING;
            [player play];
        }
            break;
        case PLAY_STATUS_PLAYING:
        {
            [self highlightCell:nPosition];
            ePlayStatus = PLAY_STATUS_PAUSING;
            [player pause];
        }
            break;
        case PLAY_STATUS_PAUSING:
        {
            ePlayStatus = PLAY_STATUS_PLAYING;
            [player play];
        }
            break;
        default:
            break;
    }
    [self updateViewForPlayer];
}

- (IBAction)onNext:(id)sender;
{
    nCurrentReadingCount = 1;
    if (nPosition < [_sentencesArray count] - 1) {
        ePlayStatus = PLAY_STATUS_PLAYING;
        // scroll to cell
        [self highlightCell:(nPosition+1)];
        nPosition = nPosition + 1;
        [self updateUI];
        Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
        loopstarttime = [sentence startTime];
        loopendtime = [sentence endTime];    
        player.currentTime = loopstarttime;
        [player play];
        // NSLog(@"%d,%f", nPosition, player.currentTime);
    }
    [self updateViewForPlayer];
}

- (void)onRecording;
{
    Sentence* sentence = [self.sentencesArray objectAtIndex:nPosition];
    RecordingViewController *detailViewController = [[RecordingViewController alloc] initWithNibName:@"RecordingViewController" bundle:nil];
    detailViewController.recordingdelegate = (id)self;
    detailViewController.sentence = sentence;
    detailViewController.nPos = nPosition;
    detailViewController.nTotalCount = [_sentencesArray count];
    detailViewController.wavefile = wavefile;
    detailViewController.resourcePath = resourcePath;
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];

}

- (IBAction)onSetting:(id)sender;
{
    SettingViewController* setting = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    NSString* settingTitle = STRING_SETTING_TITLE;
    setting.title = settingTitle;
    [self.navigationController pushViewController:setting animated:YES];
    [setting release];
}

- (IBAction)onGotoSentence:(id)sender;
{
    CGFloat v = self.progressBar.value - 1;
    if (v != nPosition) {
        ePlayStatus = PLAY_STATUS_PLAYING;
        nPosition = v;
        Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
        loopstarttime = [sentence startTime];
        loopendtime = [sentence endTime];    
        player.currentTime = loopstarttime;
        [player play];
        self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/pause.png", resourcePath]];
    }
    [self updateUI];
    [self updateViewForPlayer];
}

- (IBAction)onChangingGotoSentence:(id)sender;
{
    NSInteger v = (NSInteger)self.progressBar.value;
    self.senCount.text = [NSString stringWithFormat:@"%d / %d ", v, [self.sentencesArray count]];
 
}

#pragma mark - Update timer

- (void)updateCurrentTime
{
    if (ePlayStatus != PLAY_STATUS_PLAYING) {
        return;
    }
        
    [self scrollCell];
    self.listeningToolbar.previousItem.enabled = (nPosition != 0);
    self.listeningToolbar.nextItem.enabled = ((nPosition + 1) != [_sentencesArray count]);
}

- (void)continueReading
{
    NSLog(@"continueReading :Postion %d", nPosition);
    if (ePlayStatus == PLAY_STATUS_PLAYING) {
        if (nLesson == PLAY_SENTENCE) {
            if (nCurrentReadingCount != settingData.nReadingCount) {
                nCurrentReadingCount++;
                // NSLog(@"nCurrentReadingCount++");
                Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
                player.currentTime = [sentence startTime];
            }
            // NSLog(@"reading Count %d", nCurrentReadingCount);
        }
        bAlReadyPaused = NO;
       [player play];            
    
        [self updateUI];
    }
}

- (void)highlightCell:(NSInteger)nPos;
{
    if (nLastScrollPos != nPos) {
        NSIndexPath * lastpath = [NSIndexPath indexPathForRow:0  inSection:nLastScrollPos];
        BubbleCell* cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:lastpath];
        if (cell != nil && [cell isKindOfClass:[BubbleCell class]]) {
            // interrupted somtimes.
            [cell setIsHighlightText:NO];
        }
    }
    
    NSIndexPath * path = [NSIndexPath  indexPathForRow:0  inSection:nPos];
    if (nLastScrollPos != nPos) {
        [_sentencesTableView scrollToRowAtIndexPath:path
                                   atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    BubbleCell* cell = (BubbleCell*)[self.sentencesTableView cellForRowAtIndexPath:path];
    [cell setIsHighlightText:YES];
    nLastScrollPos = nPos;
}

- (void)updateUI
{
    self.player.volume = fVolumn;
	progressBar.value = nPosition + 1;
    self.senCount.text = [NSString stringWithFormat:@"%d / %d ", nPosition + 1, [self.sentencesArray count]];
}

- (void)updateViewForPlayer
{
    if (nLesson == PLAY_LESSON && settingData.bLoop) {
        self.player.numberOfLoops = -1;
    } else {
        self.player.numberOfLoops = 1;
    }
    
    if (ePlayStatus == PLAY_STATUS_PLAYING) {
        self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/pause.png", resourcePath]];
    } else {
        self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
    }
       
	if (updateTimer) 
		[updateTimer invalidate];

    updateTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
    
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
    if (settingData.bLoop && nLesson == PLAY_LESSON) {
        self.player.numberOfLoops = -1;
    } else {
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
        ePlayStatus = PLAY_STATUS_PAUSING;
        [player pause];
        self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
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

- (void)reloadTableView;
{
    [self.sentencesTableView reloadData];
}

- (Sentence*)getSentencefromPos:(NSInteger)pos;
{
    if (pos > -1 && pos < [_sentencesArray count]) {
        Sentence* sentence = [_sentencesArray objectAtIndex:pos];
        return sentence;
    }

    return nil;
}
@end
