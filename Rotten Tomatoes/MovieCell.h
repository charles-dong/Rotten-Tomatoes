//
//  MovieCell.h
//  Rotten Tomatoes
//
//  Created by Charles Dong on 2/5/15.
//  Copyright (c) 2015 Charles Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;

@end
