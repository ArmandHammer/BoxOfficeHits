//
//  BOHCustomCell.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "BOHCustomCell.h"
#import "QuartzCore/QuartzCore.h"

@implementation BOHCustomCell

@synthesize titleLabel = _titleLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize rankLabel = _rankLabel;
@synthesize RTLabel = _RTLabel;
@synthesize metacriticLabel = _metacriticLabel;
@synthesize imdbLabel = _imdbLabel;
@synthesize moviePosterThumbnail = _moviePosterThumbnail;
@synthesize castLabel = _castLabel;
@synthesize runtimeLabel = _runtimeLabel;
@synthesize ratingLabel = _ratingLabel;
@synthesize releaseLabel = _releaseLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //create labels and image
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 180, 55)];
        self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 60, 40)];
        self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        self.moviePosterThumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 40, 65)]; //make thumbnail
        self.plotLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 118, 310, 50)];
        self.castLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 93, 265, 30)];
        self.imdbLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 62, 52, 10)];
        self.metacriticLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 62, 55, 10)];
        self.RTLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 62, 35, 10)];
        self.runtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 87, 100, 10)];
        self.ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 76, 80, 10)];
        self.releaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(143, 76, 150, 10)];
        
        //set word wrap
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.plotLabel.numberOfLines = 0;
        self.plotLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.castLabel.numberOfLines = 0;
        self.castLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        //font
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
        self.runtimeLabel.font = [UIFont fontWithName:@"Arial" size:9.5f];
        self.plotLabel.font = [UIFont fontWithName:@"Arial" size:10.5f];
        self.castLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        self.ratingLabel.font = [UIFont fontWithName:@"Arial" size:9.5f];
        self.releaseLabel.font = [UIFont fontWithName:@"Arial" size:9.5f];
        self.RTLabel.font = [UIFont fontWithName:@"Arial" size:11.0f];
        self.imdbLabel.font = [UIFont fontWithName:@"Arial" size:11.0f];
        self.metacriticLabel.font = [UIFont fontWithName:@"Arial" size:11.0f];
        self.rankLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        self.rankLabel.font = [UIFont fontWithName:@"Helvetica" size:30.0f];
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreLabel.font = [UIFont fontWithName:@"Helvetica" size:28.0f];
        
        [self addSubview:self.ratingLabel];
        [self addSubview:self.releaseLabel];
        [self addSubview:self.moviePosterThumbnail];
        [self addSubview:self.titleLabel];
        [self addSubview:self.scoreLabel];
        [self addSubview:self.rankLabel];
        [self addSubview:self.RTLabel];
        [self addSubview:self.imdbLabel];
        [self addSubview:self.metacriticLabel];
        [self addSubview:self.plotLabel];
        [self addSubview:self.castLabel];
        [self addSubview:self.runtimeLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
