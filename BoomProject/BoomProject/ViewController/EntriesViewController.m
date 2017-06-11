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
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSMutableArray *entriesArray;
@property (assign, nonatomic) double lastEntryID;
@property (strong, nonatomic) Entry *currentEntry;
@property (strong, nonatomic) NSMutableArray *currentEntryArray;
@property (strong, nonatomic) NSMutableArray *sendedEntryArray;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@end

@implementation EntriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = self.form.name;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:0 green:0.588 blue:0.875 alpha:1];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    self.entriesArray = [NSMutableArray array];
    self.currentEntryArray = [NSMutableArray array];
    self.sendedEntryArray = [NSMutableArray array];
    self.lastEntryID = 0;
    [self getEntriesFromCoreData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.notifyEntryID) {
        [self.view insertSubview:self.loadingView aboveSubview:self.tableView];
        [self.loadingView setHidden:NO];
    } else {
        [self.view insertSubview:self.tableView aboveSubview:self.loadingView];
        [self.loadingView setHidden:YES];
    }
}

#pragma mark - CoreData

- (void)getEntriesFromCoreData {
    NSArray *entries = [[DataManager sharedManager] allEntriesFromForm:self.form];
    if (!(entries.count == 0)) {
        Entry *lastEntry = entries.lastObject;
        self.lastEntryID = lastEntry.entryID;
    }
    [self.entriesArray addObjectsFromArray:entries];
    [self.tableView reloadData];
    [self getEntriesFromServer];
}

#pragma mark - API

- (void)getEntriesFromServer {
    [[ServiceManager sharedManager] getEntriesWithUserToken:self.token
                                            fromCurrentForm:self.form
                                                lastEntryID:self.lastEntryID
                                                  onSuccess:^(NSArray *entries) {
                                                      [self.entriesArray addObjectsFromArray:entries];
                                                      [self.tableView reloadData];
                                                      
                                                      if ([self.entriesArray count] >= 10) {
                                                          Entry *lastEntry = self.entriesArray.lastObject;
                                                          self.lastEntryID = lastEntry.entryID;
                                                      }
                                                      
                                                      if (self.notifyEntryID) {
                                                          for (Entry *entry in self.entriesArray) {
                                                              if (entry.entryID == self.notifyEntryID) {
                                                                  [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)entry.index inSection:0]];
                                                              }
                                                          }
                                                          self.notifyEntryID = 0;
                                                      }
                                                  }
                                                  onFailure:^(NSError *error, NSInteger statusCode) {
                                                  }];
}

- (void)updateEntriesWithCompletion:(void (^)())completion {
    [[ServiceManager sharedManager] updateEntriesWithUserToken:self.token
                                               fromCurrentForm:self.form
                                                   lastEntryID:0
                                                     onSuccess:^(NSArray *entries) {
                                                         if (completion) {
                                                             completion();
                                                         }
                                                         [self.entriesArray removeAllObjects];
                                                         [self.entriesArray addObjectsFromArray:entries];
                                                         [self.tableView reloadData];
                                                         
                                                         if ([self.entriesArray count] >= 10) {
                                                             Entry *lastEntry = self.entriesArray.lastObject;
                                                             self.lastEntryID = lastEntry.entryID;
                                                         }
                                                     }
                                                     onFailure:^(NSError *error, NSInteger statusCode) {
                                                         if (completion) {
                                                             completion();
                                                         }
                                                     }];
}

- (void)removeEntry:(Entry *)entry {
    [[ServiceManager sharedManager] removeEntryFromForm:self.form
                                          WithUserToken:self.token
                                      andRemovedEntryID:entry.entryID
                                              onSuccess:^(id result) {
                                                  //
                                              }
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  //
                                              }];
}

- (void)logOut {
    [[ServiceManager sharedManager] logOutWithUserToken:self.token
                                              onSuccess:^(id result) {
                                                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                  [defaults setBool:NO forKey:@"StaySignedIn"];
                                                  [defaults removeObjectForKey:@"token"];
                                                  [self performSegueWithIdentifier:@"LogOutFromEntriesSegue" sender:self];
                                              }
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  [self logOutErrorAlert];
                                              }];
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
        Entry *entryForRemove = [self.entriesArray objectAtIndex:indexPath.row];
        [self removeEntry:entryForRemove];
        [self.entriesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

- (void)configureCell:(EntriesTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Entry *entry = self.entriesArray[indexPath.row];
    NSArray *arrayOfRows = entry.rows.allObjects;
    NSSortDescriptor *indexDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *sortedArrayOfRows = [arrayOfRows sortedArrayUsingDescriptors:@[indexDescriptor]];
    
    for (NSInteger i = 0; i < [sortedArrayOfRows count]; i ++) {
        Row *row = sortedArrayOfRows[i];
        
        switch (i) {
            case 0:
            {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@:", row.key];
                cell.nameValueLabel.text = row.value;
                break;
            }
            case 1:
            {
                cell.emailLabel.text = [NSString stringWithFormat:@"%@:", row.key];
                cell.emailValueLabel.text = row.value;
                break;
            }
            case 2:
            {
                cell.commentLabel.text = [NSString stringWithFormat:@"%@:", row.key];
                cell.commentValueLabel.text = row.value;
                break;
            }
            case 3:
            {
                cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                                       [Entry relativeDateStringForDate:[self changeStringToDate:entry.date]]];
                break;
            }
            default:
                break;
        }
    }
}

- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
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

- (void)refreshTable {
    [self updateEntriesWithCompletion:^{
        [self.refreshControl endRefreshing];
    }];
}

@end
