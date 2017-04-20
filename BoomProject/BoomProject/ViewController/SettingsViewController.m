//
//  SettingsViewController.m
//  BoomProject
//
//  Created by User ACA on 1/29/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "SettingsViewController.h"
#import "ServiceManager.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitcher;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationSwitcher.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"notificationSwitchState"];
    self.soundSwitcher.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"soundSwitchState"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - API

- (void)changeNotification:(NSInteger)value {
    [[ServiceManager sharedManager] changeNotificationWithUserToken:@"david"
                                        andNotificationStatusChange:value
                                                          onSuccess:^(id result) {
                                                              //
                                                          }
                                                          onFailure:^(NSError *error, NSInteger statusCode) {
                                                              //
                                                          }];
}

- (void)changeSound:(NSInteger)value {
    [[ServiceManager sharedManager] changeSoundWithUserToken:@"david"
                                        andSoundStatusChange:value
                                                   onSuccess:^(id result) {
                                                       //
                                                   }
                                                   onFailure:^(NSError *error, NSInteger statusCode) {
                                                       //
                                                   }];
}

#pragma mark - Actions

- (IBAction)notificationStatusChangeAction {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.notificationSwitcher.on forKey:@"notificationSwitchState"];
    [self checkNotificationSwithState];
}

- (IBAction)soundStatusChangeAction {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.soundSwitcher.on forKey:@"soundSwitchState"];
    [self checkSoundSwithState];
}

- (void)checkNotificationSwithState {
    if ([self.notificationSwitcher isOn]) {
        [self changeNotification:1];
    } else {
        [self changeNotification:0];
    }
}

- (void)checkSoundSwithState {
    if ([self.soundSwitcher isOn]) {
        [self changeSound:1];
    } else {
        [self changeSound:0];
    }
}

@end
