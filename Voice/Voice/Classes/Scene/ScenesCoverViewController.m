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
    [coverflow release];
	[covers release];
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
		coverflow.coverSize = CGSizeMake(300, 300);
	}
	
	[self.view addSubview:coverflow];
	
	
	/*if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		btn.frame = CGRectMake(0,0,100,20);
		[btn setTitle:@"# Covers" forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(changeNumberOfCovers) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn];
	}else{
		
		UIBarButtonItem *nocoversitem = [[UIBarButtonItem alloc] initWithTitle:@"# Covers" 
                                                                         style:UIBarButtonItemStyleBordered 
                                                                        target:self action:@selector(changeNumberOfCovers)];
		
		UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
		self.toolbarItems = [NSArray arrayWithObjects:flex,nocoversitem,nil];
		[nocoversitem release];
		[flex release];
	}
    
	*/
    
	/*CGSize s = self.view.bounds.size;
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(info) forControlEvents:UIControlEventTouchUpInside];
	infoButton.frame = CGRectMake(s.width-50, 5, 50, 30);
	[self.view addSubview:infoButton];
    */
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad {
    [super viewDidLoad];
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];

	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        NSString* stringResource = @"Image/coverflow_iphone";
        resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
        NSString* imagepath1 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"cover_4.jpg"];
        NSString* imagepath2 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"cover_4.jpg"];
        NSString* imagepath3 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"cover_4.jpg"];
        NSString* imagepath4 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"cover_4.jpg"];
        NSString* imagepath5 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"cover_4.jpg"];
		covers = [[NSArray alloc] initWithObjects:
				  [UIImage imageWithContentsOfFile:imagepath1],[UIImage imageWithContentsOfFile:imagepath2],
				  [UIImage imageWithContentsOfFile:imagepath3],[UIImage imageWithContentsOfFile:imagepath4],
				  [UIImage imageWithContentsOfFile:imagepath5],nil];
	}else{
        NSString* stringResource = @"Image/coverflow_ipad";
        resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
        NSString* imagepath1 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"ipadcover_1.jpg"];
        NSString* imagepath2 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"ipadcover_1.jpg"];
        NSString* imagepath3 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"ipadcover_1.jpg"];
        NSString* imagepath4 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"ipadcover_1.jpg"];
        NSString* imagepath5 = [NSString stringWithFormat:@"%@/%@", resourcePath, @"ipadcover_1.jpg"];
		covers = [[NSArray alloc] initWithObjects:
				  [UIImage imageWithContentsOfFile:imagepath1],[UIImage imageWithContentsOfFile:imagepath2],
				  [UIImage imageWithContentsOfFile:imagepath3],[UIImage imageWithContentsOfFile:imagepath4],
				  [UIImage imageWithContentsOfFile:imagepath5],nil];
	}
	[coverflow setNumberOfCovers:[self.scenesArray count]];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque]; 
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    // no loop
	//[coverflow bringCoverAtIndexToFront:[covers count]*2 animated:NO];
}
- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
	NSLog(@"Front %d",index);
}

- (TKCoverflowCoverView*) coverflowView:(TKCoverflowView*)coverflowView coverAtIndex:(int)index{
	
	TKCoverflowCoverView *cover = [coverflowView dequeueReusableCoverView];
	
	if(cover == nil){
		BOOL phone = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
		CGRect rect = phone ? CGRectMake(0, 0, 224, 300) : CGRectMake(0, 0, 300, 600);
		cover = [[[TKCoverflowCoverView alloc] initWithFrame:rect] autorelease]; // 224
		cover.baseline = 224;
		
	}
	cover.image = [covers objectAtIndex:index%[covers count]];
	return cover;
}

- (void) coverflowView:(TKCoverflowView*)coverflowView coverAtIndexWasDoubleTapped:(int)index{
	TKCoverflowCoverView *cover = [coverflowView coverAtIndex:index];
	if(cover == nil) return;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(finishedDoubleTapped:finished:context:)];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cover cache:YES];
	[UIView commitAnimations];
	nCoverIndex = index;
	NSLog(@"Index: %d",index);
}

- (void)finishedDoubleTapped:(NSString*)animationID finished:(BOOL)finished context:(void *)context {
    NSInteger nCount = [self.scenesArray count];
    NSInteger nMod = nCoverIndex % nCount;
    if (nMod < nCount) {
        LessonsViewController* lesson = [[LessonsViewController alloc] initWithNibName:@"LessonsViewController" bundle:nil];
        NSString* scenes = [[NSString alloc] initWithString:[self.scenesArray objectAtIndex:nMod]];
        lesson.scenesName = scenes;
        lesson.title = scenes;
        [scenes release];
        [self.navigationController pushViewController:lesson animated:YES];
        [lesson release];
    }
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
