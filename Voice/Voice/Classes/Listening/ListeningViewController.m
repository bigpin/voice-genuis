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
#import "UACellBackgroundView.h"

@implementation ListeningViewController
@synthesize sentencesArray = _sentencesArray;
@synthesize sentencesTableView = _sentencesTableView;
@synthesize previousItem;
@synthesize nextItem;
@synthesize playItem;
@synthesize loopLesson;
@synthesize loopSingle;
@synthesize progressBar;
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
        [progressBar setValue:0.0];
        updateTimer = nil;
        nPlayingIndex = 0;
    }
    return self;
}

- (void)dealloc
{
    [self.sentencesArray release];
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
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    self.previousItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/previous.png", resourcePath]];
    self.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
    self.nextItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/next.png", resourcePath]];
    self.loopSingle.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/loopsingle.png", resourcePath]];
    self.loopLesson.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/looplesson.png", resourcePath]];

   // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.sentencesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.backgroundColor = nil;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    UACellBackgroundView* backgroundCell = [[UACellBackgroundView alloc] initWithFrame:CGRectZero];
    if (indexPath.row == 0) {
        backgroundCell.position = UACellBackgroundViewPositionTop;
    } else if (indexPath.row == ([self.sentencesArray count] - 1)) {
        backgroundCell.position = UACellBackgroundViewPositionBottom;
    } else {
        backgroundCell.position = UACellBackgroundViewPositionMiddle;
    }
    if (indexPath.row % 2 == 0) {
        backgroundCell.toRed = 111.0/255.0;
        backgroundCell.toGreen = 171.0/255.0;
        backgroundCell.toBlue = 205.0/255.0;
    } else {
        backgroundCell.toRed = 249.0/255.0;
        backgroundCell.toGreen = 209.0/255.0;
        backgroundCell.toBlue = 124.0/255.0;
    }
     cell.backgroundView = backgroundCell;
    [backgroundCell release];
   
    // Configure the cell...
    Sentence * sentence = [self.sentencesArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.35];
    cell.textLabel.shadowOffset = CGSizeMake(0, -1.0); 
    cell.textLabel.text = sentence.orintext;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
	cell.accessoryType = UITableViewCellAccessoryNone;
    cell.detailTextLabel.text = sentence.ps;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView: tableView cellForRowAtIndexPath: indexPath];
    
    CGSize constraint = CGSizeMake(cell.frame.size.width - CELL_CONTENT_MARGIN*2, 20000.0f);
    
    CGSize size = [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

    if (size.height < 44.0) {
        CGFloat height = MAX(size.height, 44.0f);
        return (height + + CELL_CONTENT_MARGIN*2);
    } else {
        CGFloat height = MAX(size.height, 44.0f);
        return (height + CELL_CONTENT_MARGIN*2 + 20);
    
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (IBAction)onPrevious:(id)sender;
{
    
}

- (IBAction)onStart:(id)sender;
{
    bStart = !bStart;
    
    // play and stop
    if (bStart) {
        if (!player) {
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: wavefile];
            AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
            [fileURL release];
            
            self.player = newPlayer;
            [newPlayer release];
        }
        [player prepareToPlay];
        [player setDelegate:(id<AVAudioPlayerDelegate>)self];
        switch (looptype) {
            case PLAY_LOOPTYPE_LESSON:
                self.player.numberOfLoops = -1;    // Loop playback until invoke stop method
                break;
            case PLAY_LOOPTYPE_SENTENCE:
                self.player.numberOfLoops = 1;
                break;
                
            default:
                break;
        }
        progressBar.maximumValue = player.duration;
//        NSTimeInterval time;
//        [self.player playAtTime:time];
        [self.player play];
    }
    else {
        [self.player pause];
    }
    
    [self updateViewForPlayer];
}

- (IBAction)onNext:(id)sender;
{
    
}

- (IBAction)onLoopLesson:(id)sender;
{
    looptype = PLAY_LOOPTYPE_LESSON;
}

- (IBAction)onLoopSentence:(id)sender;
{
    looptype = PLAY_LOOPTYPE_SENTENCE;
}

#pragma mark - Update timer

- (void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
    NSLog(@"%f", p.currentTime);
// 	currentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
	progressBar.value = p.currentTime;
}

- (void)updateCurrentTime
{
	[self updateCurrentTimeForPlayer:self.player];
}

- (void)updateViewForPlayer
{
	[self updateCurrentTimeForPlayer:self.player];
    
	if (updateTimer) 
		[updateTimer invalidate];
    
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    if (!bStart) {
        self.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
        updateTimer = nil;
    } else {
        self.playItem.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/pause.png", resourcePath]];
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:player repeats:YES];
    }
}

@end
