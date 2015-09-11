//
//  Movie.m
//  MovieGuide
//
//  Created by Mary Marielle Miranda on 9/10/15.
//  Copyright (c) 2015 Marielle Miranda. All rights reserved.
//

#import "Movie.h"

static NSString * const kIdKey = @"id";
static NSString * const kTitleKey = @"title";
static NSString * const kTitleLongKey = @"title_long";
static NSString * const kRatingKey = @"rating";
static NSString * const kGenresKey = @"genres";
static NSString * const kLanguageKey = @"language";
static NSString * const kUrlKey = @"url";
static NSString * const kImdbCodeKey = @"imdb_code";
static NSString * const kStateKey = @"state";
static NSString * const kYearKey = @"year";
static NSString * const kRuntimeKey = @"runtime";
static NSString * const kOverviewKey = @"overview";
static NSString * const kSlugKey = @"slug";
static NSString * const kMpaRatingKey = @"mpa_rating";

@implementation Movie

#pragma mark - Initializer
- (Movie *)initWithDictionary: (NSDictionary *)detailsDictionary {
    self = [super init];
    if (self) {
        self.movieId = detailsDictionary[kIdKey];
        self.movieTitle = detailsDictionary[kTitleKey];
        self.movieTitleLong = detailsDictionary[kTitleLongKey];
        self.movieRating = [detailsDictionary[kRatingKey] floatValue];
        self.movieGenres = detailsDictionary[kGenresKey];
        self.movieLanguage = detailsDictionary[kLanguageKey];
        self.movieUrl = [NSURL URLWithString:detailsDictionary[kUrlKey]];
        self.movieImdbCode = detailsDictionary[kImdbCodeKey];
        self.movieState = detailsDictionary[kStateKey];
        self.movieYear = [detailsDictionary[kYearKey] intValue];
        self.movieRuntime = [detailsDictionary[kRuntimeKey] intValue];
        self.movieOverview = detailsDictionary[kOverviewKey];
        self.movieSlug = detailsDictionary[kSlugKey];
        self.movieMpaRating = detailsDictionary[kMpaRatingKey];
    }
    
    return self;
}

@end
