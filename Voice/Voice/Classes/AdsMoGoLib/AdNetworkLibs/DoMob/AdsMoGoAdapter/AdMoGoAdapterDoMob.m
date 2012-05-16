//
//  File: AdMoGoAdapterDoMob.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.7
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterDoMob.h"
#import "AdMoGoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h" 

@implementation AdMoGoAdapterDoMob


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeDoMob;
}

+ (void)load{
    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    [adMoGoView adapter:self didGetAd:@"domob"];
    AdViewType type = adMoGoView.adType;
    CGSize size = CGSizeZero;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = DOMOB_SIZE_320x48;
            break;
        case AdViewTypeRectangle:
            size = DOMOB_SIZE_320x270;
            break;
        case AdViewTypeMediumBanner:
            size = DOMOB_SIZE_488x80;
            break;
        case AdViewTypeLargeBanner:
            size = DOMOB_SIZE_748x110;
            break;
        default:
            break;
    }
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    
    DoMobView *adView = [DoMobView requestDoMobViewWithSize:size WithDelegate:self];
    self.adNetworkView = adView;
    [self.adNetworkView retain];
}

- (void)stopBeingDelegate{
    DoMobView *doMobView = (DoMobView *)self.adNetworkView;
	if (doMobView != nil) {
		doMobView.doMobDelegate = nil;
	}
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }

	[super dealloc];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation{
    
}

#pragma mark DoMob Delegate
- (NSString *)domobPublisherIdForAd:(DoMobView *)doMobView{
	return networkConfig.pubId;
}

- (UIViewController *)domobCurrentRootViewControllerForAd:(DoMobView *)doMobView{
    return [adMoGoDelegate viewControllerForPresentingModalView];
}

- (BOOL)domobIsTestingMode{
    if (networkConfig.testMode) {
        return YES;
    }
    return NO;
}

- (BOOL)domobIsOpenLocation{
    if(adMoGoConfig.locationOn) {
        return YES;
    }
    return NO;
}
#pragma mark -
#pragma mark optional control methods
- (UIColor *)domobAdBackgroundColorForAd:(DoMobView *)doMobView{
    return [self helperBackgroundColorToUse];
}

- (UIColor *)domobPrimaryTextColorForAd:(DoMobView *)doMobView{
    return [self helperTextColorToUse];
}

#pragma mark -
#pragma mark optional Info methods
- (NSString *)domobKeywords{
    if ([adMoGoDelegate respondsToSelector:@selector(keywords)]) {
		return [adMoGoDelegate keywords];
	}
	return nil;
}

- (NSString *)domobPostalCode{
    if ([adMoGoDelegate respondsToSelector:@selector(postalCode)]) {
		return [adMoGoDelegate postalCode];
	}
	return nil;
}

- (NSString *)domobDateOfBirth{
    if ([adMoGoDelegate respondsToSelector:@selector(dateOfBirth)]) {
		NSString *Date = [[NSString alloc] init];
		NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
		NSDate *date = [adMoGoDelegate dateOfBirth];
		[dataFormatter setDateFormat:@"YYYYMMdd"];
		[Date stringByAppendingFormat:@"%@",[dataFormatter stringFromDate:date]];
		[Date autorelease];
		[dataFormatter autorelease];
		return Date;
	}
	return nil;
}

- (NSString *)domobGender{
    if ([adMoGoDelegate respondsToSelector:@selector(gender)]) {
		return [adMoGoDelegate gender];
	}
	return nil;
}

- (double)domobLocationLongitude{
    if ([adMoGoDelegate respondsToSelector:@selector(locationInfo)]) {
		return [adMoGoDelegate locationInfo].coordinate.longitude;
	}
    return [AdMoGoView sharedLocation].coordinate.longitude;
}

- (double)domobLocationLatitude{
    if ([adMoGoDelegate respondsToSelector:@selector(locationInfo)]) {
		return [adMoGoDelegate locationInfo].coordinate.latitude;
	}
    return [AdMoGoView sharedLocation].coordinate.latitude;
}

- (NSDate *)domobLocationTimestamp{
    if ([adMoGoDelegate respondsToSelector:@selector(locationInfo)]) {
		return [adMoGoDelegate locationInfo].timestamp;
	}
    return [AdMoGoView sharedLocation].timestamp;
}
#pragma mark -
#pragma mark optional Connection methods
- (void)domobDidReceiveAdRequest:(DoMobView *)doMobView{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoView adapter:self didReceiveAdView:doMobView];
}

- (void)domobDidReceiveRefreshedAd:(DoMobView *)doMobView{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoView adapter:self didGetAd:@"domob"];
    [adMoGoView adapter:self didReceiveAdView:doMobView];
}

- (void)domobDidFailToReceiveAdRequest:(DoMobView *)doMobView{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoView adapter:self didFailAd:nil];
}

- (void)domobDidFailToReceiveRefreshedAd:(DoMobView *)doMobView{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoView adapter:self didGetAd:@"domob"];
    [adMoGoView adapter:self didFailAd:nil];
}

- (void)domobWillPresentFullScreenModalFromAd:(DoMobView *)doMobView{
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)domobDidPresentFullScreenModalFromAd:(DoMobView *)doMobView{

}

- (void)domobWillDismissFullScreenModalFromAd:(DoMobView *)doMobView{

}

- (void)domobDidDismissFullScreenModalFromAd:(DoMobView *)doMobView{
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma mark -
#pragma mark optional control ad request interval methods
- (NSInteger)domobRefreshIntervalForAd:(DoMobView *)doMobView{
    return 0;
}

- (BOOL)domobIsPrintDebugLog{
    return NO;
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [adMoGoView adapter:self didFailAd:nil];
}
@end