//
//  FTFilesystemPaths.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 04/03/2011.
//  Copyright 2011 Fuerte International Ltd. All rights reserved.
//

#import "FTFilesystemPaths.h"
#import "FTFilesystemIO.h"

#define kFTFilesystemPathsFolder            @"-"


@implementation FTFilesystemPaths

/**
 Returns path to the application documents directory
 
 @return NSString Path
 */
+ (NSString *)getDocumentsDirectoryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

/**
 Returns path to the root folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getRootDirectoryPath {
	NSString *p = [NSString stringWithFormat:@"%@/%@/", [self getDocumentsDirectoryPath], kFTFilesystemPathsFolder];
	[FTFilesystemIO makeFolderPath:p];
	return p;
}

/**
 Returns path to the temporary folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getTempDirectoryPath {
	NSString *p = [NSString stringWithFormat:@"%@/%@/", [self getRootDirectoryPath], @"temp"];
	[FTFilesystemIO makeFolderPath:p];
	return p;
}

/**
 Returns path to the configuration folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getConfigDirectoryPath {
	NSString *p = [NSString stringWithFormat:@"%@/%@/", [self getRootDirectoryPath], @"config"];
	[FTFilesystemIO makeFolderPath:p];
	return p;
}

/**
 Returns path to the cache folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getCacheDirectoryPath {
	NSString *p = [NSString stringWithFormat:@"%@/%@/", [self getRootDirectoryPath], @"cache"];
	[FTFilesystemIO makeFolderPath:p];
	return p;
}

/**
 Returns path to the persistent images folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getImagesDirectoryPath {
	NSString *p = [NSString stringWithFormat:@"%@/%@/", [self getRootDirectoryPath], @"images"];
	[FTFilesystemIO makeFolderPath:p];
	return p;
}

/**
 Returns path to the files folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getFilesDirectoryPath {
	NSString *p = [NSString stringWithFormat:@"%@/%@/", [self getRootDirectoryPath], @"files"];
	[FTFilesystemIO makeFolderPath:p];
	return p;
}

/**
 Returns path to the system folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getSystemDirectoryPath {
	NSString *p = [NSString stringWithFormat:@"%@/%@/", [self getRootDirectoryPath], @"system"];
	[FTFilesystemIO makeFolderPath:p];
	return p;
}

/**
 Returns path to the non SQLite database folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getDatabaseDirectoryPath {
	NSString *p = [NSString stringWithFormat:@"%@/%@/", [self getRootDirectoryPath], @"database"];
	[FTFilesystemIO makeFolderPath:p];
	return p;
}

/**
 Returns path to the SQLite database folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getSQLiteDirectoryPath {
	NSString *p = [NSString stringWithFormat:@"%@/%@/", [self getRootDirectoryPath], @"sqlite"];
	[FTFilesystemIO makeFolderPath:p];
	return p;
}

/**
 Returns path to the root folder used by FTFilesystemPaths class
 
 @return NSString Path
 */
+ (NSString *)getSQLiteFilePath:(NSString *)databaseName {
	return [NSString stringWithFormat:@"%@%@.sqlite", [self getSQLiteDirectoryPath], databaseName];
}


@end
