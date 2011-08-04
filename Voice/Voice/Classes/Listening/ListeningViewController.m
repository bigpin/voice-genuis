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

@implementation ListeningViewController
@synthesize sentencesArray = _sentencesArray;
@synthesize teachersArray = _teachersArray;
@synthesize sentencesTableView = _sentencesTableView;
@synthesize listeningToolbar = _listeningToolbar;
@synthesize progressBar;
@synthesize timepreces;
@synthesize timelast;
@synthesize updataeTimer;
@synthesize wavefile;
@synthesize player;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;

        bStart = NO;
        looptype = PLAY_LOOPTYPE_LESSON;
        progressBar.minimumValue = 0.0;
        progressBar.maximumValue = 10.0;
        
        updateTimer = nil;
        timeStart = 0.0;
        nPosition = 0;
    }
    return self;
}

- (void)dealloc
{
    [self.listeningToolbar release];
    [self.sentencesArray release];
    [self.teachersArray release];
    [progressBar release];
    [updateTimer release];
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
    [self.listeningToolbar loadItems:self];
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    
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
    [timepreces setText:[NSString stringWithFormat:@"%.1f", self.player.currentTime]];
    [timelast setText:[NSString stringWithFormat:@"%.1f", self.player.duration ]];
    loopstarttime = 0.0;
    loopendtime = self.player.duration;
    fVolumn = 0.8;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    bStart = NO;
    timeStart = 0.0;
    [self updateViewForPlayer];

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

    [self.sentencesTableView reloadData];
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
        cell.backgroundView = nil;
 		while ([[cell.contentView subviews] count] > 0) {
			UIView *sub = [[cell.contentView subviews] objectAtIndex:0];
			if (sub != nil) {
				[sub removeFromSuperview];
			}
			
		}
       
    }
    
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    NSString* iconPath = resourcePath;
    Sentence * sentence = [self.sentencesArray objectAtIndex:indexPath.section];
    if ([self.teachersArray count] > 0) {
        Teacher* teacher = [self.teachersArray objectAtIndex:0];
        if ([teacher.teacherid isEqualToString:sentence.techerid]) {
            resourcePath = [NSString stringWithFormat:@"%@/purple.png", resourcePath];
            iconPath = [NSString stringWithFormat:@"%@/t1.png", iconPath];
        } else {
            resourcePath = [NSString stringWithFormat:@"%@/aqua.png", resourcePath];
            iconPath = [NSString stringWithFormat:@"%@/t2.png", iconPath];
        }
    } else {
        if (indexPath.section % 2 == 0) {
            resourcePath = [NSString stringWithFormat:@"%@/purple.png", resourcePath];
            iconPath = [NSString stringWithFormat:@"%@/t1.png", iconPath];
        } else {
            resourcePath = [NSString stringWithFormat:@"%@/aqua.png", resourcePath];
            iconPath = [NSString stringWithFormat:@"%@/t2.png", iconPath];
        }
        
    }
     cell.imgName = resourcePath;
    cell.imgIcon = iconPath;
     cell.msgText = sentence.orintext;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Sentence * sentence = [self.sentencesArray objectAtIndex:indexPath.section];
   	NSString *aMsg = sentence.orintext;
    CGFloat divide = 0.9;
    CGFloat width = self.view.bounds.size.width * divide - 44;
	CGSize size    = [BubbleCell calcTextHeight:aMsg withWidth:width];
    
	size.height += 5;
	
	CGFloat height = (size.height < 44) ? 44 : size.height;
	
	return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    // create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, self.view.bounds.size.width, 20.0)] autorelease];
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20.0;
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
            NSLog(@"%d", i);
            return i;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Sentence* sentence = [_sentencesArray objectAtIndex:indexPath.row];
    switch (looptype) {
        case PLAY_LOOPTYPE_LESSON:
//            loopstarttime = [sentence startTime];
//            loopendtime = self.player.duration;
            break;
            
        case PLAY_LOOPTYPE_SENTENCE:
            loopstarttime = [sentence startTime];
            loopendtime = [sentence endTime];
            break;
            
        default:
            break;
    }
    player.currentTime = [sentence startTime];
    bStart = YES;
    [self updateViewForPlayer];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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
        NSLog(@"%d, %f", index - 1, player.currentTime);
    }
}

- (IBAction)onStart:(id)sender;
{
    bStart = !bStart;
    
    [self updateViewForPlayer];
}

- (IBAction)onNext:(id)sender;
{
    int index = [self getSentenceIndex:self.player.currentTime];
    if (index < [_sentencesArray count] - 1) {
        Sentence* sentence = [_sentencesArray objectAtIndex:index + 1];
        player.currentTime = [sentence startTime];
        NSLog(@"%d,%f", index + 1, player.currentTime);
    }
}

- (IBAction)onLoopLesson:(id)sender;
{
    //    self.loopLesson.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/looplesson.png", resourcePath]];

    looptype = PLAY_LOOPTYPE_LESSON;
    loopstarttime = 0.0;
    loopendtime = self.player.duration;
}

- (IBAction)onLoopSentence:(id)sender;
{
    looptype = PLAY_LOOPTYPE_SENTENCE;
    int index = [self getSentenceIndex:self.player.currentTime];
    if (index < [_sentencesArray count]) {
        Sentence* sentence = [_sentencesArray objectAtIndex:index];
        loopstarttime = [sentence startTime];
        loopendtime = [sentence endTime];
    }
}

#pragma mark - Update timer

- (void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
//    NSLog(@"%f, volume:%f", p.currentTime, volumBar.value);
// 	currentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
    p.volume = fVolumn;
	progressBar.value = p.currentTime;
//   NSLog(@"%f, %f === %f",p.currentTime, loopstarttime, loopendtime);
    if (p.currentTime > loopendtime + 0.1 || p.currentTime < loopstarttime - 0.1) {
        p.currentTime = loopstarttime;
    }
    [timepreces setText:[NSString stringWithFormat:@"%.1f", self.player.currentTime]];
    [timelast setText:[NSString stringWithFormat:@"%.1f", self.player.duration]];
}

- (void)updateCurrentTime
{
	[self updateCurrentTimeForPlayer:self.player];
    int nCurrentIndex = [self getSentenceIndex:self.player.currentTime];
    if (nCurrentIndex != nPosition) {
        [_sentencesTableView scrollToRowAtIndexPath:[NSIndexPath  indexPathForRow:0  inSection:nCurrentIndex]
                                   atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        nPosition = nCurrentIndex;
    }
}

- (void)updateViewForPlayer
{
    switch (looptype) {
        case PLAY_LOOPTYPE_LESSON:
            self.player.numberOfLoops = -1;    // Loop playback until invoke stop method
            break;
        case PLAY_LOOPTYPE_SENTENCE:
            self.player.numberOfLoops = -1;
            break;
            
        default:
            break;
    }
    
	[self updateCurrentTimeForPlayer:self.player];
    
	if (updateTimer) 
		[updateTimer invalidate];
    
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    if (!bStart) {
        self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
        updateTimer = nil;
    } else {
        self.listeningToolbar.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/pause.png", resourcePath]];
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:player repeats:YES];
    }
    if (bStart) {
        if (![self.player isPlaying]) {
            [self.player play];
        }
    }
    else {
        [self.player pause];
    }
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

@end
