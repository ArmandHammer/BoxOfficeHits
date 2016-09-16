//
//  CriticMovieListViewController.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "CriticMovieListViewController.h"
#import "BOHMovieItem.h"
#import "ReviewsTableViewController.h"
#import "SingletonMoviesNearMe.h"
#import "SingletonID.h"
#import "BOHCustomCell.h"
#import <CoreLocation/CoreLocation.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation CriticMovieListViewController

@synthesize criticMovieList, userMovieList, sortedCriticMovieList, sortedUserMovieList, moviesInTheaterNearMeList;
@synthesize reviewsTableViewController, dateString;

//keys for access to various API
NSString *TMSkey = @"agwepm4yvj8prp57y3dj5yqc";
NSString *RTkey = @"angeek99xyn28dreary76xa7";
NSString *METAkey = @"nxqUJNJXrZ2dHjMN884JXtr7QnUlMGXo";
//location manager
CLLocationManager *locationManager;

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {
        //prepare the array of movies
        criticMovieList = [[NSMutableArray alloc] init];
        userMovieList = [[NSMutableArray alloc] init];
        sortedCriticMovieList = [[NSArray alloc] init];
        sortedUserMovieList = [[NSArray alloc] init];
        moviesInTheaterNearMeList = [[NSMutableArray alloc] init];
    }
    
    [self.navigationItem setTitle:@"Critic Score"];
    
    //get tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    //give it a label
    [tbi setTitle:@"Critics"];
    
    //create the UIImage from file
    UIImage *i = [UIImage imageNamed:@"star.png"];
    [tbi setImage:i];
    
    //retrieves list of movies playing near user
    [self fetchTMSMovies];
    return self;
}

-(void)viewDidLoad
{
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [sortedCriticMovieList count];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOHMovieItem *item = [sortedCriticMovieList objectAtIndex:[indexPath row]];
    //use singleton to share data
    SingletonID *movieID = [SingletonID sharedID];
    movieID.movieID = item.ID;
    
    // Push the description view controller onto the navigation stack - this implicitly
    // creates the description view controller's view the first time through
    [[self navigationController] pushViewController:reviewsTableViewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier=[NSString stringWithFormat:@"CriticMovieListCell"];
    UITableViewCell *aCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //initialize cell
    if (aCell == nil)
    {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        BOHCustomCell *customCell=[[BOHCustomCell alloc] init];
        customCell.tag=201;
        [aCell.contentView addSubview:customCell];
    }
    
    BOHCustomCell *customCell=(BOHCustomCell *)[aCell.contentView viewWithTag:201];
    
    //seperators and borders for style
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 5, 2, 114)];
    lineView.backgroundColor = [UIColor blackColor];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(50, 55, 250, 2)];
    lineView2.backgroundColor = [UIColor blackColor];
    customCell.scoreLabel.layer.borderColor = [[UIColor redColor]CGColor];
    customCell.scoreLabel.layer.borderWidth =1.5;
    [customCell addSubview:lineView];
    [customCell addSubview:lineView2];
    
    //grab appropriate item
    BOHMovieItem *item = [sortedCriticMovieList objectAtIndex:[indexPath row]];
    //set values
    NSString *score = [NSString stringWithFormat:@"%@", [item totalScore]];
    NSString *rScore = [NSString stringWithFormat:@"RT:%@", [item RTCriticScore]];
    NSString *iScore = [NSString stringWithFormat:@"IMDB:%@", [item imdbCriticScore]];
    NSString *mScore = [NSString stringWithFormat:@"META:%@", [item metaCriticScore]];
    NSString *movieCast = [NSString stringWithFormat:@"CAST: %@", [item cast]];
    NSString *moviePlot = [NSString stringWithFormat:@"PLOT: %@", [item plot]];
    NSString *runtime = [NSString stringWithFormat:@"RUNTIME: %@ min", [item runtime]];
    NSString *rating = [NSString stringWithFormat:@"RATING: %@", [item rating]];
    NSString *release = [NSString stringWithFormat:@"RELEASE: %@", [item rel]];

    [customCell.titleLabel setText:[item title]];  //set movie title
    [customCell.rankLabel setText: [NSString stringWithFormat:@"%i", indexPath.row+1]];
    [customCell.scoreLabel setText:score]; //set critic score
    [customCell.RTLabel setText:rScore];
    [customCell.imdbLabel setText:iScore];
    [customCell.metacriticLabel setText:mScore];
    [customCell.plotLabel setText:moviePlot];
    [customCell.castLabel setText:movieCast];
    [customCell.runtimeLabel setText:runtime];
    [customCell.ratingLabel setText:rating];
    [customCell.releaseLabel setText:release];
    
    //load image from URL by sending asynchronous request via the connection
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[item imageLink]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               customCell.moviePosterThumbnail.image = [UIImage imageWithData:data];}];
    return customCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[cell setBackgroundColor:[UIColor clearColor]];
    
    //grab appropriate item
    BOHMovieItem *item = [sortedCriticMovieList objectAtIndex:[indexPath row]];
    
    if ([item.totalScore floatValue] > 80)
    {
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:250.0/255.0
                                                                     green:194.0/255.0 blue:0 alpha:1.0] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:102.0/255.0 alpha:1.0] CGColor], nil];
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    }
    else if ([item.totalScore floatValue] >50)
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

