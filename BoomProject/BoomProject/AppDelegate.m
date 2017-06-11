//
//  AppDelegate.m
//  BoomProject
//
//  Created by User ACA on 1/26/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import "FormViewController.h"

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [FIRApp configure];
    [FIRMessaging messaging].remoteMessageDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"StaySignedIn"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *formVC = [storyboard instantiateViewControllerWithIdentifier:@"form"];
        UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigation"];
        [navigationController pushViewController:formVC animated:NO];
        self.window.rootViewController = navigationController;
        NSLog(@"not first launch");
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigation"];
        [navigationController pushViewController:loginVC animated:NO];
        self.window.rootViewController = navigationController;
        NSLog(@"first launch");
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connectToFcm];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[FIRMessaging messaging] disconnect];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[DataManager sharedManager] saveContext];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs token retrieved: %@", deviceToken);
    // With swizzling disabled you must set the APNs token here.
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        //
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FormViewController *formVC = [storyboard instantiateViewControllerWithIdentifier:@"form"];
        [formVC setNotifyFormID:userInfo[@"form_id"]];
        [formVC setNotifyEntryID:[userInfo[@"entry_id"] doubleValue]];
        UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigation"];
        [navigationController pushViewController:formVC animated:NO];
        self.window.rootViewController = navigationController;        
    }
}

// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[Messaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FormViewController *formVC = [storyboard instantiateViewControllerWithIdentifier:@"form"];
        [formVC setNotifyFormID:userInfo[@"form_id"]];
        [formVC setNotifyEntryID:[userInfo[@"entry_id"] doubleValue]];
        UINavigationController *navigationController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navigation"];
        [navigationController pushViewController:formVC animated:NO];
        self.window.rootViewController = navigationController;
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler();
}

// FIREBASE methods

- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"%@", remoteMessage.appData);
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}

- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

@end
