//
//  Database.m
//  Voice
//
//  Created by JiaLi on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import <sqlite3.h>

@implementation Database

static Database* _database;

+ (Database*)database
{
	if (_database == nil) {
		_database = [[Database alloc] init];
	}
	
	return _database;
}

- (id)init
{
	if ((self = [super init])) {
        NSError *error = nil;
        NSFileManager * fileMgr = [NSFileManager defaultManager];
		NSArray* libary =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		NSString *libaryDir =  [libary objectAtIndex:0];
		
        NSString* userdata = PATH_USERDATA;
		NSString *sqlitePath = [libaryDir stringByAppendingString:userdata];
        if (![fileMgr fileExistsAtPath:sqlitePath isDirectory:nil])  
            [fileMgr createDirectoryAtPath:sqlitePath withIntermediateDirectories:YES attributes:nil error:nil];	

        NSString* dirdatabase = DIR_DATABASE;
		sqlitePath = [sqlitePath stringByAppendingPathComponent:dirdatabase];
        if (![fileMgr fileExistsAtPath:sqlitePath isDirectory:nil])  
            [fileMgr createDirectoryAtPath:sqlitePath withIntermediateDirectories:YES attributes:nil error:nil];	

        NSString* databaseName = DATABASE_NAME;
		sqlitePath = [sqlitePath stringByAppendingPathComponent:databaseName];
        if (![fileMgr fileExistsAtPath:sqlitePath isDirectory:nil]) {
            NSString *homePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@", dirdatabase];
            
            NSString *copyFromDatabasePath = [homePath stringByAppendingPathComponent:databaseName];
            [fileMgr copyItemAtPath:copyFromDatabasePath toPath:sqlitePath error:&error];
         } else {
           
        }
		if (sqlite3_open([sqlitePath UTF8String], (sqlite3 **)(&_database)) != SQLITE_OK) {
 		} else {
           
        }
		databaseLock = [[NSLock alloc] init];
	}
	return self;
}

- (BOOL)createTable;
{
    return YES;
    /*NSString* history = HISTORY_TABLE_NAME;
    if ([self isExistsTable:history]) {
        return NO;
	}
	
	[databaseLock lock];
	sqlite3_stmt *statement;
	BOOL bSuccess = NO;
	NSMutableString  *sql =[[NSMutableString alloc] initWithFormat:@"Create TABLE MAIN.[%@]", history];
	[sql appendString:@"("];
	[sql appendFormat:@"[%@] integer PRIMARY KEY UNIQUE NOT NULL",LIB_LINE_FILEID];
	[sql appendFormat:@",[%@] varchar",LIB_LINE_ORG_NAME];
	[sql appendFormat:@",[%@] varchar",LIB_LINE_USER_NAME];
	[sql appendString:@");"];	
	
	int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
	if (success == SQLITE_OK) {
		success = sqlite3_step(statement);
	} else {
		
	}
	sqlite3_finalize(statement);
	[sql release];
	[databaseLock unlock];
	return bSuccess;*/	

}

- (BOOL)isExistsTable:(NSString*)tableName;
{
	BOOL bExist = NO;
	[databaseLock lock];
	sqlite3_stmt *statement;
    NSMutableString  *sql =[[NSMutableString alloc] initWithFormat:@"select name from sqlite_master WHERE type = %@ AND name = '%@'", @"\"table\"", tableName];
	int success = sqlite3_prepare_v2((sqlite3 *)_database, [sql UTF8String], -1, &statement, NULL);
    if (success == SQLITE_OK) {
		if (sqlite3_step(statement) == SQLITE_ROW) {
			bExist = YES;
		}
    } else {
		
	}
	sqlite3_finalize(statement);
	[sql release];
	[databaseLock unlock];
	return bExist;
}

@end
