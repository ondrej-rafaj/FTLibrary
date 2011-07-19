//
//  FTStorageService.h
//  FTLibrary
//
//  Created by Simon Lee on 15/11/2010.
//  Copyright 2010 Fuerte Int Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FTDomainObject.h"

/**
	This class represents a storage service
 */
@interface FTStorageService : NSObject {

@private
	NSString *identifier;
	
	NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;	
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

/**
	The storage service instance
	@returns a storage service instance
 */
+ (FTStorageService *)instance;


/**
	Initialises the storage service
	@param anIdentifier The identifier for the service
	@returns an initialised service
 */
- (id)initWithIdentifier:(NSString *)anIdentifier;

- (void)deleteAllObjects:(NSString *)entityDescription;

/**
	Returns all objects of the given type
	@param class The class of domain object to return
	@returns An array of domain objects
 */
- (NSArray *)allObjectsOfType:(Class)class;

/**
	The applications documents directory path
	@returns The path to the application documents directory
 */
- (NSString *)applicationDocumentsDirectoryPath;


/**
	Logs out the details of an NSError object
	@param error The error to log
 */
- (void)logNSError:(NSError *)error;


@end
