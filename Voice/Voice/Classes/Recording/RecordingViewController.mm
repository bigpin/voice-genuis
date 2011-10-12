//
//  RecordingViewController.m
//  Voice
//
//  Created by JiaLi on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RecordingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BubbleCell.h"
#import "MobClick.h"
#import "VoiceAppDelegate.h"

@implementation RecordingViewController
@synthesize recordingdelegate;
@synthesize sentence = _sentence;
@synthesize sentenceView = _sentenceView;
@synthesize wavefile;
@synthesize waveView = _waveView;
@synthesize toolbar = _toolbar;
@synthesize recordingItem = _recordingItem;
@synthesize costTimelabel = _costTimelabel;
@synthesize totalTimelabel = _totalTimelabel;
@synthesize timeProgress = _timeProgress;
@synthesize recordingTableView = _recordingTableView;
@synthesize resourcePath;
@synthesize previousItem = _previousItem;
@synthesize nextItem = _nextItem;
@synthesize nPos;
@synthesize nTotalCount;

//@synthesize player;
@synthesize recorder;
@synthesize playbackWasInterrupted;


char *OSTypeToStr(char *buf, OSType t)
{
	char *p = buf;
	char str[4], *q = str;
	*(UInt32 *)str = CFSwapInt32(t);
	for (int i = 0; i < 4; ++i) {
		if (isprint(*q) && *q != '\\')
			*p++ = *q++;
		else {
			sprintf(p, "\\x%02x", *q++);
			p += 4;
		}
	}
	*p = '\0';
	return buf;
}

-(void)setFileDescriptionForFormat: (CAStreamBasicDescription)format withName:(NSString*)name
{
	char buf[5];
	const char *dataFormat = OSTypeToStr(buf, format.mFormatID);
	NSString* description = [[NSString alloc] initWithFormat:@"(%d ch. %s @ %g Hz)", format.NumberChannels(), dataFormat, format.mSampleRate, nil];
	//fileDescription.text = description;
	[description release];	
}

#pragma mark Playback routines

-(void)stopPlayQueue
{
	//player->StopQueue();
	//[lvlMeter_in setAq: nil];
	//btn_record.enabled = YES;
}

-(void)pausePlayQueue
{
	//player->PauseQueue();
	playbackWasPaused = YES;
}

- (void)stopRecord
{
    [self removeStartRecordingView];
    [self removeFailedRecordingView];
	// Disconnect our level meter from the audio queue
	//[lvlMeter_in setAq: nil];
	
	recorder->StopRecord();
	
	// dispose the previous playback queue
	//player->DisposeQueue(true);
    
	// now create a new queue for the recorded file
    NSString *recordFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"recordedFile.wav"];	
    if (recordCell != nil) {
        recordCell.waveView.wavefilename = recordFile;
        [recordCell.waveView loadwavedata];
        recordCell.timelabel.text = [NSString stringWithFormat:@"Time: %.2f", recordCell.waveView.dwavesecond];

    }
    NSFileManager *mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:recordFile isDirectory:nil]) {
        recordCell.playingButton.enabled = YES;
    } else {
        recordCell.playingButton.enabled = NO;
    }
	//recordFilePath = (CFStringRef)[NSTemporaryDirectory() stringByAppendingPathComponent: @"recordedFile.wav"];
	//player->CreateQueueForFile(recordFilePath);
    
	// Set the button's state back to "record"
	//btn_record.title = @"Record";
	//btn_play.enabled = YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        recorder = nil;
        recordSetting = nil;
        recorderFilePath = nil;
        isStopPlaySrc = NO;
    }
    return self;
}

