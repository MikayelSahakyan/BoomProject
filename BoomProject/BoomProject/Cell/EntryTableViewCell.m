//
//  EntryTableViewCell.m
//  BoomProject
//
//  Created by User ACA on 2/26/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "EntryTableViewCell.h"

@implementation EntryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.valueTextView setTextContainerInset:UIEdgeInsetsMake(8, 0, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.valueTextView setTextContainerInset:UIEdgeInsetsMake(8, 0, 0, 0)];
}

+ (CGFloat)heightForKey:(NSString *)keyText width:(CGFloat)width {
    
    CGFloat offset = 10.0;
    
    UIFont *font = [UIFont systemFontOfSize:18.0];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [keyText boundingRectWithSize:CGSizeMake(width - 2 * offset, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attributes context:nil];
    
    return CGRectGetHeight(rect) + 3 * offset;
}

+ (CGFloat)heightForValue:(NSString *)valueText width:(CGFloat)width {
    
    CGFloat offset = 8.0;
    
    UIFont *font = [UIFont systemFontOfSize:18.0];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [valueText boundingRectWithSize:CGSizeMake(width - 2 * offset, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attributes context:nil];
    
    return CGRectGetHeight(rect) + 4 * offset;
}
 
@end
