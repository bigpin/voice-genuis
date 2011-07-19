//
//  Course.h
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Course : NSObject {
	NSString* title;
	NSString* subject;
	NSInteger level;
	NSString* language;
	NSMutableArray* lessons;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subject;
@property (nonatomic) NSInteger level;
@property (nonatomic, retain) NSString* language;
@property (nonatomic, retain) NSMutableArray* lessons;

@end
