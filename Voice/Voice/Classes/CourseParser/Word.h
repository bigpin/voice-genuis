//
//  Word.h
//  Voice
//
//  Created by li ding on 11-9-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject {
    NSString* text;
    NSString* starttime;
	NSString* endtime;
    
    float fayin;    // fy
    float jiezou;   // sc
    float yinliang; // yl
    float yingao;   // yg
}

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* starttime;
@property (nonatomic, retain) NSString* endtime;
@property float fayin;
@property float jiezou;
@property float yinliang;
@property float yingao;

- (NSTimeInterval) startTime;
- (NSTimeInterval) endTime;

@end
