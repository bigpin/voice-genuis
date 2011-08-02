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
    UIBarButtonItem* _loopItem;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem* previousItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* volumItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* nextItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* playItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* loopItem;

- (void)loadItems:(id)delegate;
@end
