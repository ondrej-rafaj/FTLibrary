//
//  FTFilesystemPaths.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 04/03/2011.
//  Copyright 2011 Fuerte International Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTFilesystemPaths : NSObject {

}

+ (NSString *)getDocumentsDirectoryPath;

+ (NSString *)getRootDirectoryPath;

+ (NSString *)getTempDirectoryPath;

+ (NSString *)getConfigDirectoryPath;

+ (NSString *)getCacheDirectoryPath;

+ (NSString *)getImagesDirectoryPath;

+ (NSString *)getFilesDirectoryPath;

+ (NSString *)getSystemDirectoryPath;

+ (NSString *)getDatabaseDirectoryPath;

+ (NSString *)getSQLiteDirectoryPath;

+ (NSString *)getSQLiteFilePath:(NSString *)databaseName;






@end
