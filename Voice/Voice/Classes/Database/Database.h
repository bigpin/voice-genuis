//
//  Database.h
//  Voice
//
//  Created by JiaLi on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HISTORY_TABLE_NAME @"History"
#define HISTORY_ID         @"ID"


@interface Database : NSObject {
 	Database* _database;
    NSLock *databaseLock; //mutex used to create our Critical Section
}

+ (Database*)database;
- (BOOL)createTable;
- (BOOL)isExistsTable:(NSString*)tableName;

@end