-(void)fetchRTMovies
{
    NSLog(@"CURRENTLY FETCHING RT ADDRESS.");
    //while it's fetching the address, indicator should be on
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    //request to RT
    NSString *myFirstRequestURL = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=%@&page_limit=50",RTkey];
    NSURL *webURL = [NSURL URLWithString:myFirstRequestURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSError *error;
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(returnData)
    {
        NSLog(@"Accessed RT! Received %d bytes of data.", [returnData length]);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        
        NSError* error;
        //parse json
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:returnData
                              options:kNilOptions
                              error:&error];
        
        //array of all movies
        NSArray* movies = [json objectForKey:@"movies"];
        
        //parse through movies array and store each movie as a BOHMovieItem
        for (NSDictionary *movie in movies)
        {
            BOOL moviePlayingNearMe = NO;
            BOOL moviePlayingNearMeIsThreeD = NO;
            NSString *title = [NSString stringWithFormat:@"%@", [movie objectForKey:@"title"]];
            NSString *titleInThreeD = [NSString stringWithFormat:@"%@ 3D",title];

            for (int i=0; i<moviesInTheaterNearMeList.count; i++)
            {
                //do comparison
                NSString *titleToCompareTo = [NSString stringWithFormat:@"%@", [moviesInTheaterNearMeList objectAtIndex:i]];
                
                if ([titleInThreeD isEqualToString:titleToCompareTo])
                {
                    NSLog(@"Found a 3D film: %@", titleToCompareTo);
                    moviePlayingNearMe = YES;
                    moviePlayingNearMeIsThreeD = YES;
                    break;
                }
                else if ([title isEqualToString:titleToCompareTo])
                {
                    moviePlayingNearMe = YES;
                    break;
                }
            }
            
            if (moviePlayingNearMe == YES)
            {
                //create BOHMovieItem element
                BOHMovieItem *item = [[BOHMovieItem alloc] init];
                //create dictionary that holds ratings
                NSDictionary *ratings = [movie objectForKey:@"ratings"];
                //create dictionary that holds the image URL
                NSDictionary *imageURL = [movie objectForKey:@"posters"];
                //create dictionary that holds IMDB id
                NSDictionary *imdbDictionary = [movie objectForKey:@"alternate_ids"];
                //dictionary for release date
                NSDictionary *relDictionary = [movie objectForKey:@"release_dates"];
                
                NSString *cScore = [NSString stringWithFormat:@"%@",[ratings objectForKey:@"critics_score"]];
                NSString *uScore = [NSString stringWithFormat:@"%@",[ratings objectForKey:@"audience_score"]];
                item.RTCriticScore = cScore;
                item.RTUserScore = uScore;
                
                if (moviePlayingNearMeIsThreeD)
                {
                    item.isThreeD = YES;
                }
                item.title = title;
                item.ID = [movie objectForKey:@"id"];
                item.imageLink = [imageURL objectForKey:@"thumbnail"];
                item.IMDBID = [imdbDictionary objectForKey:@"imdb"];
                item.rating = [movie objectForKey:@"mpaa_rating"];
                item.rel = [relDictionary objectForKey:@"theater"];
                item.runtime = [NSString stringWithFormat:@"%@",[movie objectForKey:@"runtime"]];
                
                //add the movie item to criticMovieList
                [criticMovieList addObject:item];
                [userMovieList addObject:item];
            }
        }
        
        if (TRUE)
        {  //on success
            [self fetchAdditionalMovieData];
        }
    }
}

