//
//  EntriesViewController.h
//  BoomProject
//
//  Created by User ACA on 2/22/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Form+CoreDataClass.h"

@interface EntriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) Form *form;
@property (assign, nonatomic) double notifyEntryID;

@end
