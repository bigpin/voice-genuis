//
//  File: AdMoGoAdapterGoogleAdMobAds.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.7
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//
//AdMob v5.0.5

#import "AdMoGoAdNetworkAdapter.h"
#import "GADBannerViewDelegate.h"

@interface AdMoGoAdapterGoogleAdMobAds : AdMoGoAdNetworkAdapter
<GADBannerViewDelegate> {
}

- (SEL)delegatePublisherIdSelector;
- (NSString *)hexStringFromUIColor:(UIColor *)color;
+ (AdMoGoAdNetworkType)networkType;
- (NSString *)publisherId;
@end
