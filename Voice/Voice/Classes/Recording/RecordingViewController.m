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
    self.sentenceView.layer.cornerRadius = 10;
    self.sentenceView.text = self.sentence.orintext;
    
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
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
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
    
}

- (void) onPlaying:(id)sender;
{
    
}

#pragma mark - Record

- (void) prepareToRecord  
{  
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];  
    NSError *err = nil;  
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];  
    
    if(err){ 
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);  
        return;  
    }  
    
    [audioSession setActive:YES error:&err]; 
    err = nil;  
    if(err){  
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);  
        return;  
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
    recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", NSHomeDirectory(), caldate] retain];  
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
        return;  
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
        return;  
    }  
} 


- (void)startrecorder  
{  
    [recorder record];  
}

- (void) stopRecording
{  
    [recorder stop];  
} 

- (void) updateAudioDisplay 
{  
    
        //START:code.RecordViewController.setlevelmeters  
        
        [recorder updateMeters];  
        
//        [leftLevelMeter setPower: [recorder averagePowerForChannel:0]  
//                            peak: [recorder peakPowerForChannel: 0]];  

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

@end
