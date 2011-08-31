//
//  isaybio.h
//  isaybio
//
//  Created by Ding Li on 11-8-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "isaybio.h"

@interface isaybio : NSObject 

+(bool)ISB_LoadFile:(const char*)filename;

+(bool)ISB_SaveFile:(const char *)filename;

@end
