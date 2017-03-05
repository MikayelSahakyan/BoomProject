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
#import "Entry.h"

@interface EntriesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *entriesArray;
@property (strong, nonatomic) Entry *lastEntry;
@property (strong, nonatomic) Entry *sendedEntry;
@property (strong, nonatomic) NSMutableArray *currentEntryArray;
@property (strong, nonatomic) NSMutableArray *sendedEntryArray;

@end

@implementation EntriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = self.formName;
    
    self.entriesArray = [NSMutableArray array];
    self.currentEntryArray = [NSMutableArray array];
    self.sendedEntryArray = [NSMutableArray array];
    self.lastEntry = [[Entry alloc] init];
    self.sendedEntry = [[Entry alloc] init];
    self.lastEntry.ID = @"0";
    
    [self getEntriesFromServer];
}

#pragma mark - API

- (void)getEntriesFromServer {
    [[ServiceManager sharedManager] getEntriesWithUserToken:@"david"
                                                  andFormID:self.formID
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

- (void)removeEntry:(Entry *)entry {
    [[ServiceManager sharedManager] removeEntryWithUserToken:@"david"
                                           andRemovedEntryID:entry.ID
                                                   onSuccess:^(id result) {
                                                       //
                                                   }
                                                   onFailure:^(NSError *error, NSInteger statusCode) {
                                                       //
                                                   }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell" forIndexPath:indexPath];
    
    for (NSInteger i = 0; i < 4; i++) {
        Entry *entry = [[self.entriesArray objectAtIndex:indexPath.row] objectAtIndex:i];
        
        switch (i) {
            case 0:
                cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                                       [Entry relativeDateStringForDate:[self changeStringToDate:entry.date]]];
                break;
                case 1:
                cell.nameLabel.text = [NSString stringWithFormat:@"%@:", entry.key];
                cell.nameValueLabel.text = [NSString stringWithFormat:@"%@", entry.value];
                break;
                case 2:
                cell.emailLabel.text = [NSString stringWithFormat:@"%@:", entry.key];
                cell.emailValueLabel.text = [NSString stringWithFormat:@"%@", entry.value];
                break;
                case 3:
                cell.commentLabel.text = [NSString stringWithFormat:@"%@:", entry.key];
                cell.commentValueLabel.text = [NSString stringWithFormat:@"%@", entry.value];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// Remove entry from tableview with swipe to delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Entry *removedEntry = [[self.entriesArray objectAtIndex:indexPath.row] objectAtIndex:0];
        [self removeEntry:removedEntry];
        [self.entriesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.currentEntryArray addObjectsFromArray:[self.entriesArray objectAtIndex:indexPath.row]];
    self.sendedEntry = [self.currentEntryArray objectAtIndex:0];
    [self.sendedEntryArray removeAllObjects];
    NSInteger length = [self.currentEntryArray indexOfObject:[self.currentEntryArray lastObject]];
    [self.sendedEntryArray addObjectsFromArray:[self.currentEntryArray subarrayWithRange:NSMakeRange(1, length)]];
    [self.currentEntryArray removeAllObjects];
    [self performSegueWithIdentifier:@"Entry" sender:self];
}
// Load more entries
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.entriesArray count] - 1) {
        if ([self.entriesArray count] >= 10) {
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
    
    if ([[segue identifier] isEqualToString:@"Entry"]) {
        EntryViewController *sendedEntryVC = [segue destinationViewController];
        [sendedEntryVC setEntryArray:self.sendedEntryArray];
        [sendedEntryVC setEntryDate:self.sendedEntry.date];
        [sendedEntryVC setEntryID:self.sendedEntry.ID];
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