-(void)fetchAdditionalMovieData
{
    //pull imdb data
    for (int i=0; i<criticMovieList.count; i++)
    {
        [self fetchIMDB:[criticMovieList objectAtIndex:i]];
    }
    
    //set average critic and user score
    for (BOHMovieItem* item in criticMovieList)
    {
        //set conditions for N/A scores
        if ([item.imdbCriticScore isEqualToString:@"0"])
        {
            item.imdbCriticScore = @"N/A";
            if ([item.metaCriticScore isEqualToString:@"N/A"])
            {
                item.totalScore = item.RTCriticScore;
                item.userScore = item.RTUserScore;
            }
            else
            {
                item.totalScore = [NSString stringWithFormat:@"%.1f",[item averageScore2:item.RTCriticScore arg2:item.metaCriticScore]];
                item.userScore = [NSString stringWithFormat:@"%.1f",[item averageScore2:item.RTUserScore arg2:item.metaCriticScore]];
            }
        }
        else if ([item.metaCriticScore isEqualToString:@"N/A"])
        {
            if ([item.imdbCriticScore isEqualToString:@"0"])
            {
                item.imdbCriticScore = @"N/A";
                item.totalScore = item.RTCriticScore;
                item.userScore = item.RTUserScore;
            }
            else
            {
                item.totalScore = [NSString stringWithFormat:@"%.1f",[item averageScore2:item.RTCriticScore arg2:item.imdbCriticScore]];
                item.userScore = [NSString stringWithFormat:@"%.1f",[item averageScore2:item.RTUserScore arg2:item.imdbCriticScore ]];
            }
        }
        else
        {
            item.totalScore = [NSString stringWithFormat:@"%.1f",[item averageScore:item.RTCriticScore arg2:item.imdbCriticScore arg3:item.metaCriticScore]];
            item.userScore = [NSString stringWithFormat:@"%.1f",[item averageScore:item.RTUserScore arg2:item.imdbCriticScore arg3:item.metaCriticScore]];
        }
    }
    
    //reorder the movies for critic score inside criticMovieList
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalScore" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    sortedCriticMovieList = [criticMovieList sortedArrayUsingDescriptors:sortDescriptors];
    
    //reorder the movies for user score inside userMovieList
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"userScore" ascending:NO];
    NSArray *sortDescriptors2 = [NSArray arrayWithObject:sortDescriptor2];
    sortedUserMovieList = [userMovieList sortedArrayUsingDescriptors:sortDescriptors2];
    
    //use singleton to share data
    SingletonMoviesNearMe *userArray = [SingletonMoviesNearMe sharedArray];
    userArray.sortedMoviesByUser = [NSArray arrayWithArray:sortedUserMovieList];
    
    //reload table
    [[self tableView] reloadData];
}

-(void)fetchIMDB:(BOHMovieItem*)movie
{
    //while it's fetching the address, indicator should be on
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    //request to IMDB
    NSString *url = [NSString stringWithFormat:@"http://www.omdbapi.com/?i=tt%@",movie.IMDBID];
    NSURL *webURL = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSError *error;
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (returnData)
    {
        //NSLog(@"Accessed IMDB! Received %d bytes of data.", [returnData length]);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        
        NSError* error;
        //parse json
        NSDictionary* json = [NSJSONSerialization
                         JSONObjectWithData:returnData
                         options:kNilOptions
                         error:&error];
        //change imdb score to a percentage
        NSString *imdbStringScore = [NSString stringWithFormat:@"%@",[json objectForKey:@"imdbRating"]];
        NSString *metaScore = [NSString stringWithFormat:@"%@",[json objectForKey:@"Metascore"]];
        float imdbScore = [imdbStringScore floatValue];
        imdbScore = imdbScore*10;

        movie.imdbCriticScore = [NSString stringWithFormat:@"%.0f", imdbScore];
        movie.metaCriticScore = metaScore;
        movie.plot = [json objectForKey:@"Plot"];
        movie.cast = [json objectForKey:@"Actors"];
    }
}

//this method is used to fetch a list of movies playing near the user's location
-(void)fetchTMSMovies
{
    NSLog(@"CURRENTLY FETCHING TMS ADDRESS.");
    //while it's fetching the address, indicator should be on
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    //Get current date
    NSDate *date = [NSDate date];
    // format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    // convert it to a string
    dateString = [dateFormat stringFromDate:date];
    
    //get location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    float lat = locationManager.location.coordinate.latitude;
    float lon = locationManager.location.coordinate.longitude;
    [locationManager stopUpdatingLocation];
    //string url
    //USE THIS FOR REAL IDEVICES
    NSString *url2 = [NSString stringWithFormat:@"http://data.tmsapi.com/v1/movies/showings?startDate=%@&lat=%0.2f&lng=%0.2f&api_key=%@", dateString, lat, lon, TMSkey]; //concatenate strings
    
    //string with manual input for date, location values, and key
    //USE THIS URL FOR SIMULATOR DEVICE
    //NSString *url2 = @"http://data.tmsapi.com/v1/movies/showings?startDate=2014-04-15&lat=43.45&lng=-80.5&api_key=agwepm4yvj8prp57y3dj5yqc";
    NSURL *webURL = [NSURL URLWithString:url2];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSError *error;
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (returnData)
    {
        NSLog(@"Accessed TMS! Received %d bytes of data.", [returnData length]);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

        NSError* error;
        //parse json
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:returnData
                         options:kNilOptions
                         error:&error];
        
        //array of all movies
        for (NSDictionary *movie in json)
        {
            //add title to movies near user, used for comparison
            NSString *titleToAdd = [movie objectForKey:@"title"];
            [moviesInTheaterNearMeList addObject:titleToAdd];
        }
        
        //use singleton to share data
        SingletonMoviesNearMe *array = [SingletonMoviesNearMe sharedArray];
        [array resetValues];  //reset any previous values in singleton class
        array.singletonMoviesNearMe = [NSArray arrayWithArray:moviesInTheaterNearMeList];
        
        if (TRUE)
        {  //on success
            [self fetchRTMovies];
        }
        
    }
}

@end