- (void)dealloc
{
	//delete player;
    //player = nil;
    if (recorder != nil) {
        delete recorder;
    }
    //recorder = nil;

    [self.sentence release];
    [self.sentenceView release];
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
    self.title = STRING_SINGLE_TRAINING;
    [self removeRecordingFile];
    
    NSString* countString = [NSString stringWithFormat:@"%d / %d", (nPos + 1), nTotalCount];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:countString style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    [self loadToolbar];
    self.previousItem.enabled = (nPos != 0);
    self.nextItem.enabled = ((nPos + 1) != nTotalCount);
    // Do any additional setup after loading the view from its nib.
    
    /*self.waveView.starttime = [_sentence startTime] * 1000;
    self.waveView.endtime = [_sentence endTime] *1000;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    wavefile = [[NSString alloc] initWithFormat:@"%@/%@.caf", documentsDirectory, @"2011-08-20 09/31/06 +0000"];  
    self.waveView.wavefilename = wavefile;
    [self.waveView loadwavedata];*/
    self.totalTimelabel.text = [NSString stringWithFormat:@"%.1f", [_sentence endTime] - [_sentence startTime]];
    [self.recordingTableView reloadData];
    [self performSelector:@selector(playingSrcVoice) withObject:nil afterDelay:1.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playingSrcVoice) object:nil];
    if (player != nil) {
        [player stop];
        [player release];
        player = nil;
    }
    if (recorder != nil) {
        if (recorder->IsRunning()) // If we are currently recording, stop and save the file.
        {
            [self stopRecord];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
{
    [self.recordingTableView reloadData];
}

- (void) loadToolbar;
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
	// Flexible Space
	UIBarButtonItem* itemFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	
	// Flexed Space
	UIBarButtonItem* itemFlexedSpaceSmall = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
	itemFlexedSpaceSmall.width = 5;
	
	// Flexed Space
	UIBarButtonItem* itemFlexedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    
    itemFlexedSpace.width = 10.0;
	/*itemFlexedSpace.width = [[UIDevice currentDevice] userInterfaceIdiom] == [UIUserInterfaceIdiomPad]? 35.0 : 20.0;*/
	
    [items addObject:itemFlexedSpace];
    
	// recording button
	//[items addObject:itemFlexibleSpace];
    NSString* recordingString = STRING_START_RECORDING;
	UIBarButtonItem* recordingItemTemp = [[UIBarButtonItem alloc] initWithTitle:recordingString                                                                                  
                                                                 style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(onRecording:)];
	[items addObject:recordingItemTemp];
	self.recordingItem = recordingItemTemp;
	[recordingItemTemp release];
	
    [items addObject:itemFlexibleSpace];
    NSString* last = STRING_PREVIOUS_SENTENCE;
    
	UIBarButtonItem* previousTemp = [[UIBarButtonItem alloc] initWithTitle:last                                                                                  
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(onPrevious:)];
	[items addObject:previousTemp];
	self.previousItem = previousTemp;
	[previousTemp release];
	
    [items addObject:itemFlexedSpace];
    NSString* next = STRING_NEXT_SENTENCE;
	UIBarButtonItem* nextTemp = [[UIBarButtonItem alloc] initWithTitle:next                                                                                  
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(onNext:)];
	[items addObject:nextTemp];
	self.nextItem = nextTemp;
	[nextTemp release];

	// playing
	/*[items addObject:itemFlexedSpace];
    itemImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
	UIBarButtonItem* playingItemTemp = [[UIBarButtonItem alloc] initWithImage:itemImage
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onPlaying:)];
	[items addObject:playingItemTemp];
	self.playingItem = playingItemTemp;
	[playingItemTemp release];
	*/
    
    /*
	// start time
	[items addObject:itemFlexedSpace];
    UILabel* start = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [start setBackgroundColor:[UIColor clearColor]];
    [start setTextColor:[UIColor whiteColor]];
    [start setFont:[UIFont systemFontOfSize:10]];
    UIBarButtonItem* startItemTemp = [[UIBarButtonItem alloc] initWithCustomView:start];
    [items addObject:startItemTemp];
    self.costTimelabel = start;
    self.costTimelabel.text = [NSString stringWithString:@"0.0"];
    [start release];
    [startItemTemp release];
    
    // slider
    UIProgressView* s = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 120, 9)];
    UIBarButtonItem* sliderTemp = [[UIBarButtonItem alloc] initWithCustomView:s];
    [s setProgress:0];
    [items addObject:sliderTemp];
    self.timeProgress = s;
    [s release];
    [sliderTemp release];
    
    // total time
    [items addObject:itemFlexedSpace];
    UILabel* total = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [total setBackgroundColor:[UIColor clearColor]];
    [total setTextColor:[UIColor whiteColor]];
    [total setFont:[UIFont systemFontOfSize:10]];
    UIBarButtonItem* totalItemTemp = [[UIBarButtonItem alloc] initWithCustomView:total];
    [items addObject:totalItemTemp];
    self.totalTimelabel = total;
    self.totalTimelabel.text = [NSString stringWithString:@"0.0"];
    [total release];
    [totalItemTemp release];
   
    
 	[items addObject:itemFlexibleSpace];
	 */
    [items addObject:itemFlexedSpace];
	
	[itemFlexibleSpace release];
	[itemFlexedSpace release];
	[itemFlexedSpaceSmall release];
    VoiceAppDelegate* app = (VoiceAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.toolbar setTintColor:[[UIColor alloc] initWithRed:app.configData.naviRed
                                                 green:app.configData.naviGreen
                                                  blue:app.configData.naviBlue
                                                 alpha:1.0]];

	[self.toolbar setItems:items animated:YES];
	[items release];
}

- (void) stop;
{
    [self removeStartRecordingView];
    NSString* start = STRING_START_RECORDING;
    self.recordingItem.title = start;
    [self stopRecord];
    [self performSelector:@selector(playingRecordingVoice) withObject:nil afterDelay:0.5];

}

- (void) start;
{
    [MobClick event:@"recording_click"];
    [self startRecordingView];
    [self removeRecordingFile];
    [self.recordingTableView reloadData];
    if (recorder == nil) {
        [self initMembers];
    }
    NSString* stop = STRING_STOP_RECORDING;
    self.recordingItem.title = stop;
    if (recorder->IsRunning()) // If we are currently recording, stop and save the file.
    {
        [self stopRecord];
    }
    else // If we're not recording, start.
    {
        // btn_play.enabled = NO;	
        
        // Set the button's state to "stop"
        // btn_record.title = @"Stop";
        
        // Start the recorder
        BOOL bOK = recorder->StartRecord(CFSTR("recordedFile.wav"));
        
        
        [self setFileDescriptionForFormat:recorder->DataFormat() withName:@"Recorded File"];
        if (!bOK) {
            [self addFailedRecordingView];
            NSString* start = STRING_START_RECORDING;
            self.recordingItem.title = start;
            recorder->StopRecord();
            [NSTimer scheduledTimerWithTimeInterval: 3 target: self selector:@selector(removeFailedRecordingView) userInfo: nil repeats: NO];
        }
        // Hook the level meter up to the Audio Queue for the recorder
        //[lvlMeter_in setAq: recorder->Queue()];
    }	
}

- (void) onRecording:(id)sender;
{
    if ([self.recordingItem.title isEqualToString:STRING_START_RECORDING]) {
        [self start];
    } else {
        [self stop];
    }
}

- (void) onPrevious:(id)sender;
{
    if (recorder != nil) {
        if (recorder->IsRunning()) // If we are currently recording, stop and save the file.
        {
            NSString* start = STRING_START_RECORDING;
            self.recordingItem.title = start;
           [self stopRecord];
        }
    }
    [self removeRecordingFile];
    Sentence* s = [recordingdelegate getSentencefromPos:(nPos-1)];
    if (s != nil) {
        if (player != nil) {
            [player stop];
            [player release];
            player = nil;
        }
        self.sentence = s;
        nPos--;
        [self.recordingTableView reloadData];
        NSString* countString = [NSString stringWithFormat:@"%d / %d", (nPos + 1), nTotalCount];
        self.navigationItem.rightBarButtonItem.title = countString;
        [self performSelector:@selector(playingSrcVoice) withObject:nil afterDelay:1.0];
    }
    self.previousItem.enabled = (nPos != 0);
    self.nextItem.enabled = ((nPos + 1) != nTotalCount);
}

- (void) onNext:(id)sender;
{
    if (recorder != nil) {
        if (recorder->IsRunning()) // If we are currently recording, stop and save the file.
        {
            NSString* start = STRING_START_RECORDING;
            self.recordingItem.title = start;
            [self stopRecord];
        }
    }
    [self removeRecordingFile];
     Sentence* s = [recordingdelegate getSentencefromPos:(nPos+1)];
    if (s != nil) {
        if (player != nil) {
            [player stop];
            [player release];
            player = nil;
        }
        self.sentence = s;
        nPos++;
        [self.recordingTableView reloadData];
        NSString* countString = [NSString stringWithFormat:@"%d / %d", (nPos + 1), nTotalCount];
        self.navigationItem.rightBarButtonItem.title = countString;
        [self performSelector:@selector(playingSrcVoice) withObject:nil afterDelay:1.0];
    }
    self.previousItem.enabled = (nPos != 0);
    self.nextItem.enabled = ((nPos + 1) != nTotalCount);
}

- (void)animationProgress
{
    
}

#pragma mark - Record
- (void) updateAudioDisplay 
{  
    
        //START:code.RecordViewController.setlevelmeters  
        
        //[recorder updateMeters];  
        
        //[leftLevelMeter setPower: [recorder averagePowerForChannel:0]  
                           // peak: [recorder peakPowerForChannel: 0]];  

    // [self.waveView setPower:[recorder averagePowerForChannel:0] peak:[recorder peakPowerForChannel: 0]]; 
} 

- (void) playingSrcVoice;
{
    [self playing:PLAY_SRC_VOICE_BUTTON_TAG];
}

#pragma mark - Delegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag  
{  
    NSLog(@"recorder successfully");  
    UIAlertView *recorderSuccessful = [[UIAlertView alloc] initWithTitle:@"" message:@"录音成功"
                                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];  
    [recorderSuccessful show];  
    [recorderSuccessful release];  
}  

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)arecorder error:(NSError *)error  
{  
    // btnRecorder.enabled = NO;  
    UIAlertView *recorderFailed = [[UIAlertView alloc] initWithTitle:@"" message:@"发生错误"
                                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];  
    [recorderFailed show];  
    [recorderFailed release];  
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *CellIdentifier = @"MsgListCell";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        NSString* oritext = self.sentence.orintext;
        if (self.sentence.transtext != nil) {
            if ([self.sentence.transtext length] > 0) {
                oritext = [NSString stringWithFormat:@"%@ \r\n %@", oritext, self.sentence.transtext];
            }
       }
         cell.textLabel.text = oritext;
        cell.textLabel.lineBreakMode   = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines   = 0;
        cell.textLabel.font            = [UIFont systemFontOfSize:FONT_SIZE_BUBBLE];
        /*BubbleCell *cell = (BubbleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[BubbleCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        } else {
            [cell cleanUp];
        }
        cell.imgIcon = [NSString stringWithFormat:@"%@//teachers/t2.png", resourcePath];
        cell.imgName = [NSString stringWithFormat:@"%@/cells/Register_TipBkg.png", resourcePath];
        cell.msgText = self.sentence.orintext;
        cell.transText = self.sentence.transtext;
        cell.nShowTextStyle = YES;*/
        return cell;
    } else {
        if (indexPath.row == 0) {
            
            NSString *CellIdentifier = @"srcVoiceCell";
            
            RecordingWaveCell *cell = (RecordingWaveCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RecordingWaveCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            UIImage* itemImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/WavPlay.png", resourcePath]];

            [cell.playingButton setImage:itemImage forState:UIControlStateNormal];
            cell.playingButton.tag = PLAY_SRC_VOICE_BUTTON_TAG;
            UIImage *iconImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/teachers/male1.png", resourcePath]];
            CGFloat f = 211.0/255.0;
            cell.waveView.layer.borderWidth = 1;
            cell.waveView.layer.borderColor = [[UIColor whiteColor] CGColor];
            cell.backgroundColor = [UIColor colorWithRed:f green:f blue:f alpha:1.0];
            cell.icon.image = iconImage;
            /*cell.waveView.starttime = 0;
            cell.waveView.endtime = 1*1000;
            cell.waveView.wavefilename = [NSString stringWithFormat:@"%@/recordedFile.wav", resourcePath];*/
            
            cell.waveView.starttime = [_sentence startTime] * 1000;
            cell.waveView.endtime = [_sentence endTime] *1000;
            cell.waveView.wavefilename = wavefile;
            //[cell.waveView loadwavedatafromTime];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = (id)self;
            cell.waveView.bReadfromTime = YES;
            [cell.waveView setNeedsLayout];
            cell.timelabel.text = [NSString stringWithFormat:@"Time: %.2f",[_sentence endTime] - [_sentence startTime]];
          return cell;
            

        } else {
            NSString *CellIdentifier = @"recordingVoiceCell";
            
            RecordingWaveCell *cell = (RecordingWaveCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RecordingWaveCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            CGFloat f = 211.0/255.0;
            cell.waveView.layer.borderWidth = 1;
            cell.waveView.layer.borderColor = [[UIColor whiteColor] CGColor];
           cell.backgroundColor = [UIColor colorWithRed:f green:f blue:f alpha:1.0];
           UIImage* itemImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/WavPlay.png", resourcePath]];
            [cell.playingButton setImage:itemImage forState:UIControlStateNormal];
            cell.playingButton.tag = PLAY_USER_VOICE_BUTTON_TAG;
            UIImage *iconImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/recording.png", resourcePath]];
            cell.icon.image = iconImage;
            cell.delegate = (id)self;
            NSFileManager *mgr = [NSFileManager defaultManager];
            NSString *recordFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"recordedFile.wav"];	
            if ([mgr fileExistsAtPath:recordFile isDirectory:nil]) {
                cell.playingButton.enabled = YES;
            } else {
                cell.playingButton.enabled = NO;
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            recordCell = cell;
            cell.waveView.bReadfromTime = NO;
            cell.waveView.wavefilename = recordFile;
           [cell.waveView setNeedsLayout];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *aMsg = self.sentence.orintext;
        NSString *transText = self.sentence.transtext;
        CGFloat divide = 0.9;
        CGFloat width = self.view.bounds.size.width * divide - 2*MAGIN_OF_BUBBLE_TEXT_START;
        CGSize size    = [BubbleCell calcTextHeight:aMsg withWidth:width];
        if (self.sentence.transtext != nil) {
            CGSize szTrans = [BubbleCell calcTextHeight:transText withWidth:width];
            size = CGSizeMake(size.width, size.height + szTrans.height + MAGIN_OF_TEXTANDTRANSLATE);
        }
        size.height += 5;
        
        CGFloat height = (size.height < 44) ? 44 : size.height;
        
        return height;

    } else {
        return 134;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    // create the parent view that will hold header Label
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(2, 0.0, self.view.bounds.size.width, 5.0)] autorelease];
        return customView;

    } else {
        NSString *t = STRING_SRC_TEXT;
        if (section == 1) {
            t = STRING_VOICE_GRAPHIC;
        } 
        UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(2, 0.0, self.view.bounds.size.width, 50.0)] autorelease];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(50, 20.0, self.view.bounds.size.width -100, 30.0)];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = t;
        label.textColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.0 alpha:1.0];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, -1);
        [customView addSubview:label];
        [label release];
        return customView;
    }
 }

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone?  5.0 : 50;
	return height;
}

