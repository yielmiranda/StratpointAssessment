//
//  MovieTableViewCell.m
//  MovieGuide
//
//  Created by Mary Marielle Miranda on 9/10/15.
//  Copyright (c) 2015 Marielle Miranda. All rights reserved.
//

#import "MovieTableViewCell.h"

@interface MovieTableViewCell ()

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end

@implementation MovieTableViewCell

#pragma mark - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public
/*
 This method is for updating the cell's interface with the given Movie instance
*/
- (void)customizeCellWithMovie: (Movie *)movie {
    self.titleLabel.text = movie.movieTitle;
    self.yearLabel.text = [NSString stringWithFormat:@"%d", movie.movieYear];
}

@end
