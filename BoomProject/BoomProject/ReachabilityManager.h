//
//  ReachabilityManager.h
//  BoomProject
//
//  Created by User ACA on 5/1/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>

@interface ReachabilityManager : Reachability

@property (strong, nonatomic) Reachability *reachability;

+ (ReachabilityManager *)sharedManager;

+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
