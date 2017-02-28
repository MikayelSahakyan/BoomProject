//
//  ServiceManager.m
//  BoomProject
//
//  Created by User ACA on 2/20/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "ServiceManager.h"
#import "Form.h"
#import "Entry.h"

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
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userToken,              @"user_token",
                            kLoginFirebaseToken,    @"firebase_token",
                            @"1",                   @"notification",
                            @"1",                   @"sound",
                            nil];
    
    [self POST:kHostSettingsURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"JSON:%@", responseObject);
           
           NSArray *dictsArray = responseObject;
           NSMutableArray *objectsArray = [NSMutableArray array];
           
           for (NSDictionary *dictionary in dictsArray) {
               Form *form = [[Form alloc] initWithResponse:dictionary];
               [objectsArray addObject:form];
           }
           if (success) {
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
                      andFormID:(NSString *)formID
                    lastEntryID:(NSString *)entryID
                      onSuccess:(void (^)(NSArray *entries))success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userToken,              @"user_token",
                            formID,                 @"form_id",
                            entryID,                @"entry_id",
                            nil];
    
    [self GET:kHostEntryURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"JSON:%@", responseObject);
           NSArray *arraysArray = responseObject;
           NSMutableArray *entriesArray = [NSMutableArray array];
           
           for (NSArray *dictsArray in arraysArray) {
               NSMutableArray *objectsArray = [NSMutableArray array];
               
               for (NSDictionary *dictionary in dictsArray) {
                   Entry *entry = [[Entry alloc] initWithResponse:dictionary];
                   [objectsArray addObject:entry];
               }
               [entriesArray addObject:objectsArray];
           }
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

@end
