//
//  ReviewsTableViewController.h
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import <UIKit/UIKit.h>
#import "CriticWebViewController.h"

@interface ReviewsTableViewController : UITableViewController

@property (nonatomic, readonly, strong) NSMutableArray *reviewsList;
@property (nonatomic, strong) CriticWebViewController *criticWebViewController;

@property NSString *reviewID;

-(void)fetchReviews;
@end
