//
//  MasterViewController.m
//  MovieGuide
//
//  Created by Mary Marielle Miranda on 9/10/15.
//  Copyright (c) 2015 Marielle Miranda. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MovieTableViewCell.h"

#import "Movie.h"
#import "Reachability.h"

static NSString * const kUrlMovieMetadata = @"https://dl.dropboxusercontent.com/u/5624850/movielist/list_movies_page1.json";

@interface MasterViewController () <NSURLConnectionDelegate>

#pragma mark - Properties
@property (strong, nonatomic) NSMutableArray *movies;

@property (strong, nonatomic) NSURLConnection *urlConnection;
@property (strong, nonatomic) NSMutableData *mutableData;

@end

@implementation MasterViewController

#pragma mark - Synthesizer
@synthesize movies = _movies;

#pragma mark - Overridden Getter
- (NSMutableArray *)movies {
    if (_movies == nil) {
        _movies = @[].mutableCopy;
    }
    
    return _movies;
}

#pragma mark - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self fetchMovieListWebService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Service
/*
 This method is for creating a web service connection to fetch movie metadata
 */
- (void)fetchMovieListWebService {
    NetworkStatus reachable=[[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    if(reachable == NotReachable) {
        UIAlertView *alertNoConnection = [[UIAlertView alloc]initWithTitle:@"MovieGuide" message:@"Internet connection is required to use this app." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertNoConnection show];
        
        return;
    }
    
    self.urlConnection = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kUrlMovieMetadata]];
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [self.refreshControl beginRefreshing];
}

#pragma mark - Private
/*
 This method is for downloading of cover image on the background thread
 of the given Movie and DetailViewController instances
 */
- (void)downloadCoverImageOfController: (DetailViewController *)controller withMovie: (Movie*)movie {
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        NSURL *urlCover = [NSURL URLWithString:[NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/5624850/movielist/images/%@-cover.jpg", movie.movieSlug]];
        NSData *imageData = [NSData dataWithContentsOfURL:urlCover];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            movie.movieCoverImageData = imageData;
            [controller setDetailItem:[self.movies firstObject]];
        });
    });
    
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Movie *movie = self.movies[indexPath.row];
    
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:movie];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        if (movie.movieCoverImageData == nil) {
            //For downloading of cover image of movie data
            [self downloadCoverImageOfController:controller withMovie:movie];
        }
    }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
    Movie *movie = self.movies[indexPath.row];
    [cell customizeCellWithMovie:movie];
    
    if (movie.movieBackdropImageData == nil) {
        cell.backdropImageView.image = [UIImage imageNamed:@"placeholder"];
    } else {
        UIImage *convertedImage = [[UIImage alloc] initWithData:movie.movieBackdropImageData];
        cell.backdropImageView.image = convertedImage;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.mutableData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.refreshControl endRefreshing];
    [self.refreshControl removeFromSuperview];
    
    if (self.mutableData != nil) {
        id parsedMetaData = [NSJSONSerialization JSONObjectWithData:self.mutableData options:NSJSONReadingAllowFragments error:nil];
        
        if (![parsedMetaData isKindOfClass:[NSDictionary class]]) {
            UIAlertView *alertParsingError = [[UIAlertView alloc]initWithTitle:@"MovieGuide" message:@"Internal server error occured." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alertParsingError show];
            
            return;
        }
        
        NSArray *parsedMoviesArray = parsedMetaData[@"data"][@"movies"];
        
        [parsedMoviesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *movieDetailsDictionary = obj;
            
            Movie *movie = [[Movie alloc]initWithDictionary:movieDetailsDictionary];
            [self.movies addObject:movie];
            
            //For downloading of backdrop image of movie data
            dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(q, ^{
                NSURL *urlBackdrop = [NSURL URLWithString:[NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/5624850/movielist/images/%@-backdrop.jpg", movie.movieSlug]];
                NSData *imageData = [NSData dataWithContentsOfURL:urlBackdrop];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    movie.movieBackdropImageData = imageData;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.movies indexOfObject:movie] inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                });
            });
            
            //for loading default values on iPad (first load)
            if ([self.movies indexOfObject:movie] == 0) {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    if (movie.movieCoverImageData == nil) {
                        [self downloadCoverImageOfController:self.detailViewController withMovie:movie];
                    }
                }
            }
        }];
        
        [self.detailViewController setDetailItem:[self.movies firstObject]];
        [self.tableView reloadData];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alertConnectionError = [[UIAlertView alloc]initWithTitle:@"MovieGuide" message:@"Error in establishing connection to the server." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alertConnectionError show];
}

@end
