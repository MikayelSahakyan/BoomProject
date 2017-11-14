//
//  EntriesTableViewCell.m
//  BoomProject
//
//  Created by User ACA on 2/24/17.
//  Copyright © 2017 Mikayel Sahakyan. All rights reserved.
//

#import "EntriesTableViewCell.h"

@implementation EntriesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.text = @"";
    self.nameValueLabel.text = @"";
    self.emailLabel.text = @"";
    self.emailValueLabel.text = @"";
    self.commentLabel.text = @"";
    self.commentValueLabel.text = @"";
    self.dateLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.nameLabel.text = @"";
    self.nameValueLabel.text = @"";
    self.emailLabel.text = @"";
    self.emailValueLabel.text = @"";
    self.commentLabel.text = @"";
    self.commentValueLabel.text = @"";
    self.dateLabel.text = @"";
}

@end
