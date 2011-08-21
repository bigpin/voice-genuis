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
@synthesize lessonItem = _lessonItem;
@synthesize moreItem = _moreItem;
@synthesize settingItem = _settingItem;

- (void)loadToolbar:(id)delegate;
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
    
    itemFlexedSpace.width = 25.0;
    /*itemFlexedSpace.width = [[UIDevice currentDevice] userInterfaceIdiom] == [UIUserInterfaceIdiomPad]? 35.0 : 20.0;*/
    
    [items addObject:itemFlexibleSpace];
    
    // Previous
    UIImage* previousImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/previous.png", resourcePath]];
    [items addObject:itemFlexedSpaceSmall];
    UIBarButtonItem* itemPrevious = [[UIBarButtonItem alloc] initWithImage:previousImage
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:delegate
                                                                    action:@selector(onPrevious:)];
    [items addObject:itemPrevious];
    self.previousItem = itemPrevious;
    [itemPrevious release];
    
    // playImage
    NSString* imageName = [delegate isPlaying] ? @"%@/pause.png" : @"%@/play.png";
    UIImage *playImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:imageName, resourcePath]];
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
    
    
    // setting
    UIImage *settingImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/preferences.png", resourcePath]];
    [items addObject:itemFlexedSpace];
    
    UIBarButtonItem* itemSetting = [[UIBarButtonItem alloc] initWithImage:settingImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:delegate
                                                                   action:@selector(onSetting:)];
    [items addObject:itemSetting];
    self.settingItem = itemSetting;
    [itemSetting release];
    
    [items addObject:itemFlexedSpaceSmall];
    [items addObject:itemFlexibleSpace];
    
    [itemFlexibleSpace release];
    [itemFlexedSpace release];
    [itemFlexedSpaceSmall release];
    [self setItems:items animated:YES];
    [items release];
}
    
/*- (void)loadItems:(id)delegate;
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
    
    itemFlexedSpace.width = 25.0;
	
	[items addObject:itemFlexibleSpace];
 	
	// Previous
    UIImage* previousImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/previous.png", resourcePath]];
	[items addObject:itemFlexedSpaceSmall];
	UIBarButtonItem* itemPrevious = [[UIBarButtonItem alloc] initWithImage:previousImage
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:delegate
                                                                    action:@selector(onPrevious:)];
	[items addObject:itemPrevious];
	self.previousItem = itemPrevious;
	[itemPrevious release];
	
	// playImage
    NSString* imageName = [delegate isPlaying] ? @"%@/pause.png" : @"%@/play.png";
    UIImage *playImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:imageName, resourcePath]];
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
	
	
    // setting
    UIImage *settingImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/preferences.png", resourcePath]];
	[items addObject:itemFlexedSpace];
    
	UIBarButtonItem* itemSetting = [[UIBarButtonItem alloc] initWithImage:settingImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:delegate
                                                                   action:@selector(onSetting:)];
	[items addObject:itemSetting];
	self.settingItem = itemSetting;
	[itemSetting release];
    
    
    // more
    UIImage *moreImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/more.png", resourcePath]];
	[items addObject:itemFlexedSpace];
    
	UIBarButtonItem* itemmore = [[UIBarButtonItem alloc] initWithImage:moreImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:delegate
                                                                action:@selector(onMore:)];
	[items addObject:itemmore];
	self.moreItem = itemmore;
	[itemmore release];
    
	[items addObject:itemFlexedSpaceSmall];
	[items addObject:itemFlexibleSpace];
	
	[itemFlexibleSpace release];
	[itemFlexedSpace release];
	[itemFlexedSpaceSmall release];
	[self setItems:items animated:YES];
	[items release];
}

- (void)loadMoreItems:(id)delegate;
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
    
    itemFlexedSpace.width = 30.0;
	
	[items addObject:itemFlexibleSpace];
    
    [items addObject:itemFlexedSpaceSmall];
	
    // more
    UIImage *moreImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/more.png", resourcePath]];    
	UIBarButtonItem* itemmore = [[UIBarButtonItem alloc] initWithImage:moreImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:delegate
                                                                action:@selector(onMore:)];
	[items addObject:itemmore];
	self.moreItem = itemmore;
	[itemmore release];
    
    // lessons/sentense
    NSString* imageName = [delegate isLesson]? @"%@/sentence.png" :@"%@/lesson.png";
    UIImage* lessonImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:imageName, resourcePath]];
    
    [items addObject:itemFlexedSpace];
	UIBarButtonItem* itemlesson = [[UIBarButtonItem alloc] initWithImage:lessonImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:delegate
                                                                  action:@selector(onLesson:)];
	[items addObject:itemlesson];
	self.lessonItem = itemlesson;
	[itemlesson release];
    
	// Loop
    imageName = [delegate isLoop]? @"%@/looplesson.png" :@"%@/loopsingle.png";
    UIImage* loopImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:imageName, resourcePath]];
    
	[items addObject:itemFlexedSpace];
	UIBarButtonItem* itemLoop = [[UIBarButtonItem alloc] initWithImage:loopImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:delegate
                                                                action:@selector(onLoop:)];
	[items addObject:itemLoop];
	self.loopItem = itemLoop;
	[itemLoop release];
    
    
    // Other button
    UIImage* otherImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/icon_volume.png", resourcePath]];
	[items addObject:itemFlexedSpace];
	UIBarButtonItem* itemOther = [[UIBarButtonItem alloc] initWithImage:otherImage
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:delegate
                                                                 action:@selector(onOther:)];
	[items addObject:itemOther];
	self.volumItem = itemOther;
	[itemOther release];
    
    [items addObject:itemFlexedSpaceSmall];
	[items addObject:itemFlexibleSpace];
	
	[itemFlexibleSpace release];
	[itemFlexedSpace release];
	[itemFlexedSpaceSmall release];
	[self setItems:items animated:YES];
	[items release];
    
}
*/
@end
