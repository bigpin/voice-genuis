//
//  ScenesCoverViewController.h
//  Voice
//
//  Created by JiaLi on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>


@interface ScenesCoverViewController : UIViewController <TKCoverflowViewDelegate,TKCoverflowViewDataSource,UIScrollViewDelegate> {
    NSMutableArray* _scenesArray;
	TKCoverflowView *coverflow; 
	NSMutableArray *covers; // album covers images
	BOOL collapsed;
	NSInteger nCoverIndex;
}

@property (nonatomic,retain,) TKCoverflowView *coverflow; 
@property (nonatomic,retain) NSMutableArray *covers;
@property (nonatomic,retain) NSMutableArray* scenesArray;

- (void)loadScenes;
@end