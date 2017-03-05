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
#import "Entry.h"

@interface EntryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *composeBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancleBarButtonItem;
@property (strong, nonatomic) NSMutableArray *toolbarButtons;
@property (assign, nonatomic) BOOL isEditable;

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = self.entryDate;
    
    self.toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    [self.toolbarButtons removeObject:self.saveBarButtonItem];
    [self.toolbarButtons removeObject:self.cancleBarButtonItem];
    [self.navigationItem setRightBarButtonItems:self.toolbarButtons animated:YES];
    
    self.isEditable = NO;
}

#pragma mark - API

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell" forIndexPath:indexPath];
    Entry *entry = [self.entryArray objectAtIndex:indexPath.row];
    cell.keyLabel.text = [NSString stringWithFormat:@"%@:", entry.key];
    cell.valueTextView.text = [NSString stringWithFormat:@"%@", entry.value];
    
    if (self.isEditable) {
        cell.valueTextView.editable = YES;
        [cell.valueTextView setTextColor:[UIColor grayColor]];
    } else {
        cell.valueTextView.editable = NO;
        [cell.valueTextView setTextColor:[UIColor blackColor]];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Entry *entry = [self.entryArray objectAtIndex:indexPath.row];
    return MAX([EntryTableViewCell heightForKey:entry.key], [EntryTableViewCell heightForValue:entry.value]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

#pragma mark - IBAction

- (IBAction)composeButtonPressed:(id)sender {
    [self hideComposeButton];
    self.isEditable = YES;
    [self.tableView reloadData];
}

- (IBAction)saveButtonPressed:(id)sender {
    [self showComposeButton];
    self.isEditable = NO;
    [self.tableView reloadData];
}

- (IBAction)cancleButtonPressed:(id)sender {
    [self showComposeButton];
    self.isEditable = NO;
    [self.tableView reloadData];
}

#pragma mark -

- (void)hideComposeButton {
    if (!([self.toolbarButtons containsObject:self.saveBarButtonItem] && [self.toolbarButtons containsObject:self.cancleBarButtonItem])) {
        [self.toolbarButtons removeObject:self.composeBarButtonItem];
        [self.toolbarButtons addObject:self.cancleBarButtonItem];
        [self.toolbarButtons addObject:self.saveBarButtonItem];
        [self.navigationItem setRightBarButtonItems:self.toolbarButtons animated:YES];
    }
}

- (void)showComposeButton {
    if (![self.toolbarButtons containsObject:self.composeBarButtonItem]) {
        [self.toolbarButtons removeAllObjects];
        [self.toolbarButtons addObject:self.composeBarButtonItem];
        [self.navigationItem setRightBarButtonItems:self.toolbarButtons animated:YES];
    }
}

@end
