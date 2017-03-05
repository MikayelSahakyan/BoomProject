//
//  EntryTableViewCell.h
//  BoomProject
//
//  Created by User ACA on 2/26/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextView *valueTextView;

+ (CGFloat)heightForKey:(NSString *)keyText;
+ (CGFloat)heightForValue:(NSString *)valueText;

@end
