//
//  EntryViewController.h
//  BoomProject
//
//  Created by User ACA on 2/26/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry+CoreDataClass.h"

@interface EntryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Entry *entry;
@property (strong, nonatomic) NSArray *rowsArray;

@end
