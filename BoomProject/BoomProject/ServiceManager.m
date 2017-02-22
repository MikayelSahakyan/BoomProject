//
//  ServiceManager.m
//  BoomProject
//
//  Created by User ACA on 2/20/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "ServiceManager.h"
#import "FormModel.h"

static NSString *const kLoginFirebaseToken = @"fDWS5Jv-mdc:APA91bG-RuNhAp5-NZGm47MCFTdHYVZ0idkCwa2vItyEvncAp7wVOVXxYA_q2s1Q8rElfqzUa3UsshCS6lohoCBEKzaanSWWR1XYOF3qIWbz-qZxZGg12VyLMnjgaLG2IdWlIymj17h0";
static NSString *const kHostURL = @"http://api.boomform.com/form/settings";

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
                 onSuccess:(void (^)(NSArray *))success
                 onFailure:(void (^)(NSError *, NSInteger))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userToken,              @"user_token",
                            kLoginFirebaseToken,    @"firebase_token",
                            @"1",                   @"notification",
                            @"1",                   @"sound",
                            nil];
    
    [self POST:kHostURL
    parameters:params
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"JSON:%@", responseObject);
           
           NSArray *formDictionaries = responseObject;
                          
           NSMutableArray *forms = [NSMutableArray array];
                          
           for (NSDictionary *dictionary in formDictionaries) {
                              
               FormModel *form = [[FormModel alloc] initWithResponse:dictionary];
               [forms addObject:form];
           }
           if (success) {
               success(forms);
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
