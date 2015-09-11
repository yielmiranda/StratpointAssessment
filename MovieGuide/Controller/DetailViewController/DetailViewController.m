//
//  DetailViewController.m
//  MovieGuide
//
//  Created by Mary Marielle Miranda on 9/10/15.
//  Copyright (c) 2015 Marielle Miranda. All rights reserved.
//

#import "DetailViewController.h"
#import "Movie.h"

@interface DetailViewController ()

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearReleasedLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;

@end

@implementation DetailViewController

#pragma mark - Overridden Setter
- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
    
    [self configureView];
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    
    self.coverImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverImageView.layer.shadowOffset = CGSizeMake(0, 1);
    self.coverImageView.layer.shadowOpacity = 1;
    self.coverImageView.layer.shadowRadius = 1.0;
    self.coverImageView.clipsToBounds = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
/*
 This method is for updating the IBOutlet properties every time an instance of DetailItem is being set
*/
- (void)configureView {
    if (self.detailItem) {
        Movie *movie = (Movie *)self.detailItem;
        
        self.titleLabel.text = movie.movieTitle;
        self.yearReleasedLabel.text = [NSString stringWithFormat:@"%d", movie.movieYear];
        self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", movie.movieRating];
        self.overviewTextView.text = movie.movieOverview;
        
        if (movie.movieCoverImageData) {
            self.coverImageView.image = [UIImage imageWithData:movie.movieCoverImageData];
        }
        
        if (movie.movieBackdropImageData) {
            self.backdropImageView.image = [UIImage imageWithData:movie.movieBackdropImageData];
        }
    }
}

@end
