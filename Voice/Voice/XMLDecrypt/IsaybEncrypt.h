//
//  IsaybEncrypt.h
//  IsaybEncrypt
//
//  Created by li ding on 11-9-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IsaybEncrypt : NSObject

+ (bool) ISaybEncode:(unsigned char const *)pInBuffer 
          withLength:(const long)nLength 
            toBuffer:(unsigned char *)pOutBuffer 
          withLength:(long*)outlen;

+ (bool) ISaybDecode:(unsigned char const *)pInBuffer 
          withLength:(const long)nLength 
            toBuffer:(unsigned char *)pOutBuffer 
          withLength:(long*)outlen;

+ (bool) DecodeFile:(NSString*)infile 
                 to:(NSString*)outfile;

+ (long) LoadDecodeBuffer:(NSString*)infile
                       to:(unsigned char**)fileData;

+ (void) FreeBuffer:(unsigned char**)fileData;
@end
