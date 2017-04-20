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

- (void)loginWithUserToken:(NSString *)userToken
                 onSuccess:(void (^)(NSArray *forms))success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getEntriesWithUserToken:(NSString *)userToken
                fromCurrentForm:(Form *)form
                    lastEntryID:(double)entryID
                      onSuccess:(void (^)(NSArray *entries))success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)removeEntryWithUserToken:(NSString *)userToken
               andRemovedEntryID:(double)entryID
                       onSuccess:(void (^)(id result))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)logOutWithUserToken:(NSString *)userToken
                  onSuccess:(void (^)(id result))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)changeNotificationWithUserToken:(NSString *)userToken
            andNotificationStatusChange:(NSInteger)change
                              onSuccess:(void (^)(id result))success
                              onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)changeSoundWithUserToken:(NSString *)userToken
            andSoundStatusChange:(NSInteger)change
                       onSuccess:(void (^)(id result))success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

@end
