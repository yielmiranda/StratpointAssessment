//
//  MasterViewController.h
//  MovieGuide
//
//  Created by Mary Marielle Miranda on 9/10/15.
//  Copyright (c) 2015 Marielle Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

#pragma mark - Properties
@property (strong, nonatomic) DetailViewController *detailViewController;

@end