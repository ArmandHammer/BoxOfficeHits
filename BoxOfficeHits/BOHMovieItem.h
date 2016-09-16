//
//  BOHMovieItem.h
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import <Foundation/Foundation.h>

@interface BOHMovieItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *plot;
@property (nonatomic, strong) NSString *userScore;
@property (nonatomic, strong) NSString *RTUserScore;
@property (nonatomic, strong) NSString *totalScore;
@property (nonatomic, strong) NSString *RTCriticScore;
@property (nonatomic, strong) NSString *imdbCriticScore;
@property (nonatomic, strong) NSString *metaCriticScore;
@property (nonatomic, strong) NSString *metaUserScore;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *IMDBID;
@property (nonatomic, strong) NSString *imageLink;
@property (nonatomic, strong) NSString *cast;
@property (nonatomic, strong) NSString *runtime;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *rel;

@property BOOL isThreeD;

-(float )averageScore:(NSString *)rScore arg2:(NSString *)iScore arg3:(NSString *)mScore;
-(float )averageScore2:(NSString *)rScore arg2:(NSString *)iScore;

@end
