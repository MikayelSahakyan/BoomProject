//
//  EntriesViewController.m
//  BoomProject
//
//  Created by User ACA on 2/22/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "EntriesViewController.h"
#import "EntriesTableViewCell.h"
#import "EntryViewController.h"
#import "ServiceManager.h"
#import "DataManager.h"
#import "ServiceObject+CoreDataClass.h"
#import "Entry+CoreDataClass.h"
#import "Row+CoreDataClass.h"

@interface EntriesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *entriesArray;
@property (assign, nonatomic) double lastEntryID;
@property (strong, nonatomic) Entry *currentEntry;
@property (strong, nonatomic) NSMutableArray *currentEntryArray;
@property (strong, nonatomic) NSMutableArray *sendedEntryArray;

@end

@implementation EntriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = self.form.name;
    
    self.entriesArray = [NSMutableArray array];
    self.currentEntryArray = [NSMutableArray array];
    self.sendedEntryArray = [NSMutableArray array];
    self.lastEntryID = 0;
    [self getEntriesFromCoreData];
    //[self getEntriesFromServer];
}

#pragma mark - CoreData

- (void)getEntriesFromCoreData {
    [[DataManager sharedManager] printAllObjects];
    NSArray *entries = [[DataManager sharedManager] allEntriesFromForm:self.form];
    [self.entriesArray addObjectsFromArray:entries];
    [self.tableView reloadData];
    [self getEntriesFromServer];
}

#pragma mark - API

- (void)getEntriesFromServer {
    //[[DataManager sharedManager] printAllEntries];
    [[ServiceManager sharedManager] getEntriesWithUserToken:@"david"
                                            fromCurrentForm:self.form
                                                lastEntryID:self.lastEntryID
                                                  onSuccess:^(NSArray *entries) {
                                                      [self.entriesArray addObjectsFromArray:entries];
                                                      [self.tableView reloadData];
                                                      
                                                      if ([self.entriesArray count] >= 10) {
                                                          Entry *lastEntry = self.entriesArray[([self.entriesArray count] - 1)];
                                                          self.lastEntryID = lastEntry.entryID;
                                                      }
                                                  }
                                                  onFailure:^(NSError *error, NSInteger statusCode) {
                                                      NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
                                                  }];
}

- (void)removeEntry:(Entry *)entry {
    [[ServiceManager sharedManager] removeEntryWithUserToken:@"david"
                                           andRemovedEntryID:entry.entryID
                                                   onSuccess:^(id result) {
                                                       //
                                                   }
                                                   onFailure:^(NSError *error, NSInteger statusCode) {
                                                       //
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
    return [self.entriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell" forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// Remove entry from tableview with swipe to delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Entry *removedEntry = [self.entriesArray objectAtIndex:indexPath.row];
        [self removeEntry:removedEntry];
        [self.entriesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentEntry = self.entriesArray[indexPath.row];
    [self performSegueWithIdentifier:@"Entry" sender:self];
}

// Load more entries
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.entriesArray count] - 1) {
        if ([self.entriesArray count] % 10 == 0) {
            [self getEntriesFromServer];
        }
    }
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

- (void)configureCell:(EntriesTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Entry *entry = self.entriesArray[indexPath.row];
    NSArray *array = entry.rows.allObjects;
    NSSortDescriptor *indexDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[indexDescriptor]];
    
    for (NSInteger i = 0; i < [sortedArray count]; i ++) {
        Row *row = sortedArray[i];
        
        switch (i) {
            case 0:
                cell.nameLabel.text = row.key;
                cell.nameValueLabel.text = row.value;
                break;
            case 1:
                cell.emailLabel.text = row.key;
                cell.emailValueLabel.text = row.value;
                break;
            case 2:
                cell.commentLabel.text = row.key;
                cell.commentValueLabel.text = row.value;
                break;
            case 3:
                cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                                       [Entry relativeDateStringForDate:[self changeStringToDate:entry.date]]];
                break;
            default:
                break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Entry"]) {
        EntryViewController *entryVC = [segue destinationViewController];
        [entryVC setEntry:self.currentEntry];
    }
}

- (NSDate *)changeStringToDate:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *entryDate = [NSDate date];
    entryDate = [dateFormatter dateFromString:date];
    return entryDate;
}

@end
