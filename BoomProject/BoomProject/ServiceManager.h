//
//  ServiceManager.h
//  BoomProject
//
//  Created by User ACA on 2/20/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface ServiceManager : AFHTTPSessionManager

+ (ServiceManager *)sharedManager;

- (void)loginWithUserToken:(NSString *)userToken
                onSuccess:(void (^)(NSArray *forms))success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;
@end
