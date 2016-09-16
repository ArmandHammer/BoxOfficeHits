//
//  UserMovieListViewController.h
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import <UIKit/UIKit.h>
#import "ReviewsTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface UserMovieListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ReviewsTableViewController *reviewsTableViewController;
@property (nonatomic, readonly, strong) NSArray *userMovieList;

@end
