//
//  ServiceManager.h
//  BoomProject
//
//  Created by User ACA on 2/20/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Form+CoreDataClass.h"

@interface ServiceManager : AFHTTPSessionManager

+ (ServiceManager *)sharedManager;

- (void)checkUserToken:(NSString *)userToken
             onSuccess:(void (^)(id result))success
             onFailure:(void (^)(NSError *, NSInteger))failure;

- (void)loginWithUserToken:(NSString *)userToken
                 onSuccess:(void (^)(NSArray *forms))success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getEntriesWithUserToken:(NSString *)userToken
                fromCurrentForm:(Form *)form
                    lastEntryID:(double)entryID
                      onSuccess:(void (^)(NSArray *entries))success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)updateEntriesWithUserToken:(NSString *)userToken
                   fromCurrentForm:(Form *)form
                       lastEntryID:(double)entryID
                         onSuccess:(void (^)(NSArray *entries))success
                         onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)removeEntryFromForm:(Form *)form
              WithUserToken:(NSString *)userToken
          andRemovedEntryID:(double)entryID
                  onSuccess:(void (^)(id result))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)logOutWithUserToken:(NSString *)userToken
                  onSuccess:(void (^)(id result))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)updateEntryWithUserToken:(NSString *)userToken
                  changedEntryID:(double)entryID
                        andRowID:(NSString *)rowID
                      editedText:(NSString *)text
                       onSuccess:(void (^)(id result))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

@end
