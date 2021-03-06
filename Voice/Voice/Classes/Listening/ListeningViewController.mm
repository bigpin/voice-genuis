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
#import "isaybioDecode.h"
#import "VoiceAppDelegate.h"

#define LOADINGVIEWTAG      20933
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
        bInit = NO;
        bParseWAV = NO;
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

- (void)initMembers;
{
    NSString* backString = STRING_BACK;
    [self.sentencesTableView setBackgroundView:nil];
    [self.sentencesTableView setBackgroundView:[[[UIView alloc] init] autorelease]];
    [self.sentencesTableView setBackgroundColor:UIColor.clearColor];
    
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
    // 解压wave
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:wavefile]) {
        [self addLoadingView];
        bParseWAV = YES;
        self.sentencesTableView.hidden = YES;
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self performSelector:@selector(parseWAVFile) withObject:nil afterDelay:2.0];
    } else {
        [self initValue];
    }
}

- (void)addLoadingView;
{
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 80)];
    loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    loadingView.layer.cornerRadius = 8;
    loadingView.tag = LOADINGVIEWTAG;
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    UIActivityIndicatorView* activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activeView startAnimating];
    activeView.center = CGPointMake(loadingView.center.x, loadingView.center.y - 10) ;
    [loadingView addSubview:activeView];
    [activeView release];
    UILabel* loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, loadingView.frame.size.height - 30, loadingView.frame.size.width, 20)];
    loadingText.textColor = [UIColor whiteColor];
    loadingText.text = STRING_LOADING_TEXT;
    loadingText.font = [UIFont systemFontOfSize:14];
    loadingText.backgroundColor = [UIColor clearColor];
    loadingText.textAlignment  = NSTextAlignmentCenter;
    [loadingView addSubview:loadingText];
    [loadingText release];
    loadingView.center = self.view.center;
    [self.view addSubview:loadingView];
    [loadingView release];
}

