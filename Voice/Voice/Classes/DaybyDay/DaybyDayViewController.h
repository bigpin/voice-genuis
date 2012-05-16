//
//  DaybyDayViewController.h
//  Voice
//
//  Created by JiaLi on 12-5-11.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMoGoView.h"

@interface DaybyDayViewController : UIViewController<AdMoGoDelegate>
{
    AdMoGoView *adView;
}
@property (nonatomic, retain) AdMoGoView *adView;
@property(nonatomic, retain) IBOutlet UITextView* textLabel;
@property (nonatomic, retain) NSString* txtContent;
- (void)back;
- (void)addAD;
@end
