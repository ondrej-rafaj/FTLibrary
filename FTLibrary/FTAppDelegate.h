//
//  FTAppDelegate.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 06/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface FTAppDelegate : NSObject {
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (id)delegate;

+ (UIWindow *)windowFromSelector:(SEL)selector;

+ (UIWindow *)window;


@end
