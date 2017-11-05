//
//  FormViewController.h
//  BoomProject
//
//  Created by User ACA on 1/29/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *notifyFormID;
@property (assign, nonatomic) double notifyEntryID;

@end
