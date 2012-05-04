//
//  NSPhoneticSymbol.h
//  Voice
//
//  Created by li ding on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPhoneticSymbol : NSObject
{
    NSDictionary* psDict;
}

- (NSString*) getPhoneticSymbol:(NSString*)str;

@end
