//
//  EntryViewController.h
//  BoomProject
//
//  Created by User ACA on 2/26/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *entryID;
@property (strong, nonatomic) NSString *entryDate;
@property (strong, nonatomic) NSMutableArray *entryArray;

@end