- (void)removeLoadingView;
{
    UIView* loadingView = [self.view viewWithTag:LOADINGVIEWTAG];
    if (loadingView != nil) {
        [loadingView removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!bInit) {
        bInit = YES;
        [self initMembers];
    }
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initValue;
{
    if (self.player == nil) {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: wavefile];
        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
        [fileURL release];
        
        self.player = newPlayer;
        [player prepareToPlay];
        [player setDelegate:(id<AVAudioPlayerDelegate>)self];
        [newPlayer release];
        self.player.currentTime = timeStart;
        self.player.volume = 5.0;
    }
    
    self.senCount.text = [NSString stringWithFormat:@"%d / %d ", (nPosition+1), [self.sentencesArray count]];
    loopstarttime = 0.0;
    loopendtime = self.player.duration;
    fVolumn = 5.0;
    
    NSString* recordingTitle = STRING_SINGLE_TRAINING;
    UIBarButtonItem* recordingItem = [[UIBarButtonItem alloc] initWithTitle:recordingTitle style:UIBarButtonItemStyleDone target:self action:@selector(onRecording)];
    self.navigationItem.rightBarButtonItem = recordingItem;
    self.recordingItem = recordingItem;
    [recordingItem release];
    
    self.listeningToolbar.previousItem.enabled = (nPosition != 0);
    self.listeningToolbar.nextItem.enabled = ((nPosition + 1) != [_sentencesArray count]);
}

- (void)parseWAVFile;
{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:wavefile]) {
        NSRange range = [wavefile rangeOfString:@"/" options:NSBackwardsSearch];
        NSString* wavePath = [wavefile substringToIndex:range.location];
        [fileMgr createDirectoryAtPath:wavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //NSLog(@"%@", wavePath);
    char strwavefile[256];
    [wavefile getCString:strwavefile maxLength:256 encoding:NSUTF8StringEncoding];
    
    char strisbfile[256];
    [self.isbfile getCString:strisbfile maxLength:256 encoding:NSUTF8StringEncoding];
    [isaybioDecode ISB_Isb:strisbfile toWav:strwavefile];
    [self removeLoadingView];
    [self initValue];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    bParseWAV = NO;
    [self.sentencesTableView reloadData];
    self.sentencesTableView.hidden = NO;
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
    if (!bParseWAV) {
        [self reloadTableView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    timeStart = 0.0;
    
    if (ePlayStatus == PLAY_STATUS_PLAYING) {
        [self setStatusPause];
        Sentence* sentence = [self.sentencesArray objectAtIndex:nPosition];
        self.player.currentTime = [sentence startTime];
        [self updateUI];
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
//                teacher3 = [self.teachersArray objectAtIndex:2];
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
    VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString* teacherfemale1 = app.configData.nTeacherHeadStyle == 0 ? @"female1.png" :@"female3.png";
    NSString* teachermale1 = app.configData.nTeacherHeadStyle == 0 ? @"male1.png" :@"male3.png";
    NSString* teacherfemale2 = app.configData.nTeacherHeadStyle == 0 ? @"female2.png" :@"female4.png";
    NSString* teachermale2 = app.configData.nTeacherHeadStyle == 0 ? @"male2.png" :@"male4.png";
    switch (nTeacher) {
        case 1:
        { 
            if ([[teacher1 gender] isEqualToString:@"female"]) {
                cell.imgIcon = [[NSString alloc] initWithFormat:@"%@/%@%@", resourcePath, @"teachers/", teacherfemale1];
            } else {
                cell.imgIcon = [[NSString alloc] initWithFormat:@"%@/%@%@", resourcePath, @"teachers/", teachermale1];
            }
                         
            NSString* imgName = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"bubble1.png"]];
            cell.imgName = imgName;
            [imgName release];
        }
            
            break;
        case 2:
        {
            if ([[teacher1 gender] isEqualToString:@"female"]) {
                cell.imgIcon = [[NSString alloc] initWithFormat:@"%@/%@%@", resourcePath, @"teachers/", teacherfemale1];
            } else {
                cell.imgIcon = [[NSString alloc] initWithFormat:@"%@/%@%@", resourcePath, @"teachers/", teachermale1];
            }
            if ([[teacher2 gender] isEqualToString:@"female"]) {
                cell.imgIcon = [[NSString alloc] initWithFormat:@"%@/%@%@", resourcePath, @"teachers/", teacherfemale2];
            } else {
                cell.imgIcon = [[NSString alloc] initWithFormat:@"%@/%@%@", resourcePath, @"teachers/", teachermale2];
            }

            NSString* imgName = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"bubble2.png"]];
            cell.imgName = imgName;
            [imgName release];
            break;
        }
        default:
            cell.imgIcon = [[NSString alloc] initWithFormat:@"%@/%@%@", resourcePath, @"teachers/", teacherfemale1];
            NSString* imgName = [[NSString alloc] initWithString:[resourcePath stringByAppendingPathComponent:@"bubble2.png"]];
            cell.imgName = imgName;
            [imgName release];
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
    CGFloat divide = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone?  0.9 : 0.95;
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
    self.player.currentTime = [sentence startTime];
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    nCurrentReadingCount = 0;
    ePlayStatus = PLAY_STATUS_PLAYING;
    if (nPosition > 0) {
        [self highlightCell:(nPosition-1)];
        nLastScrollPos = nPosition-1;
        nPosition = nPosition - 1;
        Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
        player.currentTime = [sentence startTime];
        [self updateUI];
        [self playfromCurrentPos];
    }
}

- (IBAction)onNext:(id)sender;
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    nCurrentReadingCount = 0;
    ePlayStatus = PLAY_STATUS_PLAYING;
    if (nPosition < [_sentencesArray count] - 1) {
        ePlayStatus = PLAY_STATUS_PLAYING;
        // scroll to cell
        [self highlightCell:(nPosition+1)];
        nPosition = nPosition + 1;
        Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
        player.currentTime = [sentence startTime];
        [self updateUI];
        [self playfromCurrentPos];
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
    switch (ePlayStatus) {
        case PLAY_STATUS_NONE:
        {
            [self highlightCell:nPosition];
            player.currentTime = [sentence startTime];
            ePlayStatus = PLAY_STATUS_PLAYING;
            nCurrentReadingCount = 0;
       }
            break;
        case PLAY_STATUS_PLAYING:
        {
            [self setStatusPause];
        }
            break;
        case PLAY_STATUS_PAUSING:
        {
            ePlayStatus = PLAY_STATUS_PLAYING;
        }
            break;
        default:
            break;
    }
    [self updateUI];
    [self playfromCurrentPos];
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    nCurrentReadingCount = 0;
    CGFloat v = self.progressBar.value - 1;
    nPosition = (v - 1);
    ePlayStatus = PLAY_STATUS_PLAYING;
    nPosition = v;
    Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
    loopstarttime = [sentence startTime];
    loopendtime = [sentence endTime];    
    player.currentTime = loopstarttime;
    [self updateUI];
    [self playfromCurrentPos];
}

- (IBAction)onChangingGotoSentence:(id)sender;
{
    NSInteger v = (NSInteger)self.progressBar.value;
    nPosition = (v - 1);
    if (ePlayStatus == PLAY_STATUS_PLAYING) {
        [self setStatusPause];
    }
    [self highlightCell:nPosition];
    [self updateUI];
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
        UInt32 doChangeDefaultRoute = 1;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                                 sizeof (doChangeDefaultRoute),
                                 &doChangeDefaultRoute); 
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
    self.listeningToolbar.previousItem.enabled = (nPosition != 0);
    self.listeningToolbar.nextItem.enabled = ((nPosition + 1) != [_sentencesArray count]);
	progressBar.value = nPosition + 1;
    self.senCount.text = [NSString stringWithFormat:@"%d / %d ", nPosition + 1, [self.sentencesArray count]];
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
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
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
    [self highlightCell:nPosition];
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

- (void)playfromCurrentPos;
{
    if (ePlayStatus != PLAY_STATUS_PLAYING) {
        return;
    }
    if (nLesson != PLAY_LESSON) {
        nCurrentReadingCount++;
    } 
    [self highlightCell:nPosition];
    [self updateUI];
    Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
    NSTimeInterval inter = [sentence endTime] - self.player.currentTime;
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                             sizeof (doChangeDefaultRoute),
                             &doChangeDefaultRoute); 
    [self.player play];
    [self performSelector:@selector(pauseintime) withObject:self afterDelay:inter];
    //[NSTimer scheduledTimerWithTimeInterval:inter target:self selector:@selector(pauseintime) userInfo:nil repeats:NO];        
}

