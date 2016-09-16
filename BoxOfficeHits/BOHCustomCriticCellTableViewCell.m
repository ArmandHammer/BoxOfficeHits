//
//  BOHCustomCriticCellTableViewCell.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "BOHCustomCriticCellTableViewCell.h"

@implementation BOHCustomCriticCellTableViewCell
@synthesize criticScore = _criticScore;
@synthesize criticName = _criticName;
@synthesize criticDate = _criticDate;
@synthesize criticQuote = _criticQuote;
@synthesize criticPublication = _criticPublication;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.criticName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 175, 35)];
        self.criticQuote = [[UILabel alloc] initWithFrame:CGRectMake(15, 56, 305, 75)];
        self.criticScore = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 40, 20)];
        self.criticDate = [[UILabel alloc] initWithFrame:CGRectMake(200, 125, 100, 20)];
        self.criticPublication = [[UILabel alloc] initWithFrame:CGRectMake(185, 5, 120, 35)];
        
        self.criticQuote.numberOfLines = 0;
        self.criticQuote.lineBreakMode = NSLineBreakByWordWrapping;
        self.criticName.numberOfLines = 0;
        self.criticName.lineBreakMode = NSLineBreakByWordWrapping;
        self.criticPublication.numberOfLines = 0;
        self.criticPublication.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.criticName.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
        self.criticQuote.font = [UIFont fontWithName:@"Arial-ItalicMT" size:11.0f];
        self.criticScore.font = [UIFont fontWithName:@"Arial" size:14.0f];
        self.criticDate.font = [UIFont fontWithName:@"Arial" size:15.0f];
        self.criticPublication.font = [UIFont fontWithName:@"Arial" size:14.0f];
        
        //seperators and borders for style
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 42, self.contentView.bounds.size.width-5, 2)];
        lineView.backgroundColor = [UIColor blackColor];
        
        [self addSubview:lineView];
        [self addSubview:self.criticDate];
        [self addSubview:self.criticName];
        [self addSubview:self.criticQuote];
        [self addSubview:self.criticScore];
        [self addSubview:self.criticPublication];
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
