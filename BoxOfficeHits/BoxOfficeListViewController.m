//
//  BoxOfficeListViewController.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "BoxOfficeListViewController.h"
#import "BOHMovieItem.h"
#import "ReviewsTableViewController.h"
#import "SingletonMoviesNearMe.h"
#import "BOHCustomCell.h"

@implementation BoxOfficeListViewController

@synthesize boxOfficeMovieList;
@synthesize reviewsTableViewController;

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {
        //prepare the array of movies
        boxOfficeMovieList = [[NSMutableArray alloc] init];
    }
    
    //get tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    //give it a label
    [tbi setTitle:@"Box Office"];
    [self.navigationItem setTitle:@"Top Grossing"];

    //create the UIImage from file
    UIImage *i = [UIImage imageNamed:@"graph_bar_trend.png"];
    [tbi setImage:i];
    
    [self fetchBoxOffice];
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [boxOfficeMovieList count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Connection received output");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    NSLog(@"Connection is receiving data.");
    //As data is coming in, network indicator is turned on
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [receivedData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    //finished loading, turn network indicator off
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    NSLog(@"Success! Received %d bytes of data.", [receivedData length]);
    
    NSError* error;
    //parse json
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:receivedData
                          options:kNilOptions
                          error:&error];
    
    //array of all movies in top box office
    NSArray* movies = [json objectForKey:@"movies"];
    
    //pull the movies near me list from singleton class
    SingletonMoviesNearMe *moviesToCompare = [SingletonMoviesNearMe sharedArray];
    NSArray *moviesNear = [NSArray arrayWithArray:[moviesToCompare singletonMoviesNearMe]];
    
    //parse through movies array and store each movie as a BOHMovieItem
    for (NSDictionary *movie in movies)
    {
        BOOL moviePlayingNearMe = NO;
        BOOL moviePlayingNearMeIsThreeD = NO;
        NSString *title = [NSString stringWithFormat:@"%@",[movie objectForKey:@"title"] ];
        NSString *titleInThreeD = [NSString stringWithFormat:@"%@ 3D",title];
        
        for (int i=0; i<[moviesNear count]; i++)
        {
            //do comparison
            NSString *titleToCompareTo = [NSString stringWithFormat:@"%@", [moviesNear objectAtIndex:i]];
            
            if ([titleToCompareTo isEqualToString:titleInThreeD])
            {
                NSLog(@"Found a 3D film: %@", titleToCompareTo);
                moviePlayingNearMe = YES;
                moviePlayingNearMeIsThreeD = YES;
                break;
            }
            else if ([titleToCompareTo isEqualToString:title])
            {
                moviePlayingNearMe = YES;
                break;
            }
        }
        
        if (moviePlayingNearMe)
        {
            //create BOHMovieItem element
            BOHMovieItem *item = [[BOHMovieItem alloc] init];
            //create dictionary that holds ratings
            NSDictionary *ratings = [movie objectForKey:@"ratings"];
            NSString *RTCScore = [NSString stringWithFormat:@"%@",[ratings objectForKey:@"critics_score"]];
            
            item.title = title;
            if (moviePlayingNearMeIsThreeD)
            {
                item.isThreeD = YES;
            }
            item.RTCriticScore = RTCScore;
            
            [boxOfficeMovieList addObject:item];
        }
    }

    //reload the table data
    [[self tableView] reloadData];

    //reset connection and data received
    connection = nil;
    receivedData = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier=[NSString stringWithFormat:@"BoxOfficeListCell"];
    UITableViewCell *aCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //initialize cell
    if (aCell == nil)
    {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
        BOHCustomCell *customCell=[[BOHCustomCell alloc] init];
        customCell.tag=101;
        [aCell.contentView addSubview:customCell];
    }
    BOHCustomCell *customCell=(BOHCustomCell *)[aCell.contentView viewWithTag:101];
    
    //seperators and borders for style
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 2, 55)];
    lineView.backgroundColor = [UIColor blackColor];
    [customCell addSubview:lineView];
    customCell.scoreLabel.layer.borderColor = [[UIColor redColor]CGColor];
    customCell.scoreLabel.layer.borderWidth =1.5;
    
    //grab appropriate item
    BOHMovieItem *item = [boxOfficeMovieList objectAtIndex:[indexPath row]];
    NSString *score = [NSString stringWithFormat:@"%@", [item RTCriticScore]];
    [customCell.titleLabel setText:[item title]];  //set movie title
    [customCell.rankLabel setText: [NSString stringWithFormat:@"%i", indexPath.row+1]];
    [customCell.scoreLabel setText:score]; //set critic score
    return customCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[cell setBackgroundColor:[UIColor clearColor]];
    
    //grab appropriate item
    BOHMovieItem *item = [boxOfficeMovieList objectAtIndex:[indexPath row]];
    
    if ([item.RTCriticScore intValue] > 80)
    {
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:250.0/255.0
                                                                     green:194.0/255.0 blue:0 alpha:1.0] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:102.0/255.0 alpha:1.0] CGColor], nil];
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    }
    else if ([item.RTCriticScore intValue] >50)
    {
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:192.0/255.0
                                                                     green:192.0/255.0 blue:192.0/255.0 alpha:1.0] CGColor],
                       (id)[[UIColor colorWithRed:158.0/255.0 green:160.0/255.0 blue:161.0/255.0 alpha:1.0] CGColor], nil];
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    }
    else
    {
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:205.0/255.0
                                                                     green:127.0/255.0 blue:50.0/255.0 alpha:1.0] CGColor],
                       (id)[[UIColor colorWithRed:73.0/255.0 green:59.0/255.0 blue:47.0/255.0 alpha:1.0] CGColor], nil];
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error
{
    // Release the connection object, we're done with it
    connection = nil;
    receivedData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Connection Failed: %@",
                             [error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}

-(void)fetchBoxOffice
{
    NSLog(@"CURRENTLY FETCHING ADDRESS.");
    //while it's fetching the address, indicator should be on
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    //the http request
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=angeek99xyn28dreary76xa7&limit=50";
    
    // Create a new data container for the stuff that comes back from the service
    receivedData = [NSMutableData dataWithCapacity:0];
    
    // Construct a URL that will ask the service for what you want -
    // note we can concatenate literal strings together on multiple
    // lines in this way - this results in a single NSString instance
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[ NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    
    // Create a connection that will exchange this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:YES];
}

@end
