//
//  AppDelegate.h
//  BoomProject
//
//  Created by User ACA on 1/26/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <Firebase/Firebase.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

