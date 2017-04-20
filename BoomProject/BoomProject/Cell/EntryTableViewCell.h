//
//  EntryTableViewCell.h
//  BoomProject
//
//  Created by User ACA on 2/26/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryTableViewCell : UITableViewCell ///<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextView *valueTextView;
@property (strong, nonatomic) NSMutableDictionary *dictionary;

+ (CGFloat)heightForKey:(NSString *)keyText width:(CGFloat)width;
+ (CGFloat)heightForValue:(NSString *)valueText width:(CGFloat)width;

@end
