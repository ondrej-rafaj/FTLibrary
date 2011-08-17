//
//  FTAppDelegate.m
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTAppDelegate.h"


@implementation FTAppDelegate

+ (id)delegate {
	return [[UIApplication sharedApplication] delegate];
}

+ (UIWindow *)windowFromSelector:(SEL)selector {
	if ([[UIApplication sharedApplication] respondsToSelector:selector]) {
		return [[UIApplication sharedApplication] performSelector:selector];
	}
	else return nil;
}

+ (UIWindow *)window {
	return [self windowFromSelector:@selector(window)];
}


/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark --
#pragma mark Core Data stacks

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext_ != nil)
    {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel_ != nil)
    {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"calpolhistory" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator_ != nil)
    {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FTLibrary.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


- (void)saveContext {
    NSError *error = nil;
    [managedObjectContext_ save:&error];
    if (error) {
		NSLog(@"Error while saving: %@, %@", error, [error userInfo]);
    }
}




@end
