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

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;
@property (strong, nonatomic) NSMutableArray *forms;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.forms = [NSMutableArray array];
    
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
    NSLog(@"Tapped Once");
    [self.tokenTextField resignFirstResponder];
}

- (void)doubleTap {
    NSLog(@"Tapped Twice");
    [self.tokenTextField resignFirstResponder];
}

- (void)swipeDown {
    NSLog(@"Swiped Down");
    [self.tokenTextField resignFirstResponder];
}

- (void)swipeUp {
    NSLog(@"Swiped Up");
    [self.tokenTextField resignFirstResponder];
}

- (void)swipeLeft {
    NSLog(@"Swiped Left");
    [self.tokenTextField resignFirstResponder];
}

- (void)swipeRight {
    NSLog(@"Swiped Right");
    [self.tokenTextField resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.tokenTextField.text forKey:@"token"];
    [self.tokenTextField resignFirstResponder];
    [self getFormsFromServer];
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

- (void)getFormsFromServer {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[ServiceManager sharedManager] loginWithUserToken:token
                                             onSuccess:^(NSArray *forms) {
                                                 if (!(forms.count == 0)) {
                                                     [self.forms addObjectsFromArray:forms];
                                                     [self performSegueWithIdentifier:@"Login" sender:nil];
                                                 } else {
                                                     [self loginErrorAlert];
                                                 }
                                             }
                                             onFailure:^(NSError *error, NSInteger statusCode) {
                                                 [self loginErrorAlert];
                                                 NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
                                             }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Login"]) {
        FormViewController *formVC = [segue destinationViewController];
        [formVC setFormsArray:self.forms];
    }
}

- (void)loginErrorAlert {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Ooooops"
                                                                        message:@"Wrong token or No connection!!!"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [errorAlert addAction:ok];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

@end
