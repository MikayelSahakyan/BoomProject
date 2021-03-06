//
//  ServiceManager.m
//  BoomProject
//
//  Created by User ACA on 2/20/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "ServiceManager.h"
#import "ServiceObject+CoreDataClass.h"
#import "DataManager.h"

static NSString *const kHostLoginURL = @"https://api.boomte.ch/login/";
static NSString *const kHostGetFormsURL = @"https://api.boomte.ch/get_forms/";
static NSString *const kHostGetSubmissionsURL = @"https://api.boomte.ch/get_submissions/";
static NSString *const kHostUpdateEntryURL = @"https://api.boomte.ch/update_entry/";
static NSString *const kHostRemoveEntryURL = @"https://api.boomte.ch/remove_entry/";
static NSString *const kHostLogOutURL = @"https://api.boomte.ch/logout/";

@implementation ServiceManager

+ (ServiceManager *)sharedManager {
    static ServiceManager *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[ServiceManager alloc] init];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [sharedObject setResponseSerializer:responseSerializer];
    });
    return sharedObject;
}

- (void)checkUserToken:(NSString *)userToken
             onSuccess:(void (^)(id result))success
             onFailure:(void (^)(NSError *, NSInteger))failure {
    
    NSString *fireToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"firebaseToken"];
    NSDictionary *params = @{@"user_token"     : userToken,
                             @"firebase_token" : fireToken,
                             @"notification"   : @"1",
                             @"sound"          : @"1"};
    
    [self POST:kHostLoginURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if (success) {
               success(responseObject);
           }
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [response statusCode];
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

- (void)getFormsWithUserToken:(NSString *)userToken
                    onSuccess:(void (^)(id result))success
                    onFailure:(void (^)(NSError *, NSInteger))failure {
    
    NSDictionary *params = @{@"user_token" : userToken};
    
    [self POST:kHostGetFormsURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if ([responseObject isKindOfClass:[NSDictionary class]]) {
               if (success) {
                   success(responseObject);
               }
           } else {
           NSManagedObjectContext *context = [[[DataManager sharedManager] persistentContainer] viewContext];
           [[DataManager sharedManager] deleteAllForms];
           NSArray *dictsArray = responseObject;
           NSMutableArray *objectsArray = [NSMutableArray array];
           
           for (NSDictionary *dictionary in dictsArray) {
               Form *form = [NSEntityDescription insertNewObjectForEntityForName:@"Form" inManagedObjectContext:context];
               form.formID = [dictionary objectForKey:@"formId"];
               form.name = [dictionary objectForKey:@"formName"];
               form.index = [dictsArray indexOfObject:dictionary];
               [objectsArray addObject:form];
           }
           if (success) {
               [[DataManager sharedManager] saveContext];
               success(objectsArray);
           }
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [response statusCode];
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

- (void)getEntriesWithUserToken:(NSString *)userToken
                fromCurrentForm:(Form *)form
                    lastEntryID:(double)entryID
                      onSuccess:(void (^)(NSArray *entries))success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = @{@"user_token" : userToken,
                             @"form_id"    : form.formID,
                             @"entry_id"   : @(entryID)};
    
    [self POST:kHostGetSubmissionsURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSManagedObjectContext *context = [[[DataManager sharedManager] persistentContainer] viewContext];
           
           NSArray *arrayOfArrays = responseObject;
           NSMutableArray *entriesArray = [NSMutableArray array];
           
           for (NSArray *rowDictsArray in arrayOfArrays) {
               if ([rowDictsArray count] > 1) {
                   // Parsing entry info at 0 index
                   Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
                   NSDictionary *entryInfo = rowDictsArray[0];
                   entry.date = entryInfo[@"date"];
                   entry.entryID = [entryInfo[@"id"] doubleValue];
                   entry.index = [arrayOfArrays indexOfObject:rowDictsArray];
                   
                   // Parsing rows
                   for (NSInteger i = 1; i < [rowDictsArray count]; i++) {
                       NSDictionary *rowDict = rowDictsArray[i];
                       
                       Row *row = [NSEntityDescription insertNewObjectForEntityForName:@"Row" inManagedObjectContext:context];
                       row.key = [rowDict objectForKey:@"key"];
                       row.value = [rowDict objectForKey:@"value"];
                       row.rowID = [rowDict objectForKey:@"row_id"];
                       row.entry = entry;
                       row.index = i;
                   }
                   entry.form = form;
                   [entriesArray addObject:entry];
               }
           }
           [[DataManager sharedManager] saveContext];
           if (success) {
               success(entriesArray);
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [response statusCode];
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

- (void)updateEntriesWithUserToken:(NSString *)userToken
                   fromCurrentForm:(Form *)form
                       lastEntryID:(double)entryID
                         onSuccess:(void (^)(NSArray *entries))success
                         onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = @{@"user_token" : userToken,
                             @"form_id"    : form.formID,
                             @"entry_id"   : @(entryID)};
    [self POST:kHostGetSubmissionsURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSManagedObjectContext *context = [[[DataManager sharedManager] persistentContainer] viewContext];
           [[DataManager sharedManager] deleteAllEntriesFromForm:form];
           
           NSArray *arrayOfArrays = responseObject;
           NSMutableArray *entriesArray = [NSMutableArray array];
           
           for (NSArray *rowDictsArray in arrayOfArrays) {
               if ([rowDictsArray count] > 1) {
                   // Parsing entry info at 0 index
                   Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
                   NSDictionary *entryInfo = rowDictsArray[0];
                   entry.date = entryInfo[@"date"];
                   entry.entryID = [entryInfo[@"id"] doubleValue];
                   entry.index = [arrayOfArrays indexOfObject:rowDictsArray];
                   
                   // Parsing rows
                   for (NSInteger i = 1; i < [rowDictsArray count]; i++) {
                       NSDictionary *rowDict = rowDictsArray[i];
                       
                       Row *row = [NSEntityDescription insertNewObjectForEntityForName:@"Row" inManagedObjectContext:context];
                       row.key = [rowDict objectForKey:@"key"];
                       row.value = [rowDict objectForKey:@"value"];
                       row.rowID = [rowDict objectForKey:@"row_id"];
                       row.entry = entry;
                       row.index = i;
                   }
                   entry.form = form;
                   [entriesArray addObject:entry];
               }
           }
           [[DataManager sharedManager] saveContext];
           if (success) {
               success(entriesArray);
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [response statusCode];
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

- (void)removeEntryFromForm:(Form *)form
              WithUserToken:(NSString *)userToken
          andRemovedEntryID:(double)entryID
                  onSuccess:(void (^)(id result))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = @{@"user_token" : userToken,
                             @"entry_id"   : @(entryID)};
    [self POST:kHostRemoveEntryURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [[DataManager sharedManager] removeEntryFromForm:form withID:entryID];
           if (success) {
               success(responseObject);
           }
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [respone statusCode];
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

- (void)logOutWithUserToken:(NSString *)userToken
                  onSuccess:(void (^)(id result))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSString *fireToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"firebaseToken"];
    NSDictionary *params = @{@"user_token"     : userToken,
                             @"firebase_token" : fireToken};
    
    [self POST:kHostLogOutURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if (success) {
               success(responseObject);
           }
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [respone statusCode];
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

- (void)updateEntryWithUserToken:(NSString *)userToken
                  changedEntryID:(double)entryID
                        andRowID:(NSString *)rowID
                      editedText:(NSString *)text
                       onSuccess:(void (^)(id result))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = @{@"user_token"      : userToken,
                             @"entry_id"        : @(entryID),
                             @"row_id"          : rowID,
                             @"edit"            : text};
    [self POST:kHostUpdateEntryURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if (success) {
               success(responseObject);
           }
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [respone statusCode];
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

@end
