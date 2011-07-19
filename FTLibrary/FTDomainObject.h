//
//  FTDomainObject.h
//  FTLibrary
//
//  Created by Ondrej Rafaj on 24.1.11.
//  Copyright Fuerte Int Ltd. (http://www.fuerteint.com) 2011. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface FTDomainObject : NSManagedObject {

}

+ (NSString *)entityName;

- (void)addToContext:(NSManagedObjectContext *)context;

- (NSArray *)sortedSet:(NSSet *)aSet;


@end
