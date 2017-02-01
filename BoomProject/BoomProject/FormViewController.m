//
//  FormViewController.m
//  BoomProject
//
//  Created by User ACA on 1/29/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "FormViewController.h"
#import "FormTableViewCell.h"

@interface FormViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0 green:0.588 blue:0.875 alpha:1];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell) {
        NSLog(@"cell reused");
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
