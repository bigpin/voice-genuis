//
//  ListeningVolumView.h
//  Voice
//
//  Created by JiaLi on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListeningVolumProgressView : UIView {
    NSInteger nMaxLevel;
    NSInteger nCurrentLevel;
    BOOL    bDisabeldVolumn;
}
@property (nonatomic) NSInteger nMaxLevel;
@property (nonatomic) NSInteger nCurrentLevel;
@property(nonatomic) BOOL bDisabledVolumn;

@end

@class ListeningVolumView;
@protocol ListeningVolumViewDelegate <NSObject>

@optional
- (void)removeView:(ListeningVolumView*)volumnView;
- (void)setVolumn:(CGFloat)fV;
@end

@interface ListeningVolumView : UIView {
    UIView* _centerView;
    UIButton* _volumndown;
    UIButton* _volumnup;
    UIButton* _volumImage;
    ListeningVolumProgressView* _volumProgress;
    id<ListeningVolumViewDelegate>viewDelegate;
    BOOL    bDisabeldVolumn;
}

@property(nonatomic, retain) IBOutlet UIView* centerView;
@property(nonatomic, retain) IBOutlet UIButton* volumndown;
@property(nonatomic, retain) IBOutlet UIButton* volumnup;
@property(nonatomic, retain) IBOutlet UIButton* volumImage;
@property(nonatomic, retain) IBOutlet ListeningVolumProgressView* volumProgress;
@property(nonatomic, assign) id<ListeningVolumViewDelegate>viewDelegate;
@property(nonatomic, assign) BOOL bDisabeldVolumn;

- (void)loadResource;
- (void)setVolumnDisplay:(CGFloat)fv;
- (IBAction)onDisableVolumn;
- (IBAction)onIncreaseVolumn;
- (IBAction)onDecreseVolumn;

@end
