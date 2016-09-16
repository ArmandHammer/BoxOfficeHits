//
//  ReviewsTableViewController.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "ReviewsTableViewController.h"
#import "SingletonID.h"
#import "BOHCriticItem.h"
#import "BOHCustomCriticCellTableViewCell.h"

@implementation ReviewsTableViewController
@synthesize reviewsList, reviewID, criticWebViewController;
NSString *rtkey = @"angeek99xyn28dreary76xa7";
BOOL reviewsRetreived = NO;
NSString *currentID;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        reviewsList = [[NSMutableArray alloc] init];
        [self setTitle:@"Reviews"]; //set new title
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //pull the appropriate movie ID from singleton class
    SingletonID *reviews = [SingletonID sharedID];
    reviewID = [reviews movieID];
    if (![currentID isEqualToString:reviewID])
    {
        currentID = reviewID;
        [reviewsList removeAllObjects];
        [self fetchReviews];
    }
    [[self tableView] setContentOffset:CGPointZero animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier=[NSString stringWithFormat:@"ReviewListCell"];
    UITableViewCell *aCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //initialize cell
    if (aCell == nil)
    {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
        BOHCustomCriticCellTableViewCell *customCell=[[BOHCustomCriticCellTableViewCell alloc] init];
        customCell.tag=301;
        [aCell.contentView addSubview:customCell];
    }
    BOHCustomCriticCellTableViewCell *customCell=(BOHCustomCriticCellTableViewCell *)[aCell.contentView viewWithTag:301];
    
    //grab appropriate item
    BOHCriticItem *item = [reviewsList objectAtIndex:[indexPath row]];
    //set values
    NSString *score = [NSString stringWithFormat:@"%@", [item criticScore]];
    NSString *quote = [NSString stringWithFormat:@"'%@'", [item criticQuote]];
    NSString *date = [NSString stringWithFormat:@"%@", [item criticDate]];
    NSString *name = [NSString stringWithFormat:@"%@", [item criticName]];
    NSString *pub = [NSString stringWithFormat:@"%@", [item criticPublication]];
    
    [customCell.criticName setText:name];  //set critic name
    [customCell.criticScore setText:score];  //set score
    [customCell.criticQuote setText:quote]; //set critic review quote
    [customCell.criticDate setText:date]; //set critic date
    [customCell.criticPublication setText:pub]; //set critic date


    return customCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = cell.bounds;
    grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:250.0/255.0
                                                                 green:194.0/255.0 blue:0 alpha:1.0] CGColor],
                   (id)[[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:102.0/255.0 alpha:1.0] CGColor], nil];
    [cell setBackgroundView:[[UIView alloc] init]];
    [cell.backgroundView.layer insertSublayer:grad atIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [reviewsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOHCriticItem *item = [reviewsList objectAtIndex:[indexPath row]];
    NSString *urlPath = [NSString stringWithFormat:@"%@",[item criticLink]];
    //Construct a URL with the link string of the item
    NSURL *url = [NSURL URLWithString:urlPath];
    
    // Construct a request object with that URL
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Load the request into the web view
    [[criticWebViewController webView] loadRequest:req];
    
    // Push the web view controller onto the navigation stack - this implicitly
    // creates the web view controller's view the first time through
    [[self navigationController] pushViewController:criticWebViewController animated:YES];
}

-(void)fetchReviews
{
    NSLog(@"CURRENTLY FETCHING REVIEWS.");
    //while it's fetching the address, indicator should be on
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    //request to RT for movie reviews
    NSString *url = [NSString stringWithFormat: @"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/reviews.json?apikey=%@&page_limit=50",reviewID, rtkey];
    NSURL *webURL = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSError *error;
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (returnData)
    {
        NSLog(@"Accessed Reviews from RT! Received %d bytes of data.", [returnData length]);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        
        NSError* error;
        //parse json
        NSDictionary* json = [NSJSONSerialization
                         JSONObjectWithData:returnData
                         options:kNilOptions
                         error:&error];
        
        //array of all reviews
        NSArray* allReviews = [json objectForKey:@"reviews"];

        for (NSDictionary *reviews in allReviews)
        {
            BOHCriticItem *item = [[BOHCriticItem alloc] init];
            //create dictionary for the review website link
            NSDictionary *reviewLink = [reviews objectForKey:@"links"];
            
            item.criticName = [reviews objectForKey:@"critic"];
            item.criticDate = [reviews objectForKey:@"date"];
            item.criticLink = [reviewLink objectForKey:@"review"];
            item.criticQuote = [reviews objectForKey:@"quote"];
            item.criticScore = [reviews objectForKey:@"original_score"];
            item.criticPublication = [reviews objectForKey:@"publication"];

            if (item.criticScore == nil)
            {
                item.criticScore = @"N/A";
            }
            
            [reviewsList addObject:item];
        }
    }
    
    //reload table
    [[self tableView] reloadData];
}


@end
