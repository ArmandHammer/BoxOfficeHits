//
//  BOHCustomCell.h
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import <UIKit/UIKit.h>

@interface BOHCustomCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIImageView *moviePosterThumbnail;
@property (nonatomic, strong) UIImageView *rtIMG;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *castLabel;
@property (nonatomic, strong) UILabel *plotLabel;
@property (nonatomic, strong) UILabel *imdbLabel;
@property (nonatomic, strong) UILabel *metacriticLabel;
@property (nonatomic, strong) UILabel *RTLabel;
@property (nonatomic, strong) UILabel *runtimeLabel;
@property (nonatomic, strong) UILabel *releaseLabel;
@property (nonatomic, strong) UILabel *ratingLabel;

@end
