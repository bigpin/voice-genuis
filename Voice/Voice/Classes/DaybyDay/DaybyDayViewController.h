//
//  DaybyDayViewController.h
//  Voice
//
//  Created by JiaLi on 12-5-11.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMoGoView.h"

@protocol DaybyDayViewControllerDelegate <NSObject>

- (void)setClosedDay;
@end

@interface DaybyDayViewController : UIViewController<AdMoGoDelegate>
{
    AdMoGoView *adView;
}
@property (nonatomic, retain) AdMoGoView *adView;
@property (nonatomic, retain) IBOutlet UIWebView* textLabel;
@property (nonatomic, retain) NSString* txtContent;
@property (nonatomic, retain) IBOutlet UISwitch* switchControl;
@property (nonatomic, retain) IBOutlet UILabel* settingPrompt;
@property (nonatomic, readwrite, assign) id <DaybyDayViewControllerDelegate> delegate;

- (void)back;
- (void)addAD;

- (IBAction)doChangedSegment:(id)sender;

@end
