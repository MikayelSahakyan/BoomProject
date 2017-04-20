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

@interface FormViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *formsArray;
@property (strong, nonatomic) Form *currentForm;

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0 green:0.588 blue:0.875 alpha:1];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.formsArray = [NSMutableArray array];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"StaySignedIn"];
    
    [self getFormsFromCoreData];
    [self getFormsFromServer];
}

#pragma mark - CoreData

- (void)getFormsFromCoreData {
    [[DataManager sharedManager] printAllForms];
    NSArray *forms = [[DataManager sharedManager] allForms];
    [self.formsArray addObjectsFromArray:forms];
    [self.tableView reloadData];
}

#pragma mark - API

- (void)getFormsFromServer {
    [[ServiceManager sharedManager] loginWithUserToken:@"david"
                                             onSuccess:^(NSArray *forms) {
                                                 [self.formsArray removeAllObjects];
                                                 [self.formsArray addObjectsFromArray:forms];
                                                 [self.tableView reloadData];
                                             }
                                             onFailure:^(NSError *error, NSInteger statusCode) {
                                                 NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
                                             }];
}

- (void)logOut {
    [[ServiceManager sharedManager] logOutWithUserToken:@"david"
                                              onSuccess:^(id result) {
                                                  //
                                              }
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  //
                                              }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"StaySignedIn"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.formsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FormCell" forIndexPath:indexPath];
    Form *form = [self.formsArray objectAtIndex:indexPath.row];
    cell.formLabel.text = [NSString stringWithFormat:@"%@", form.name];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentForm = [self.formsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Entries" sender:self];
}

#pragma mark - IBAction

- (IBAction)actionSheetButtonPressed:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *button0 = [UIAlertAction actionWithTitle:@"Settings"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        UIViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
                                                        [self.navigationController pushViewController:settingsVC animated:YES];
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
                                                        [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Entries"]) {
        EntriesViewController *entriesVC = [segue destinationViewController];
        [entriesVC setForm:self.currentForm];
    }
}

- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

@end