- (void)pauseintime;
{
    if (ePlayStatus != PLAY_STATUS_PLAYING) {
        return;
    }
    
    Sentence* sentence = [_sentencesArray objectAtIndex:nPosition];
    NSTimeInterval inter = [sentence endTime] - [sentence startTime];
    if (nLesson == PLAY_LESSON) {
        [self.player pause];
        if (nPosition < ([_sentencesArray count] - 1)) {
            nPosition++;
            sentence = [_sentencesArray objectAtIndex:nPosition];
            self.player.currentTime = [sentence startTime];
            [self performSelector:@selector(playfromCurrentPos) withObject:self afterDelay:settingData.dTimeInterval];
           
            //[NSTimer scheduledTimerWithTimeInterval:(settingData.dTimeInterval) target:self selector:@selector(playfromCurrentPos) userInfo:nil repeats:NO];        
        } else {
            if (settingData.bLoop) {
                nPosition = 0;
                sentence = [_sentencesArray objectAtIndex:nPosition];
                self.player.currentTime = [sentence startTime];
                [self performSelector:@selector(playfromCurrentPos) withObject:self afterDelay:settingData.dTimeInterval];
            } else {
                [self setStatusPause];
                [self updateUI];
                nPosition = 0;
                sentence = [_sentencesArray objectAtIndex:nPosition];
                self.player.currentTime = [sentence startTime];
            }

            //[NSTimer scheduledTimerWithTimeInterval:(settingData.dTimeInterval) target:self selector:@selector(playfromCurrentPos) userInfo:nil repeats:NO];        
           
        }
    } else {
        [self.player pause];
        self.player.currentTime = [sentence startTime];
        if (nCurrentReadingCount < settingData.nReadingCount) {
          // [NSTimer scheduledTimerWithTimeInterval:inter target:self selector:@selector(playfromCurrentPos) userInfo:nil repeats:NO];        
            [self performSelector:@selector(playfromCurrentPos) withObject:self afterDelay:inter];

        } else {
            nCurrentReadingCount = 0;
            if (nPosition < ([_sentencesArray count] - 1)) {
                nPosition++;
                sentence = [_sentencesArray objectAtIndex:nPosition];
                self.player.currentTime = [sentence startTime];
                //[NSTimer scheduledTimerWithTimeInterval:inter target:self selector:@selector(playfromCurrentPos) userInfo:nil repeats:NO]; 
                [self performSelector:@selector(playfromCurrentPos) withObject:self afterDelay:inter];

            } else {
                ePlayStatus = PLAY_STATUS_NONE;
                [self updateUI];
            }
          
        }
    }
}

- (void)setStatusPause;
{
    [self highlightCell:nPosition];
    ePlayStatus = PLAY_STATUS_PAUSING;
    [player pause];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
