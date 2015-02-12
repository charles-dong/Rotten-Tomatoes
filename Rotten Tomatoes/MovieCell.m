//
//  MovieCell.m
//  Rotten Tomatoes
//
//  Created by Charles Dong on 2/5/15.
//  Copyright (c) 2015 Charles Dong. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.titleLabel.textColor = [UIColor orangeColor];
    } else {
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

@end
