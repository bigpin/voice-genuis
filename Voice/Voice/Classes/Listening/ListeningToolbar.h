//
//  ListeningToolbar.h
//  Voice
//
//  Created by JiaLi on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ListeningToolbar : UIToolbar {
    UIBarButtonItem* _volumItem;
    UIBarButtonItem* _previousItem;
    UIBarButtonItem* _nextItem;
    UIBarButtonItem* _playItem;
    UIBarButtonItem* _lessonItem;
    UIBarButtonItem* _loopItem;
    UIBarButtonItem* _settingItem;
    UIBarButtonItem* _moreItem;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem* previousItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* volumItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* nextItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* playItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* lessonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* loopItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* settingItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* moreItem;

- (void)loadToolbar:(id)delegate;
//- (void)loadItems:(id)delegate;
//- (void)loadMoreItems:(id)delegate;
@end
