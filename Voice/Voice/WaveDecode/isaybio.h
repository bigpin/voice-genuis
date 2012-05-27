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

+(bool)ISB_Isb:(const char*)isbFile toWav:(const char *)wavFile;

+(bool)ISB_Wav:(const char*)wavFile toIsb:(const char *)isbFile;

@end
