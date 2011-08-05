//
//  ListeningToolbar.m
//  Voice
//
//  Created by JiaLi on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ListeningToolbar.h"


@implementation ListeningToolbar

@synthesize volumItem = _volumItem;
@synthesize previousItem = _previousItem;
@synthesize nextItem = _nextItem;
@synthesize playItem = _playItem;
@synthesize loopItem = _loopItem;

- (void)loadItems:(id)delegate;
{
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stringResource = @"Image";
    resourcePath = [NSString stringWithFormat:@"%@/%@", resourcePath, stringResource];
    NSMutableArray *items = [[NSMutableArray alloc] init];
	// Flexible Space
	UIBarButtonItem* itemFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	
	// Flexed Space
	UIBarButtonItem* itemFlexedSpaceSmall = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
	itemFlexedSpaceSmall.width = 10;
	
	// Flexed Space
	UIBarButtonItem* itemFlexedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    
    itemFlexedSpace.width = 20.0;
	/*itemFlexedSpace.width = [[UIDevice currentDevice] userInterfaceIdiom] == [UIUserInterfaceIdiomPad]? 35.0 : 20.0;*/
	
    [items addObject:itemFlexedSpaceSmall];

	// Other button
	[items addObject:itemFlexibleSpace];
    UIImage* otherImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/icon_volume.png", resourcePath]];
	UIBarButtonItem* itemOther = [[UIBarButtonItem alloc] initWithImage:otherImage
																	 style:UIBarButtonItemStylePlain
																	target:delegate
																	action:@selector(onOther:)];
	[items addObject:itemOther];
	self.volumItem = itemOther;
	[itemOther release];
	
	
	// Previous
	[items addObject:itemFlexedSpace];
    UIImage* previousImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/previous.png", resourcePath]];
	UIBarButtonItem* itemPrevious = [[UIBarButtonItem alloc] initWithImage:previousImage
																   style:UIBarButtonItemStylePlain
																  target:delegate
																  action:@selector(onPrevious:)];
	[items addObject:itemPrevious];
	self.previousItem = itemPrevious;
	[itemPrevious release];
	
	// playImage
    UIImage *playImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/play.png", resourcePath]];
	[items addObject:itemFlexedSpace];
    
	UIBarButtonItem* itemPlay = [[UIBarButtonItem alloc] initWithImage:playImage
																	   style:UIBarButtonItemStylePlain
																	  target:delegate
																	  action:@selector(onStart:)];
	[items addObject:itemPlay];
	self.playItem = itemPlay;
	[itemPlay release];
    
	// nextImage
     UIImage *nextImage =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/next.png", resourcePath]];
	[items addObject:itemFlexedSpace];
	UIBarButtonItem* itemNext = [[UIBarButtonItem alloc] initWithImage:nextImage
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:delegate
                                                                         action:@selector(onNext:)];
	[items addObject:itemNext];
	self.nextItem = itemNext;
	[itemNext release];
	
	
	
    UIImage* loopImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/looplesson.png", resourcePath]];

	// Loop
	[items addObject:itemFlexedSpace];
	UIBarButtonItem* itemLoop = [[UIBarButtonItem alloc] initWithImage:loopImage
																	style:UIBarButtonItemStylePlain
																   target:delegate
																   action:@selector(onLoop:)];
	[items addObject:itemLoop];
	self.loopItem = itemLoop;
	[itemLoop release];
	[items addObject:itemFlexibleSpace];
	
    [items addObject:itemFlexedSpaceSmall];
	
	[itemFlexibleSpace release];
	[itemFlexedSpace release];
	[itemFlexedSpaceSmall release];
	[self setItems:items animated:YES];
	[items release];
 }

@end
