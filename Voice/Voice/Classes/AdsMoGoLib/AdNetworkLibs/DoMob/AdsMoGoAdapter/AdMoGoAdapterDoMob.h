//
//  File: AdMoGoAdapterDoMob.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.7
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//Domob v2.0

#import "AdMoGoAdNetworkAdapter.h"
#import "DoMobDelegateProtocol.h"
#import "DoMobView.h"
@interface AdMoGoAdapterDoMob : AdMoGoAdNetworkAdapter <DoMobDelegate>{
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
