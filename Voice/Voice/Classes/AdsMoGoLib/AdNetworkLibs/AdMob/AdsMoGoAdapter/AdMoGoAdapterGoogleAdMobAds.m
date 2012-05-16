//
//  File: AdMoGoAdapterGoogleAdMobAds.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.7
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterGoogleAdMobAds.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoView.h"
#import "GADBannerView.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"

@implementation AdMoGoAdapterGoogleAdMobAds

+ (void)load {
	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

+ (AdMoGoAdNetworkType)networkType {
	return AdMoGoAdNetworkTypeAdMob;
}

// converts UIColor to hex string, ignoring alpha.
- (NSString *)hexStringFromUIColor:(UIColor *)color {
	CGColorSpaceModel colorSpaceModel =
	CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
	if (colorSpaceModel == kCGColorSpaceModelRGB
		|| colorSpaceModel == kCGColorSpaceModelMonochrome) {
		const CGFloat *colors = CGColorGetComponents(color.CGColor);
		CGFloat red = 0.0, green = 0.0, blue = 0.0;
		if (colorSpaceModel == kCGColorSpaceModelRGB) {
			red = colors[0];
			green = colors[1];
			blue = colors[2];
			// we ignore alpha here.
		} else if (colorSpaceModel == kCGColorSpaceModelMonochrome) {
			red = green = blue = colors[0];
		}
		return [NSString stringWithFormat:@"%02X%02X%02X",
                (int)(red * 255), (int)(green * 255), (int)(blue * 255)];
	}
	return nil;
}

- (NSObject *)delegateValueForSelector:(SEL)selector {
	return ([adMoGoDelegate respondsToSelector:selector]) ?
	[adMoGoDelegate performSelector:selector] : nil;
}

- (void)getAd {
	GADRequest *request = [GADRequest request];
	NSObject *value;
	
	NSMutableDictionary *additional = [NSMutableDictionary dictionary];
	
	if ((value = [self delegateValueForSelector:
				  @selector(adMoGoAdBackgroundColor)])) {
		[additional setObject:[self hexStringFromUIColor:(UIColor *)value]
					   forKey:@"color_bg"];
	}
	
	if ((value = [self delegateValueForSelector:
				  @selector(adMoGoAdBackgroundColor)])) {
		[additional setObject:[self hexStringFromUIColor:(UIColor *)value]
					   forKey:@"color_text"];
	}
	
	// deliberately don't allow other color specifications.
	
	if ([additional count] > 0) {
		request.additionalParameters = additional;
	}
	
	CLLocation *location =
	(CLLocation *)[self delegateValueForSelector:@selector(locationInfo)];
	if (location == nil) {
        location = [AdMoGoView sharedLocation];
    }
	if ((adMoGoConfig.locationOn) && (location)) {
		[request setLocationWithLatitude:location.coordinate.latitude
							   longitude:location.coordinate.longitude
								accuracy:location.horizontalAccuracy];
	}
	
	NSString *string =
	(NSString *)[self delegateValueForSelector:@selector(gender)];
	
	if ([string isEqualToString:@"m"]) {
		request.gender = kGADGenderMale;
	} else if ([string isEqualToString:@"f"]) {
		request.gender = kGADGenderFemale;
	} else {
		request.gender = kGADGenderUnknown;
	}
	
	if ((value = [self delegateValueForSelector:@selector(dateOfBirth)])) {
		request.birthday = (NSDate *)value;
	}
	
	if ((value = [self delegateValueForSelector:@selector(keywords)])) {
		request.keywords = [NSMutableArray arrayWithArray:(NSArray *)value];
	}
    
    if (networkConfig.testMode) {
        request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,
                               [[UIDevice currentDevice] uniqueIdentifier],nil];
    }
	
    AdViewType type = adMoGoView.adType;
    CGSize size =CGSizeMake(0, 0);
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = CGSizeMake(320, 50);
            break;
        case AdViewTypeRectangle:
            size = CGSizeMake(300, 250);
            break;
        case AdViewTypeMediumBanner:
            size = CGSizeMake(468, 60);
            break;
        case AdViewTypeLargeBanner:
            size = CGSizeMake(728, 90);
            break;
        default:
            break;
    }

	GADBannerView *view =
	[[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	view.adUnitID = [self publisherId];
	view.delegate = self;
	view.rootViewController =
	[adMoGoDelegate viewControllerForPresentingModalView];
	self.adNetworkView = [view autorelease];
	[view loadRequest:request];
}

- (void)stopBeingDelegate {
	if (self.adNetworkView != nil
		&& [self.adNetworkView respondsToSelector:@selector(setDelegate:)]) {
		[self.adNetworkView performSelector:@selector(setDelegate:)
								 withObject:nil];
	}
}

- (void)dealloc {
    [super dealloc];
}
#pragma mark Ad Request Lifecycle Notifications
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    [adMoGoView adapter:self didGetAd:@"admob"];
	[adMoGoView adapter:self didReceiveAdView:adView];
}
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    [adMoGoView adapter:self didGetAd:@"admob"];
	[adMoGoView adapter:self didFailAd:error];
}

#pragma mark Click-Time Lifecycle Notifications
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
	[self helperNotifyDelegateOfFullScreenModal];
}
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma mark parameter gathering methods
- (SEL)delegatePublisherIdSelector {
	return @selector(admobPublisherID);
}

- (NSString *)publisherId {
	SEL delegateSelector = [self delegatePublisherIdSelector];
	if ((delegateSelector) &&
		([adMoGoDelegate respondsToSelector:delegateSelector])) {
		return [adMoGoDelegate performSelector:delegateSelector];
	}
	return networkConfig.pubId;
}
@end