#pragma RecordingWaveCell
- (void)playing:(NSInteger)buttonTag;
{
    if (buttonTag == PLAY_SRC_VOICE_BUTTON_TAG) {
        // play user recording voice
        if (player != nil) {
            isStopPlaySrc = NO;
            [player stop];
            [player release];
            player = nil;
        }
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: wavefile];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
        player.volume = 5.0;
        [fileURL release];
        player.currentTime = [_sentence startTime];
        [player play];
        isStopPlaySrc = YES;
        NSTimeInterval inter = [_sentence endTime] - [_sentence startTime] + 0.2;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:nPos] forKey:@"pos"];
        [dic setObject:player forKey:@"player"];
        [self performSelector:@selector(stopPlayingSrcVoice:) withObject:dic afterDelay:inter];
        //[NSTimer scheduledTimerWithTimeInterval:inter target:self selector:@selector(stopPlayingSrcVoice:) userInfo:[NSNumber numberWithInt:nPos] repeats:NO];
        
    } else {
        // play recording voice
        if (![self.recordingItem.title isEqualToString:STRING_START_RECORDING]) {
            [self stop];
        }
        [self playingRecordingVoice];
    }
}

- (void)stopPlayingSrcVoice:(NSMutableDictionary*)dic
{
    if (dic == nil) {
        return;
    }
    NSNumber* pos = [dic objectForKey:@"pos"];
    if (pos == nil) {
        [dic release];
        dic = nil;
        return;
    }
    AVAudioPlayer* p = [dic objectForKey:@"player"];
    if (p == nil) {
        [dic release];
        dic = nil;
        return;
    }
    NSInteger poswillstop = [pos intValue];
    if (p == player && poswillstop == nPos) {
        if (player.currentTime >= [_sentence endTime]) {
            isStopPlaySrc = NO;
            [player stop];
        }
    }
    [dic release];
    dic = nil;
}

