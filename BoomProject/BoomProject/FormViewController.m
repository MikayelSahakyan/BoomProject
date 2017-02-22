//
//  FormViewController.m
//  BoomProject
//
//  Created by User ACA on 1/29/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "FormViewController.h"
#import "FormTableViewCell.h"
#import "ServiceManager.h"
#import "FormModel.h"

@interface FormViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *formsArray;

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
    
    [self getFormsFromServer];
}

#pragma mark - API

- (void)getFormsFromServer {
    [[ServiceManager sharedManager] loginWithUserToken:@"david"
                                             onSuccess:^(NSArray *forms) {
                                                 
                                                 [self.formsArray addObjectsFromArray:forms];
                                                 [self.tableView reloadData];
                                                 /*
                                                  NSMutableArray *newPaths = [NSMutableArray array];
                                                  for (NSInteger i = (NSInteger)[self.formsArray count] - (NSInteger)[forms count]; i < [self.formsArray count]; i++) {
                                                  [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                  }
                                                  
                                                  [self.tableView beginUpdates];
                                                  [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                                                  [self.tableView endUpdates];
                                                  */
                                             }
                                             onFailure:^(NSError *error, NSInteger statusCode) {
                                                 NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
                                             }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.formsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.row == [self.formsArray count]) {
        cell.formLabel.text = @"LOAD MORE...";
    } else {
        
        FormModel *form = [self.formsArray objectAtIndex:indexPath.row];
        
        //cell.formLabel.text = [self.formsArray objectAtIndex:indexPath.row];
        
        cell.formLabel.text = [NSString stringWithFormat:@"%@", form.name];
    }
    return cell;
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

- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

@end
