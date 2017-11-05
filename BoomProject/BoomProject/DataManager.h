//
//  DataManager.h
//  BoomProject
//
//  Created by User ACA on 3/20/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ServiceObject+CoreDataClass.h"
#import "Form+CoreDataClass.h"
#import "Entry+CoreDataClass.h"
#import "Row+CoreDataClass.h"

@interface DataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly) NSPersistentContainer *persistentContainer;

+ (DataManager *)sharedManager;
- (NSArray *)allObjects;
- (NSArray *)allForms;
- (NSArray *)allEntriesFromForm:(Form *)form;
- (void)deleteAllForms;
- (void)deleteAllEntriesFromForm:(Form *)form;
- (void)removeEntryFromForm:(Form *)form withID:(double)entryID;
- (void)saveContext;

@end
