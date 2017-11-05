//
//  RowEditingViewController.h
//  BoomProject
//
//  Created by User ACA on 5/2/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Row+CoreDataClass.h"

@protocol DataEnteredDelegate <NSObject>

- (void)changedRow:(Row *)row;

@end

@interface RowEditingViewController : UIViewController

@property (weak, nonatomic) id <DataEnteredDelegate> delegate;
@property (strong, nonatomic) Row *row;

@end
