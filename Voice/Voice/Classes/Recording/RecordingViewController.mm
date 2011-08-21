//
//  RecordingViewController.m
//  Voice
//
//  Created by JiaLi on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RecordingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VoicePlayer.h"
#import "BubbleCell.h"

@implementation RecordingViewController
@synthesize recordingdelegate;
@synthesize sentence = _sentence;
@synthesize sentenceView = _sentenceView;
@synthesize wavefile;
@synthesize waveView = _waveView;
@synthesize toolbar = _toolbar;
@synthesize recordingItem = _recordingItem;
@synthesize playingItem = _playingItem;
@synthesize costTimelabel = _costTimelabel;
@synthesize totalTimelabel = _totalTimelabel;
@synthesize timeSlider = _timeSlider;
@synthesize recordingTableView = _recordingTableView;
@synthesize resourcePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        recorder = nil;
        recordSetting = nil;
        recorderFilePath = nil;
    }
    return self;
}

- (void)dealloc
{
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
    [self loadToolbar];
    // Do any additional setup after loading the view from its nib.
    
    /*self.waveView.starttime = [_sentence startTime] * 1000;
    self.waveView.endtime = [_sentence endTime] *1000;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    wavefile = [[NSString alloc] initWithFormat:@"%@/%@.caf", documentsDirectory, @"2011-08-20 09/31/06 +0000"];  
    self.waveView.wavefilename = wavefile;
    [self.waveView loadwavedata];*/
  
    [self.recordingTableView reloadData];
//    VoicePlayer* player = [[VoicePlayer alloc] init];
//    [player play:(CFURLRef)[NSURL fileURLWithPath:self.wavefile]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	
    [items addObject:itemFlexedSpaceSmall];
    
	// recording button
	[items addObject:itemFlexibleSpace];
    UIImage* itemImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/record.png", resourcePath]];
	UIBarButtonItem* recordingItemTemp = [[UIBarButtonItem alloc] initWithImage:itemImage
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(onRecording:)];
	[items addObject:recordingItemTemp];
	self.recordingItem = recordingItemTemp;
	[recordingItemTemp release];
	
	
	// playing
	[items addObject:itemFlexedSpace];
    itemImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
	UIBarButtonItem* playingItemTemp = [[UIBarButtonItem alloc] initWithImage:itemImage
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onPlaying:)];
	[items addObject:playingItemTemp];
	self.playingItem = playingItemTemp;
	[playingItemTemp release];
	
    
	// start time
	//[items addObject:itemFlexedSpace];
    UILabel* start = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [start setBackgroundColor:[UIColor clearColor]];
    [start setTextColor:[UIColor whiteColor]];
    [start setFont:[UIFont systemFontOfSize:10]];
    UIBarButtonItem* startItemTemp = [[UIBarButtonItem alloc] initWithCustomView:start];
    [items addObject:startItemTemp];
    self.costTimelabel = start;
    self.costTimelabel.text = [NSString stringWithString:@"00.00.00"];
    [start release];
    [startItemTemp release];
    
    // slider
 	//[items addObject:itemFlexedSpace];
    UISlider* s = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    UIBarButtonItem* sliderTemp = [[UIBarButtonItem alloc] initWithCustomView:s];
    [s setMinimumValue:0];
    [s setMaximumValue:1];
    s.value = 0.0;
    [items addObject:sliderTemp];
    self.timeSlider = s;
    
    UIImage* imageThumb = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/slider-handle.png", resourcePath]];
    
    [self.timeSlider setThumbImage:imageThumb forState:UIControlStateNormal];
    
    UIImage* imageTrack = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/slider-track-right.png", resourcePath]];
    [self.timeSlider setMaximumTrackImage:imageTrack forState:UIControlStateNormal];
    [self.timeSlider setMinimumTrackImage:imageTrack forState:UIControlStateNormal];

    [s release];
    [sliderTemp release];
    
    // total time
    //[items addObject:itemFlexedSpace];
    UILabel* total = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [total setBackgroundColor:[UIColor clearColor]];
    [total setTextColor:[UIColor whiteColor]];
    [total setFont:[UIFont systemFontOfSize:10]];
    UIBarButtonItem* totalItemTemp = [[UIBarButtonItem alloc] initWithCustomView:total];
    [items addObject:totalItemTemp];
    self.totalTimelabel = total;
    self.totalTimelabel.text = [NSString stringWithString:@"00.00.00"];
    [total release];
    [totalItemTemp release];

 	[items addObject:itemFlexibleSpace];
	
    [items addObject:itemFlexedSpaceSmall];
	
	[itemFlexibleSpace release];
	[itemFlexedSpace release];
	[itemFlexedSpaceSmall release];
	[self.toolbar setItems:items animated:YES];
	[items release];
}


