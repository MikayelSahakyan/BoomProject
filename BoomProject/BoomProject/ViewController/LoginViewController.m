//
//  LoginViewController.m
//  BoomProject
//
//  Created by User ACA on 1/28/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "LoginViewController.h"
#import "FormViewController.h"
#import "EntriesViewController.h"
#import "ServiceManager.h"
#import <Firebase/Firebase.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Add GestureRecognizers
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(doubleTap)];
    [tapTwo setNumberOfTapsRequired:2];
    [tapTwo setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tapTwo];
    
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(singleTap)];
    [tapOne setNumberOfTapsRequired:1];
    [tapOne setNumberOfTouchesRequired:1];
    [tapOne requireGestureRecognizerToFail:tapTwo];
    [self.view addGestureRecognizer:tapOne];
    
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(swipeDown)];
    [down setDirection:UISwipeGestureRecognizerDirectionDown];
    [down requireGestureRecognizerToFail:tapTwo];
    [self.view addGestureRecognizer:down];
    
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(swipeUp)];
    [up setDirection:UISwipeGestureRecognizerDirectionUp];
    [up requireGestureRecognizerToFail:tapTwo];
    [self.view addGestureRecognizer:up];
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(swipeLeft)];
    [left setDirection:UISwipeGestureRecognizerDirectionLeft];
    [left requireGestureRecognizerToFail:tapTwo];
    [self.view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(swipeRight)];
    [right setDirection:UISwipeGestureRecognizerDirectionRight];
    [right requireGestureRecognizerToFail:tapTwo];
    [self.view addGestureRecognizer:right];
}

#pragma mark - Methods for GestureRecognizer

- (void)singleTap {
    [self.tokenTextField resignFirstResponder];
}

- (void)doubleTap {
    [self.tokenTextField resignFirstResponder];
}

- (void)swipeDown {
    [self.tokenTextField resignFirstResponder];
}

- (void)swipeUp {
    [self.tokenTextField resignFirstResponder];
}

- (void)swipeLeft {
    [self.tokenTextField resignFirstResponder];
}

- (void)swipeRight {
    [self.tokenTextField resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed {
    if (![[FIRInstanceID instanceID] token]) {
        [self connectionErrorAlert];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.tokenTextField.text forKey:@"token"];
        [self.tokenTextField resignFirstResponder];
        [self getFormsFromServer];
    }
}

- (IBAction)prepareToReturn:(UIStoryboardSegue *)segue {
    if ([[segue sourceViewController] isKindOfClass:[FormViewController class]] ||
        [[segue sourceViewController] isKindOfClass:[EntriesViewController class]]) {
        [self.tokenTextField setText:@""];
    }
}

#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loginButtonPressed];
    return YES;
}

// Check token and availability of internet
- (void)getFormsFromServer {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[ServiceManager sharedManager] checkUserToken:token
                                         onSuccess:^(id result) {
                                             if (![result isKindOfClass:[NSArray class]]) {
                                                 [self tokenErrorAlert];
                                             } else {
                                                 [self performSegueWithIdentifier:@"Login" sender:nil];
                                             }
                                         }
                                         onFailure:^(NSError *error, NSInteger statusCode) {
                                             [self connectionErrorAlert];
                                         }];
}

// Error alerts
- (void)tokenErrorAlert {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Boooom"
                                                                        message:@"Invalid token!"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [errorAlert addAction:ok];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)connectionErrorAlert {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Boooom"
                                                                        message:@"Connection problem!"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [errorAlert addAction:ok];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

@end
