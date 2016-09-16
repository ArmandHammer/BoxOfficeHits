//
//  CriticMovieListViewController.h
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import <UIKit/UIKit.h>
#import "ReviewsTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BOHMovieItem.h"
#import "QuartzCore/QuartzCore.h"

@interface CriticMovieListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ReviewsTableViewController *reviewsTableViewController;

-(void)fetchRTMovies;
-(void)fetchTMSMovies;
-(void)fetchAdditionalMovieData;
-(void)fetchIMDB:(BOHMovieItem*)movie;

@property (nonatomic, readonly, strong) NSString *dateString;
@property (nonatomic, readonly, strong) NSMutableArray *criticMovieList;
@property (nonatomic, readonly, strong) NSMutableArray *userMovieList;
@property (nonatomic, readonly, strong) NSMutableArray *moviesInTheaterNearMeList;
@property (nonatomic, readonly, strong) NSArray *sortedCriticMovieList;
@property (nonatomic, readonly, strong) NSArray *sortedUserMovieList;


@end
