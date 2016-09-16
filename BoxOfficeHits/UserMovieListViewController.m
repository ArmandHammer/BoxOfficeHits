//
//  UserMovieListViewController.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "UserMovieListViewController.h"
#import "ReviewsTableViewController.h"
#import "SingletonMoviesNearMe.h"
#import "BOHCustomCell.h"
#import "BOHMovieItem.h"

@implementation UserMovieListViewController
@synthesize userMovieList, reviewsTableViewController;

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {
        //prepare the array of movies
        userMovieList = [[NSArray alloc] init];
        //pull the array of sorted movies based on user score
        SingletonMoviesNearMe *userMovies = [SingletonMoviesNearMe sharedArray];
        userMovieList = [NSArray arrayWithArray:userMovies.sortedMoviesByUser];
    }
    
    //get tab bar item
    UITabBarItem *tbi = [self tabBarItem];
    //give it a label
    [tbi setTitle:@"Users"];
    [self.navigationItem setTitle:@"Users Score"];

    //create the UIImage from file
    UIImage *i = [UIImage imageNamed:@"people_.png"];
    [tbi setImage:i];
        
    return self;
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
    return [userMovieList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier=[NSString stringWithFormat:@"UserMovieListCell"];
    UITableViewCell *aCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //initialize cell
    if (aCell == nil)
    {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
        BOHCustomCell *customCell=[[BOHCustomCell alloc] init];
        customCell.tag=102;
        [aCell.contentView addSubview:customCell];
    }
    BOHCustomCell *customCell=(BOHCustomCell *)[aCell.contentView viewWithTag:102];
    
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
    BOHMovieItem *item = [userMovieList objectAtIndex:[indexPath row]];
    NSString *score = [NSString stringWithFormat:@"%@", [item userScore]];
    NSString *rScore = [NSString stringWithFormat:@"RT:%@", [item RTUserScore]];
    NSString *iScore = [NSString stringWithFormat:@"IMDB:%@", [item imdbCriticScore]];
    NSString *mScore = [NSString stringWithFormat:@"META:%@", [item metaCriticScore]];
    NSString *movieCast = [NSString stringWithFormat:@"CAST: %@", [item cast]];
    NSString *moviePlot = [NSString stringWithFormat:@"PLOT: %@", [item plot]];
    NSString *run = [NSString stringWithFormat:@"RUNTIME: %@ MIN", [item runtime]];
    NSString *rating = [NSString stringWithFormat:@"RATING: %@", [item rating]];
    NSString *release = [NSString stringWithFormat:@"RELEASE: %@", [item rel]];
    
    [customCell.titleLabel setText:[item title]];  //set movie title
    [customCell.rankLabel setText: [NSString stringWithFormat:@"%i", indexPath.row+1]];
    [customCell.scoreLabel setText:score]; //set user score
    [customCell.RTLabel setText:rScore];
    [customCell.imdbLabel setText:iScore];
    [customCell.metacriticLabel setText:mScore];
    [customCell.plotLabel setText:moviePlot];
    [customCell.castLabel setText:movieCast];
    [customCell.ratingLabel setText:rating];
    [customCell.runtimeLabel setText:run];
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
    //In this function we set the custom gradient colors for the cells

    //grab appropriate item
    BOHMovieItem *item = [userMovieList objectAtIndex:[indexPath row]];

    if ([item.userScore floatValue] > 80)
    {
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.frame = cell.bounds;
        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:250.0/255.0
                                                                     green:194.0/255.0 blue:0 alpha:1.0] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:231.0/255.0 blue:102.0/255.0 alpha:1.0] CGColor], nil];
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    }
    else if ([item.userScore floatValue] >50)
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

@end