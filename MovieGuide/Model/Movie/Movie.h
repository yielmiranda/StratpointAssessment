//
//  Movie.h
//  MovieGuide
//
//  Created by Mary Marielle Miranda on 9/10/15.
//  Copyright (c) 2015 Marielle Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

#pragma mark - Properties
@property (strong, nonatomic) NSString *movieId;
@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) NSString *movieTitleLong;
@property (nonatomic) float movieRating;
@property (strong, nonatomic) NSArray *movieGenres;
@property (strong, nonatomic) NSString *movieLanguage;
@property (strong, nonatomic) NSURL *movieUrl;
@property (strong, nonatomic) NSString *movieImdbCode;
@property (strong, nonatomic) NSString *movieState;
@property (nonatomic) int movieYear;
@property (nonatomic) int movieRuntime;
@property (strong, nonatomic) NSString *movieOverview;
@property (strong, nonatomic) NSString *movieSlug;
@property (strong, nonatomic) NSString *movieMpaRating;

@property (strong, nonatomic) NSData *movieCoverImageData;
@property (strong, nonatomic) NSData *movieBackdropImageData;

#pragma mark - Initializer
- (Movie *)initWithDictionary: (NSDictionary *)detailsDictionary;

@end
