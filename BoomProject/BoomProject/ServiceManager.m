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

static NSString *const kLoginFirebaseToken = @"fDWS5Jv-mdc:APA91bG-RuNhAp5-NZGm47MCFTdHYVZ0idkCwa2vItyEvncAp7wVOVXxYA_q2s1Q8rElfqzUa3UsshCS6lohoCBEKzaanSWWR1XYOF3qIWbz-qZxZGg12VyLMnjgaLG2IdWlIymj17h0";
static NSString *const kHostSettingsURL = @"http://api.boomform.com/form/settings";
static NSString *const kHostEntryURL = @"http://api.boomform.com/form/entries/";

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

- (void)loginWithUserToken:(NSString *)userToken
                 onSuccess:(void (^)(NSArray *forms))success
                 onFailure:(void (^)(NSError *, NSInteger))failure {
    
    NSDictionary *params = @{@"user_token"     : userToken,
                             @"firebase_token" : kLoginFirebaseToken,
                             @"notification"   : @"1",
                             @"sound"          : @"1"};
    
    [self POST:kHostSettingsURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"JSON:%@", responseObject);
           NSManagedObjectContext *context = [[[DataManager sharedManager] persistentContainer] viewContext];
           [[DataManager sharedManager] deleteAllForms];
           NSArray *dictsArray = responseObject;
           NSMutableArray *objectsArray = [NSMutableArray array];
           
           for (NSDictionary *dictionary in dictsArray) {
               Form *form = [NSEntityDescription insertNewObjectForEntityForName:@"Form" inManagedObjectContext:context];
               form.formID = [dictionary objectForKey:@"id"];
               form.name = [dictionary objectForKey:@"name"];
               form.index = [dictsArray indexOfObject:dictionary];
               [objectsArray addObject:form];
           }
           if (success) {
               [[DataManager sharedManager] saveContext];
               success(objectsArray);
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [response statusCode];
           NSLog(@"Error:%@", error);
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
    [self GET:kHostEntryURL
   parameters:params
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          NSLog(@"JSON:%@", responseObject);
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
          NSLog(@"Error:%@", error);
          if (failure) {
              failure(error, statusCode);
          }
      }];
}

- (void)removeEntryWithUserToken:(NSString *)userToken
               andRemovedEntryID:(double)entryID
                       onSuccess:(void (^)(id result))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = @{@"user_token"     : userToken,
                             @"firebase_token" : kLoginFirebaseToken,
                             @"entry_remove"   : @(entryID)};
    [self POST:kHostSettingsURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"JSON:%@", responseObject);
           if (success) {
               success(responseObject);
           }
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [respone statusCode];
           NSLog(@"Error:%@", error);
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

- (void)logOutWithUserToken:(NSString *)userToken
                  onSuccess:(void (^)(id result))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = @{@"user_token"     : userToken,
                             @"firebase_token" : kLoginFirebaseToken,
                             @"status"         : @"logged_out"};
    [self POST:kHostSettingsURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"JSON:%@", responseObject);
           if (success) {
               success(responseObject);
           }
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [respone statusCode];
           NSLog(@"Error:%@", error);
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

- (void)changeNotificationWithUserToken:(NSString *)userToken
            andNotificationStatusChange:(NSInteger)change
                              onSuccess:(void (^)(id result))success
                              onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = @{@"user_token"     : userToken,
                             @"firebase_token" : kLoginFirebaseToken,
                             @"notification"   : @(change)};
    [self POST:kHostSettingsURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"JSON:%@", responseObject);
           if (success) {
               success(responseObject);
           }
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [respone statusCode];
           NSLog(@"Error:%@", error);
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

- (void)changeSoundWithUserToken:(NSString *)userToken
            andSoundStatusChange:(NSInteger)change
                       onSuccess:(void (^)(id result))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = @{@"user_token"     : userToken,
                             @"firebase_token" : kLoginFirebaseToken,
                             @"sound"          : @(change)};
    [self POST:kHostSettingsURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"JSON:%@", responseObject);
           if (success) {
               success(responseObject);
           }
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
           NSInteger statusCode = [respone statusCode];
           NSLog(@"Error:%@", error);
           if (failure) {
               failure(error, statusCode);
           }
       }];
}

@end