#pragma mark AudioSession listeners
void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState)
{
    RecordingViewController *THIS = (RecordingViewController*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) {
			[THIS stopRecord];
		}
	}
	/*RecordingViewController *THIS = (RecordingViewController*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) {
			[THIS stopRecord];
		}
		else if (THIS->player->IsRunning()) {
			//the queue will stop itself on an interruption, we just need to update the UI
			[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
			THIS->playbackWasInterrupted = YES;
		}
	}
	else if ((inInterruptionState == kAudioSessionEndInterruption) && THIS->playbackWasInterrupted)
	{
		// we were playing back when we were interrupted, so reset and resume now
		THIS->player->StartQueue(true);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:THIS];
		THIS->playbackWasInterrupted = NO;
	}*/
}

void propListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inDataSize,
                  const void *            inData)
{
	RecordingViewController *THIS = (RecordingViewController*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;			
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{
			// stop the queue if we had a non-policy route change
			if (THIS->recorder->IsRunning()) {
				[THIS stopRecord];
			}
		}	
	}
	else if (inID == kAudioSessionProperty_AudioInputAvailable)
	{
		if (inDataSize == sizeof(UInt32)) {
			//UInt32 isAvailable = *(UInt32*)inData;
			// disable recording if input is not available
			//THIS->btn_record.enabled = (isAvailable > 0) ? YES : NO;
		}
	}
}

