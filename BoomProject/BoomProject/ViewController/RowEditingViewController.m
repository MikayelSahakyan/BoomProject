//
//  RowEditingViewController.m
//  BoomProject
//
//  Created by User ACA on 5/2/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "RowEditingViewController.h"
#import "EntryViewController.h"

@interface RowEditingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *editRowTextField;

@end

@implementation RowEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = self.row.key;
    self.editRowTextField.text = self.row.value;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.editRowTextField becomeFirstResponder];
}

- (IBAction)sendChangedRow:(id)sender {
    [self.delegate changedRow:sender];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.editRowTextField resignFirstResponder];
    [self.row setValue:textField.text];
    [self sendChangedRow:self.row];
    return YES;
}

@end
