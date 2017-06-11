//
//  DataManager.m
//  BoomProject
//
//  Created by User ACA on 3/20/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"
#import "Form+CoreDataClass.h"
#import "Entry+CoreDataClass.h"
#import "Row+CoreDataClass.h"

@implementation DataManager

+ (DataManager *)sharedManager {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

@synthesize managedObjectContext = _managedObjectContext;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _managedObjectContext = _persistentContainer.viewContext;
    }
    return self;
}

- (NSArray *)allObjects {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *request = [ServiceObject fetchRequest];
    NSError *requestError = nil;
    NSArray *resultArray = [context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    return resultArray;
}

- (NSArray *)allForms {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *request = [Form fetchRequest];
    NSError *requestError = nil;
    NSSortDescriptor *indexDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [request setSortDescriptors:@[indexDescriptor]];
    NSArray *resultArray = [context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    return resultArray;
}

- (NSArray *)allEntriesFromForm:(Form *)form {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSFetchRequest *request = [Entry fetchRequest];
    NSSortDescriptor *indexDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"form.formID == %@", form.formID];
    [request setSortDescriptors:@[indexDescriptor]];
    [request setPredicate:predicate];
    NSError *requestError = nil;
    NSArray *resultArray = [context executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    return resultArray;
}

- (void)printArray:(NSArray *)array {
    for (id object in array) {
        if ([object isKindOfClass:[Entry class]]) {
            Entry *entry = (Entry *)object;
            NSLog(@"Entry: %f, %@, FORM: %@, ROWS: %ld", entry.entryID, entry.date, entry.form.name, (unsigned long)[entry.rows count]);
        } else if ([object isKindOfClass:[Form class]]) {
            Form *form = (Form *)object;
            NSLog(@"FORM: %@ - %@, ENTRIES: %ld", form.formID, form.name, (unsigned long)[form.entries count]);
        } else if ([object isKindOfClass:[Row class]]) {
            Row *row = (Row *)object;
            NSLog(@"ROW: %f, %@ %@", row.entry.entryID, row.entry.date, row.entry.form.name);
        }
    }
    NSLog(@"COUNT = %ld", (unsigned long)[array count]);
}

- (void)printAllForms {
    NSArray *allForms = [self allForms];
    [self printArray:allForms];
}

- (void)printAllObjects {
    NSArray *allEntries = [self allObjects];
    [self printArray:allEntries];
}

- (void)deleteAllForms {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSArray *allForms = [self allForms];
    for (id object in allForms) {
        [context deleteObject:object];
    }
    [self saveContext];
}

- (void)deleteAllEntriesFromForm:(Form *)form {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSArray *allEntries = [self allEntriesFromForm:form];
    for (id object in allEntries) {
        [context deleteObject:object];
    }
    [self saveContext];
}

- (void)removeEntryFromForm:(Form *)form withID:(double)entryID {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSArray *allEntries = [self allEntriesFromForm:form];
    for (Entry *entry in allEntries) {
        if (entry.entryID == entryID) {
            [context deleteObject:entry];
        }
    }
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"BoomProject"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
