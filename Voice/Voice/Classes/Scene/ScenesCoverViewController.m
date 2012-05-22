//
//  ScenesCoverViewController.m
//  Voice
//
//  Created by JiaLi on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ScenesCoverViewController.h"
#import "LessonsViewController.h"

@implementation ScenesCoverViewController
@synthesize scenesArray = _scenesArray;
@synthesize scenesLabel = _scenesLabel;
@synthesize covers;
@synthesize coverflow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.scenesLabel release];
    [coverflow release];
	[covers release];
    [self.scenesArray release];
    [_daybayday release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) loadView{
	[super loadView];
    bAnimation = NO;
    [self loadScenes];
	self.view.backgroundColor = [UIColor whiteColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	
	CGRect r = self.view.bounds;
	r.size.height = 1000;
	
	coverflow = [[TKCoverflowView alloc] initWithFrame:self.view.bounds];
	coverflow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	coverflow.coverflowDelegate = self;
	coverflow.dataSource = self;
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
		coverflow.coverSpacing = 200;
		coverflow.coverSize = CGSizeMake(512, 512);
	}
	
	[self.view addSubview:coverflow];
	
    // label
	/*UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navigationController.view.bounds.size.height - 50, self.view.bounds.size.width, 60)];

    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [self.navigationController.view addSubview:label];
    [self.navigationController.view bringSubviewToFront:label];
    self.scenesLabel = label;
    [label release];*/
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad {
    [super viewDidLoad];
    NSString* backString = STRING_BACK;
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle:backString style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* imagepath = nil;
    NSString* stringResource = @"Image/coverflow";
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
        
        imagepath = [NSString stringWithFormat:@"%@/%@", resourcePath, @"cover_iphone.png"];
	}else{
        resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
        imagepath = [NSString stringWithFormat:@"%@/%@", resourcePath, @"cover_iPad.png"];
	}
    UIImage* coverImage = [UIImage imageWithContentsOfFile:imagepath];
    if (coverImage != nil) {
        covers = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [self.scenesArray count]; i++) {
            [covers addObject:coverImage]; 
        }
    }
 	[coverflow setNumberOfCovers:[self.scenesArray count]];
    if (_daybayday == nil) {
        _daybayday = [[DayByDayObject alloc] init];
        _daybayday.navigationController = self.navigationController;
        [_daybayday performSelector:@selector(loadDaybyDayView) withObject:nil afterDelay:0.2];
    }
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    //self.scenesLabel.hidden = NO;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque]; 
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    // no loop
	//[coverflow bringCoverAtIndexToFront:[covers count]*2 animated:NO];
}
- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
    //self.scenesLabel.hidden = YES;

	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)openScenes:(TKCoverflowView*)coverflowView coverAtIndex:(int)index;
{
    TKCoverflowCoverView *cover = [coverflowView coverAtIndex:index];
	if(cover == nil) return;
    
    if (bAnimation) {
        return;
    }
    
    bAnimation = YES;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(finishedTapped:finished:context:)];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cover cache:YES];
	[UIView commitAnimations];
	nCoverIndex = index;
	//NSLog(@"Index: %d",index);

}

- (void) info{
	
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
		[self dismissModalViewControllerAnimated:YES];
	else{
		
		CGRect rect = self.view.bounds;
        
		
		if(!collapsed)
			rect = CGRectInset(rect, 100, 100);
		self.coverflow.frame = rect;
		
		collapsed = !collapsed;
        
	}
}

- (void) changeNumberOfCovers{
	NSInteger index = coverflow.currentIndex;
	NSInteger no = [self.scenesArray count];//arc4random() % 200;
	NSInteger newIndex = MAX(0,MIN(index,no-1));
	//NSLog(@"Covers Count: %d index: %d",no,newIndex);
	[coverflow setNumberOfCovers:no];
	coverflow.currentIndex = newIndex;
}

- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(int)index{
    NSInteger nCount = [self.scenesArray count];
    NSInteger nMod = index % nCount;
    if (nMod < nCount) {
       // NSLog(@"%@", [self.scenesArray objectAtIndex:nMod]);
        //self.scenesLabel.text = [self.scenesArray objectAtIndex:nMod];
        self.navigationItem.title = [self.scenesArray objectAtIndex:nMod];
    }
	//NSLog(@"Front %d",index);
}

- (TKCoverflowCoverView*) coverflowView:(TKCoverflowView*)coverflowView coverAtIndex:(int)index{
	
	TKCoverflowCoverView *cover = [coverflowView dequeueReusableCoverView];
	
	if(cover == nil){
		BOOL phone = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
		CGRect rect = phone ? CGRectMake(0, 0, 224, 300) : CGRectMake(0, 0, 512, 1024);
		cover = [[[TKCoverflowCoverView alloc] initWithFrame:rect] autorelease]; // 224
		cover.baseline = 224;
		
	}
	cover.image = [covers objectAtIndex:index%[covers count]];
    NSInteger nCount = [self.scenesArray count];
    NSInteger nMod = index % nCount;
    if (nMod < nCount) {
        cover.coverLabel.text = [self.scenesArray objectAtIndex:nMod];
    }
	return cover;
}

- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasDoubleTapped:(int)index{
    [self openScenes:(TKCoverflowView*)coverflowView coverAtIndex:(int)index];
}

- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasSingleTapped:(int)index{
    [self openScenes:(TKCoverflowView*)coverflowView coverAtIndex:(int)index];
}

- (void)finishedTapped:(NSString*)animationID finished:(BOOL)finished context:(void *)context {
    NSInteger nCount = [self.scenesArray count];
    NSInteger nMod = nCoverIndex % nCount;
    if (nMod < nCount) {
        LessonsViewController* lesson = [[LessonsViewController alloc] initWithNibName:@"LessonsViewController" bundle:nil];
        NSString* scenes = [[NSString alloc] initWithString:[self.scenesArray objectAtIndex:nMod]];
        lesson.scenesName = scenes;
        lesson.navigationItem.title = scenes;
        [scenes release];
        [self.navigationController pushViewController:lesson animated:YES];
        [lesson release];
    }
    bAnimation = NO;
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

- (void)loadScenes;
{
    if (self.scenesArray == nil) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString* stringResource = STRING_RESOURCE_DATA;
        resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
        
        NSFileManager* manager = [[NSFileManager alloc] init];
        NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:resourcePath];
        
        NSString* file = [dirEnum nextObject];
        while (file) {
            NSRange range = [file rangeOfString:@"/" options:NSBackwardsSearch];
            if (range.location != NSNotFound) {
                file = [dirEnum nextObject];
                continue;
            }
            
            if ([[file pathExtension] length] == 0) {
                [array addObject:file];
            }
            file = [dirEnum nextObject];
        }
        self.scenesArray = array;
        [array release];
        [manager release];
    }
}

@end
