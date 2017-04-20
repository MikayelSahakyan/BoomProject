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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    self.nameLabel.text = @"";
    self.nameValueLabel.text = @"";
    self.emailLabel.text = @"";
    self.emailValueLabel.text = @"";
    self.commentLabel.text = @"";
    self.commentValueLabel.text = @"";
    self.dateLabel.text = @"";
}

@end