- (void) onRecording:(id)sender;
{
    if ([self prepareToRecord]) {
        [self startrecorder];
    }
}

- (void) onPlaying:(id)sender;
{
    
}

#pragma mark - Record

- (BOOL) prepareToRecord  
{  
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];  
    NSError *err = nil;  
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];  
    
    if(err){ 
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);  
        return NO;  
    }  
    
    [audioSession setActive:YES error:&err]; 
    err = nil;  
    if(err){  
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);  
        return NO;  
    }  
    
    recordSetting = [[NSMutableDictionary alloc] init];  
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];  
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];   
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];  
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];  
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];  
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];  
    
    // Create a new dated file  
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];  
    NSString *caldate = [now description];  
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", documentsDirectory, caldate] retain];  
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];  
    err = nil;  
    recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];  
    if(!recorder){  
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);  
        UIAlertView *alert =  
        [[UIAlertView alloc] initWithTitle: @"Warning"  
                                   message: [err localizedDescription]  
                                  delegate: nil  
                         cancelButtonTitle: @"OK"  
                         otherButtonTitles: nil];  
        [alert show];  
        [alert release];  
        return NO;  
    }  
    //prepare to record  
    [recorder setDelegate:(id)self];  
    [recorder prepareToRecord];  
    recorder.meteringEnabled = YES;  
    BOOL audioHWAvailable = audioSession.inputIsAvailable;  
    if (! audioHWAvailable) {  
        UIAlertView *cantRecordAlert =  
        [[UIAlertView alloc] initWithTitle: @"Warning"  
                                   message: @"Audio input hardware not available"  
                                  delegate: nil  
                         cancelButtonTitle: @"OK"  
                         otherButtonTitles: nil];  
        [cantRecordAlert show];  
        [cantRecordAlert release];   
        return NO;  
    }  
    return YES;
} 


- (void)startrecorder  
{  
    [recorder record];  
    /*[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAudioDisplay) userInfo:nil repeats:YES];*/
}

- (void) stopRecording
{  
    [recorder stop];  
} 

- (void) updateAudioDisplay 
{  
    
        //START:code.RecordViewController.setlevelmeters  
        
        [recorder updateMeters];  
        
        //[leftLevelMeter setPower: [recorder averagePowerForChannel:0]  
                           // peak: [recorder peakPowerForChannel: 0]];  

    // [self.waveView setPower:[recorder averagePowerForChannel:0] peak:[recorder peakPowerForChannel: 0]]; 
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


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
{
    
    [self.recordingTableView reloadData];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *CellIdentifier = @"MsgListCell";
        
        BubbleCell *cell = (BubbleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[BubbleCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        } else {
            [cell cleanUp];
        }
        cell.imgName = [NSString stringWithFormat:@"%@/bubble2.png", resourcePath];
        cell.msgText = self.sentence.orintext;
        cell.transText = self.sentence.transtext;
        cell.nShowTextStyle = YES;
        return cell;
    } else {
        NSString *CellIdentifier = @"cell";
        
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        } else {
            UIView* v = [cell.contentView viewWithTag:100];
            if (v != nil) {
                [v removeFromSuperview];
            }
        }
        WaveView *waveview = [[WaveView alloc] initWithFrame:CGRectMake(10, 10, cell.frame.size.width - 40, 160)];
        [cell.contentView addSubview:waveview];
        waveview.tag = 100;
        self.waveView = waveview;
        self.waveView.starttime = [_sentence startTime] * 1000;
        self.waveView.endtime = [_sentence endTime] *1000;
        self.waveView.wavefilename = wavefile;
        [self.waveView loadwavedata];
        [waveview release];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

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
        return 200;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    // create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(2, 0.0, self.view.bounds.size.width, 5.0)] autorelease];
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 5.0;
}
@end
