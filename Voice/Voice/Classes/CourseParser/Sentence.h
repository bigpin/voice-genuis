//
//  Sentence.h
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Sentence : NSObject {
	
	NSString* starttime;
	NSString* endtime;
	NSString* orintext;
	NSString* transtext;
	NSString* techerid;
	NSString* ps;

    NSMutableArray* words;
}

@property (nonatomic, retain) NSString* starttime;
@property (nonatomic, retain) NSString* endtime;
@property (nonatomic, retain) NSString* orintext;
@property (nonatomic, retain) NSString* transtext;
@property (nonatomic, retain) NSString* techerid;
@property (nonatomic, retain) NSString* ps;
@property (nonatomic, retain) NSMutableArray* words;

- (NSTimeInterval) startTime;
- (NSTimeInterval) endTime;

@end
