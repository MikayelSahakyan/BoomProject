//
//  EntriesViewController.m
//  BoomProject
//
//  Created by User ACA on 2/22/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "EntriesViewController.h"
#import "EntriesTableViewCell.h"
#import "ServiceManager.h"
#import "EntryModel.h"

@interface EntriesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *entriesArray;
@property (strong, nonatomic) EntryModel *lastEntry;

@end

@implementation EntriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = self.formName;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0 green:0.588 blue:0.875 alpha:1];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.entriesArray = [NSMutableArray array];
    self.lastEntry = [[EntryModel alloc] init];
    self.lastEntry.ID = @"0";
    
    [self getEntriesFromServer];
}

#pragma mark - API

- (void)getEntriesFromServer {
    [[ServiceManager sharedManager] getEntriesWithUserToken:@"david"
                                                  andFormID:self.formID               //@"124971"
                                                lastEntryID:self.lastEntry.ID
                                                  onSuccess:^(NSArray *entries) {
                                                      
                                                      [self.entriesArray addObjectsFromArray:entries];
                                                      [self.tableView reloadData];
                                                      
                                                      if ([self.entriesArray count] >= 10) {
                                                          
                                                          self.lastEntry = [[self.entriesArray objectAtIndex:([self.entriesArray count] - 1)] objectAtIndex:0];
                                                      }
                                                  }
                                                  onFailure:^(NSError *error, NSInteger statusCode) {
                                                      NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
                                                  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.entriesArray count] + 1;
    return [self.entriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell" forIndexPath:indexPath];
    
    /*
    if (indexPath.row == [self.entriesArray count]) {
        cell.textLabel.text = @"LOAD MORE...";
    } else {
        
        EntryModel *entry = [self.entriesArray objectAtIndex:indexPath.row];
            
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", entry.key];
        cell.emailLabel.text = [NSString stringWithFormat:@"%@", entry.key];
        cell.commentLabel.text = [NSString stringWithFormat:@"%@", entry.key];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@", entry.date];
    }
    */
    
    for (NSInteger i = 0; i < 4; i++) {
        
        EntryModel *entry = [[self.entriesArray objectAtIndex:indexPath.row] objectAtIndex:i];
         
        if (i == 0) {
            cell.dateLabel.text = [NSString stringWithFormat:@"%@", entry.date];
        }
        if (i == 1) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@:", entry.key];
            cell.nameValueLabel.text = [NSString stringWithFormat:@"%@", entry.value];
        }
        if (i == 2) {
            cell.emailLabel.text = [NSString stringWithFormat:@"%@:", entry.key];
            cell.emailValueLabel.text = [NSString stringWithFormat:@"%@", entry.value];
        }
        if (i == 3) {
            cell.commentLabel.text = [NSString stringWithFormat:@"%@:", entry.key];
            cell.commentValueLabel.text = [NSString stringWithFormat:@"%@", entry.value];
        }
    }
    
    return cell;
}
/*
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"Entries" sender:self];
}
*/
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Entries"]) {
        //
    }
}

- (void)refreshTable {
    
    if ([self.entriesArray count] >= 10) {
        
        [self getEntriesFromServer];
    }
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

@end
