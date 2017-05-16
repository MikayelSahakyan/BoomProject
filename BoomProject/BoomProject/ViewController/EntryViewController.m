//
//  EntryViewController.m
//  BoomProject
//
//  Created by User ACA on 2/26/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "EntryViewController.h"
#import "EntryTableViewCell.h"
#import "ServiceManager.h"
#import "Entry+CoreDataClass.h"
#import "Row+CoreDataClass.h"
#import "RowEditingViewController.h"

@interface EntryViewController () <DataEnteredDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *rowsArray;
@property (strong, nonatomic) Row *selectedRow;
@property (assign, nonatomic) BOOL isEditable;

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = self.entry.date;
    
    NSArray *rows = [self getRowsArrayFromEntry];
    self.rowsArray = [NSMutableArray array];
    [self.rowsArray addObjectsFromArray:rows];
    [self viewDidLayoutSubviews];
    
    self.isEditable = NO;
}

#pragma mark - API

- (void)sendChangedEntryToServer {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[ServiceManager sharedManager] updateEntryWithUserToken:token
                                              changedEntryID:self.entry.entryID
                                                    andRowID:self.selectedRow.rowID
                                                  editedText:self.selectedRow.value
                                                   onSuccess:^(id result) {
                                                       //
                                                   }
                                                   onFailure:^(NSError *error, NSInteger statusCode) {
                                                       //
                                                   }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rowsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell" forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)getKeyLabelWidth {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = (screenWidth - 12) / 3;
    return width;
}

- (CGFloat)getValueLabelWidth {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = screenWidth - [self getKeyLabelWidth] - 40;
    return width;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Row *row = self.rowsArray[indexPath.row];
    CGFloat keyWidth = [self getKeyLabelWidth];
    CGFloat valueWidth = [self getValueLabelWidth];
    CGFloat heightForKey = [EntryTableViewCell heightForKey:row.key width:keyWidth];
    CGFloat heightForValue = [EntryTableViewCell heightForValue:row.value width:valueWidth];
    return MAX(heightForKey, heightForValue);// + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedRow = self.rowsArray[indexPath.row];
    [self performSegueWithIdentifier:@"Row" sender:self];
}

#pragma mark - IBAction

#pragma mark -

- (NSArray *)getRowsArrayFromEntry {
    NSArray *arrayOfRows = self.entry.rows.allObjects;
    NSSortDescriptor *indexDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    NSArray *sortedArray = [arrayOfRows sortedArrayUsingDescriptors:@[indexDescriptor]];
    return sortedArray;
}

- (void)configureCell:(EntryTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Row *row = self.rowsArray[indexPath.row];
    
    cell.keyLabel.text = [NSString stringWithFormat:@"%@:", row.key];
    cell.valueTextView.text = row.value;
    
    if (self.isEditable) {
        cell.valueTextView.editable = YES;
        [cell.valueTextView setTextColor:[UIColor grayColor]];
    } else {
        cell.valueTextView.editable = NO;
        [cell.valueTextView setTextColor:[UIColor blackColor]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Row"]) {
        RowEditingViewController *editVC = [segue destinationViewController];
        editVC.delegate = self;
        [editVC setRow:self.selectedRow];
    }
}

- (void)changedRow:(Row *)row {
    self.selectedRow = row;
    [self.rowsArray replaceObjectAtIndex:(self.selectedRow.index - 1) withObject:self.selectedRow];
    [self.tableView reloadData];
    [self sendChangedEntryToServer];
}

@end
