//
//  Teacher.h
//  XMLBooks
//
//  Created by yangxuefeng on 11-7-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Teacher : NSObject {
	NSString* teacherid;
	NSString* surname;
	NSString* name;
	NSString* description;
	NSString* gender;
	NSString* avatar;
}

@property (nonatomic, retain) NSString* teacherid;
@property (nonatomic, retain) NSString* surname;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* gender;
@property (nonatomic, retain) NSString* avatar;

@end