#pragma mark Initialization routines
- (void)initMembers
{		
	// Allocate our singleton instance for the recorder & player object
    if (recorder == nil) {
        recorder = new AQRecorder();
    }
	//player = new AQPlayer();
    
	OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
	if (error) printf("ERROR INITIALIZING AUDIO SESSION! %ld\n", error);
	else 
	{
		UInt32 category = kAudioSessionCategory_PlayAndRecord;	
		error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
		if (error) printf("couldn't set audio category!");
        
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
		UInt32 inputAvailable = 0;
		UInt32 size = sizeof(inputAvailable);
		
		// we do not want to allow recording if input is not available
		error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
		if (error) printf("ERROR GETTING INPUT AVAILABILITY! %ld\n", error);
		// btn_record.enabled = (inputAvailable) ? YES : NO;
		
		// we also need to listen to see if input availability changes
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
        
		error = AudioSessionSetActive(true); 
		if (error) printf("AudioSessionSetActive (true) failed");
	}
	
	/*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueStopped:) name:@"playbackQueueStopped" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueResumed:) name:@"playbackQueueResumed" object:nil];
    
	UIColor *bgColor = [[UIColor alloc] initWithRed:.39 green:.44 blue:.57 alpha:.5];
	// [lvlMeter_in setBackgroundColor:bgColor];
	// [lvlMeter_in setBorderColor:bgColor];
	[bgColor release];
	*/
	// disable the play button since we have no recording to play yet
	// btn_play.enabled = NO;
	// playbackWasInterrupted = NO;
	// playbackWasPaused = NO;
}

