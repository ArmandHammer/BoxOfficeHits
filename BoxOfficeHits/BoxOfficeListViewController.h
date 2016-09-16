//
//  BoxOfficeListViewController.h
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import <UIKit/UIKit.h>
#import "ReviewsTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BoxOfficeListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSURLConnection *connection;
    NSMutableData *receivedData;
}

@property (nonatomic, strong) ReviewsTableViewController *reviewsTableViewController;

@property (nonatomic, readonly, strong) NSMutableArray *boxOfficeMovieList;
-(void)fetchBoxOffice;
@end