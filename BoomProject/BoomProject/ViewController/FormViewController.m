//
//  FormViewController.m
//  BoomProject
//
//  Created by User ACA on 1/29/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "FormViewController.h"
#import "FormTableViewCell.h"
#import "EntriesViewController.h"
#import "ServiceManager.h"
#import "DataManager.h"
#import "Form+CoreDataClass.h"
#import "AppDelegate.h"

@interface FormViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *formsArray;
@property (strong, nonatomic) Form *currentForm;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"StaySignedIn"];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0 green:0.588 blue:0.875 alpha:1];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.formsArray = [NSMutableArray array];
    [self getFormsFromCoreData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.notifyFormID) {
        [self.navigationItem setTitle:@""];
        [self.view insertSubview:self.loadingView aboveSubview:self.tableView];
        [self.loadingView setHidden:NO];
    } else {
        [self.view insertSubview:self.tableView aboveSubview:self.loadingView];
        [self.loadingView setHidden:YES];
        [self.navigationItem setTitle:@"Select Form"];
    }
}

#pragma mark - CoreData

- (void)getFormsFromCoreData {
    [[DataManager sharedManager] printAllForms];
    NSArray *forms = [[DataManager sharedManager] allForms];
    [self.formsArray removeAllObjects];
    [self.formsArray addObjectsFromArray:forms];
    [self.tableView reloadData];
    [self loadFormsWithCompletion:nil];
}

#pragma mark - API

- (void)loadFormsWithCompletion:(void (^)())completion {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[ServiceManager sharedManager] loginWithUserToken:token
                                             onSuccess:^(NSArray *forms) {
                                                 if (completion) {
                                                     completion();
                                                 }
                                                 [self.formsArray removeAllObjects];
                                                 [self.formsArray addObjectsFromArray:forms];
                                                 [self.tableView reloadData];
                                                 
                                                 if (self.notifyFormID) {
                                                     for (Form *form in self.formsArray) {
                                                         if ([form.formID isEqualToString:self.notifyFormID]) {
                                                             [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)form.index inSection:0]];
                                                         }
                                                     }
                                                     self.notifyFormID = nil;
                                                 }
                                             }
                                             onFailure:^(NSError *error, NSInteger statusCode) {
                                                 if (completion) {
                                                     completion();
                                                 }
                                                 NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
                                             }];
}

- (void)logOut {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[ServiceManager sharedManager] logOutWithUserToken:token
                                              onSuccess:^(id result) {
                                                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                  [defaults setBool:NO forKey:@"StaySignedIn"];
                                                  [defaults removeObjectForKey:@"token"];
                                                  [self performSegueWithIdentifier:@"LogOutFromFormSegue" sender:self];
                                              }
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  [self logOutErrorAlert];
                                              }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.formsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FormCell" forIndexPath:indexPath];
    Form *form = self.formsArray[indexPath.row];
    cell.formLabel.text = [NSString stringWithFormat:@"%@", form.name];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.currentForm = self.formsArray[indexPath.row];
    [self performSegueWithIdentifier:@"Entries" sender:self];
}

#pragma mark - IBAction

- (IBAction)actionSheetButtonPressed:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *button0 = [UIAlertAction actionWithTitle:@"Settings"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self openScheme:UIApplicationOpenSettingsURLString];
                                                    }];
    UIAlertAction *button1 = [UIAlertAction actionWithTitle:@"About"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        UIViewController *infoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"info"];
                                                        [self.navigationController pushViewController:infoVC animated:YES];
                                                    }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Log Out"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                            [self logOut];
                                                    }];
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"Cancle"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        //
                                                    }];
    [actionSheet addAction:button0];
    [actionSheet addAction:button1];
    [actionSheet addAction:button2];
    [actionSheet addAction:button3];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -

- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    }
}

- (void)logOutErrorAlert {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Boooom"
                                                                        message:@"Connection problem!\nWe couldn't  log out you."
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:nil];
    [errorAlert addAction:ok];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Entries"]) {
        EntriesViewController *entriesVC = [segue destinationViewController];
        [entriesVC setForm:self.currentForm];
        if (self.notifyFormID) {
            [entriesVC setNotifyEntryID:self.notifyEntryID];
        }
    }
}

- (void)refreshTable {
    [self loadFormsWithCompletion:^{
        [self.refreshControl endRefreshing];
    }];
}

@end