# pragma mark Notification routines
- (void)playbackQueueStopped:(NSNotification *)note
{
	// btn_play.title = @"Play";
	// [lvlMeter_in setAq: nil];
	// btn_record.enabled = YES;
}

- (void)playbackQueueResumed:(NSNotification *)note
{
	// btn_play.title = @"Stop";
	// btn_record.enabled = NO;
	// [lvlMeter_in setAq: player->Queue()];
}

- (void) playingRecordingVoice;
{
    if (player != nil) {
        [player stop];
        [player release];
        player = nil;
    }
    NSString *recordFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"recordedFile.wav"];	
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: recordFile];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    player.volume = 5.0;
    [fileURL release];
    [player play];
}

- (void)removeRecordingFile;
{
    NSString *recordFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"recordedFile.wav"];	
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:recordFile]) {
        [mgr removeItemAtPath:recordFile error:nil];
    }
}

- (void)addFailedRecordingView;
{
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    loadingView.layer.cornerRadius = 8;
    loadingView.tag = FAILEDRECORDINGVIEW_TAG;
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    UILabel* loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingView.frame.size.width, 20)];
    loadingText.textColor = [UIColor whiteColor];
    loadingText.text = STRING_RECORDING_ERROR;
    loadingText.font = [UIFont systemFontOfSize:14];
    loadingText.backgroundColor = [UIColor clearColor];
    loadingText.textAlignment  = UITextAlignmentCenter;
    loadingText.center = loadingView.center;
    [loadingView addSubview:loadingText];
    [loadingText release];
    loadingView.center = self.view.center;
    [self.view addSubview:loadingView];
    [loadingView release];

}
- (void)removeFailedRecordingView;
{
    UIView* loadingView = [self.view viewWithTag:FAILEDRECORDINGVIEW_TAG];
    if (loadingView != nil) {
        [loadingView removeFromSuperview];
    }

}

- (void)startRecordingView;
{
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    loadingView.layer.cornerRadius = 8;
    loadingView.tag = (FAILEDRECORDINGVIEW_TAG+1);
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    UILabel* loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingView.frame.size.width, 20)];
    loadingText.textColor = [UIColor whiteColor];
    loadingText.text = STRING_RECORDING_TEXT;
    loadingText.font = [UIFont systemFontOfSize:14];
    loadingText.backgroundColor = [UIColor clearColor];
    loadingText.textAlignment  = UITextAlignmentCenter;
    loadingText.center = loadingView.center;
    [loadingView addSubview:loadingText];
    [loadingText release];
    loadingView.center = self.view.center;
    [self.view addSubview:loadingView];
    [loadingView release];

}

- (void)removeStartRecordingView;
{
    UIView* loadingView = [self.view viewWithTag:(FAILEDRECORDINGVIEW_TAG+1)];
    if (loadingView != nil) {
        [loadingView removeFromSuperview];
    }
    

}
@end
