//
//  DaybyDayViewController.m
//  Voice
//
//  Created by JiaLi on 12-5-11.
//  Copyright (c) 2012年 Founder. All rights reserved.
//

#import "DaybyDayViewController.h"

@interface DaybyDayViewController ()

@end

@implementation DaybyDayViewController
@synthesize textLabel;
@synthesize txtContent;
@synthesize adView;
@synthesize segmentControl;
@synthesize settingPrompt;
@synthesize delegate;

- (void)dealloc
{
    adView.delegate = nil;
    [adView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = DAYBYDY_TITLE;
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* left = [[UIBarButtonItem alloc] initWithTitle:STRING_BACK style:UIBarButtonSystemItemDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    [left release];
     UISegmentedControl* rightSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:STRING_DAY_CONTROL_OPEN,STRING_DAY_CONTROL_CLOSE, nil]];
    rightSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    UIBarButtonItem* right = [[UIBarButtonItem alloc] initWithCustomView:rightSegment];
    self.segmentControl = rightSegment;
    self.segmentControl.selectedSegmentIndex = 0;
   [rightSegment addTarget:self action:@selector(doChangedSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = right;
    [right release];
    [rightSegment release];
    self.textLabel.text = txtContent;
    self.settingPrompt.text = STRING_DAY_PROMPT;
    self.settingPrompt.textAlignment = UITextAlignmentRight;
    [self performSelector:@selector(addAD) withObject:nil afterDelay:0.2];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)back;
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addAD
{
    self.adView = [AdMoGoView requestAdMoGoViewWithDelegate:self AndAdType:AdViewTypeNormalBanner
                                                ExpressMode:NO];
    [adView setFrame:CGRectMake(0, self.view.bounds.size.height, 0, 0)];
    [self.view addSubview:adView];

}

- (NSString *)adMoGoApplicationKey {
   	//return @"bb0bf739cd8f4bbabb74bbaa9d2768bf"; //测试用ID

    if (IS_IPAD) {
        return @"df727527fbbb4f30823e1600f0c3aded";
    } else {
        return @"04a87505be9c4a45aad6c2ef9febdec9"; 
    }
    //此字符串为您的App在芒果上的唯一标识
}

- (UIViewController *)viewControllerForPresentingModalView {
	return self;//返回的对象为adView的父视图控制器
}

- (void)adjustAdSize {	
	[UIView beginAnimations:@"AdResize" context:nil];
	[UIView setAnimationDuration:0.7];
	CGSize adSize = [adView actualAdSize];
	CGRect newFrame = adView.frame;
	newFrame.size.height = adSize.height;
	newFrame.size.width = adSize.width;
	newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/2;
    newFrame.origin.y = self.view.bounds.size.height - adSize.height;
	adView.frame = newFrame;
    
	[UIView commitAnimations];
} 

- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView {
	//广告成功展示时调用
    [self adjustAdSize];
}

- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView 
                     usingBackup:(BOOL)yesOrNo {
    //请求广告失败
    NSLog(@"adMoGoView failed");
}

- (void)adMoGoWillPresentFullScreenModal {
    //点击广告后打开内置浏览器时调用
}

- (void)adMoGoDidDismissFullScreenModal {
    //关闭广告内置浏览器时调用 
}

- (IBAction)doChangedSegment:(id)sender;
{
    if (self.segmentControl.selectedSegmentIndex == 1) {
        [self.delegate setClosedDay];
    }
}

@end
