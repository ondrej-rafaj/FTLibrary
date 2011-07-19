//
//  FTSimpleDB.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 04/03/2011.
//  Copyright 2011 Fuerte International Ltd. All rights reserved.
//
//  @todo Finish comments for this class

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kFTSimpleDBFolder			@"FTSimpleDB"
#define kFTSimpleDBAIKey			@"autoincrement"
#define kFTSimpleDBDataKey			@"data"
#define kFTSimpleDBIndexKey			@"index"
#define kFTSimpleDBMainIdKey		@"FTSimpleDBSecretId"
#define kFTSimpleDBSelectedKey		@"FTSimpleDBSelectedKey"


@interface FTSimpleDB : NSObject {

}

+ (int)getId:(NSDictionary *)item;

+ (NSString *)getPathToDb:(NSString *)dbName;

+ (BOOL)isDatabase:(NSString *)dbName;

+ (BOOL)deleteDb:(NSString *)dbName;

+ (BOOL)truncateDb:(NSString *)dbName;

+ (int)getAutoincrementNumberForDb:(NSString *)dbName;

+ (NSArray *)getItemsFromDb:(NSString *)dbName;

+ (NSMutableArray *)getMutableItemsFromDb:(NSString *)dbName;

+ (void)saveFullData:(NSArray *)arr toDb:(NSString *)dbName;

+ (int)getNumberOfItemsInDb:(NSString *)dbName;

+ (NSDictionary *)getItem:(int)idItem inDb:(NSString *)dbName;

+ (int)addItemToBottom:(NSDictionary *)item intoDb:(NSString *)dbName;

+ (int)addItemToTop:(NSDictionary *)item intoDb:(NSString *)dbName;

+ (void)deleteItem:(int)idItem fromDb:(NSString *)dbName;

+ (void)updateItem:(int)idItem withData:(NSDictionary *)item inDb:(NSString *)dbName;

+ (void)moveTableItem:(NSIndexPath *)fromIndexPath to:(NSIndexPath *)toIndexPath inDb:(NSString *)dbName;

+ (int)duplicateItemToBottom:(int)idItem inDb:(NSString *)dbName;

+ (int)duplicateItemToTop:(int)idItem inDb:(NSString *)dbName;

+ (NSArray *)sortAscendingByKey:(NSString *)key inDb:(NSString *)dbName;

+ (NSArray *)sortDescendingByKey:(NSString *)key inDb:(NSString *)dbName;

+ (BOOL)isSelected:(int)idItem inDb:(NSString *)dbName;

+ (void)setSelected:(BOOL)selected forItem:(int)idItem inDb:(NSString *)dbName;

+ (BOOL)isDictionarySelected:(NSDictionary *)item inDb:(NSString *)dbName;

+ (void)setDictionarySelected:(BOOL)selected dictionary:(NSDictionary *)item inDb:(NSString *)dbName;




@end
