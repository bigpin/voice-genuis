//
//  ListeningVolumView.h
//  Voice
//
//  Created by JiaLi on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListeningVolumProgressView : UIProgressView {
    
}
@end

@class ListeningVolumView;
@protocol ListeningVolumViewDelegate <NSObject>

@optional
- (void)removeView:(ListeningVolumView*)volumnView;
@end

@interface ListeningVolumView : UIView {
    UIView* _centerView;
    UIButton* _volumndown;
    UIButton* _volumnup;
    UIImageView* _volumImage;
    UIProgressView* _volumProgress;
    id<ListeningVolumViewDelegate>viewDelegate;
}

@property(nonatomic, retain) IBOutlet UIView* centerView;
@property(nonatomic, retain) IBOutlet UIButton* volumndown;
@property(nonatomic, retain) IBOutlet UIButton* volumnup;
@property(nonatomic, retain) IBOutlet UIImageView* volumImage;
@property(nonatomic, retain) IBOutlet UIProgressView* volumProgress;
@property(nonatomic, assign) id<ListeningVolumViewDelegate>viewDelegate;

- (void)loadResource;

@end
