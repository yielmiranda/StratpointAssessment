//
//  MovieTableViewCell.h
//  MovieGuide
//
//  Created by Mary Marielle Miranda on 9/10/15.
//  Copyright (c) 2015 Marielle Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieTableViewCell : UITableViewCell

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;

#pragma mark - Public
- (void)customizeCellWithMovie: (Movie *)movie;

@end
