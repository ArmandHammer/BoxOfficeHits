//
//  BOHMovieItem.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "BOHMovieItem.h"

@implementation BOHMovieItem
@synthesize title, userScore, totalScore, RTCriticScore, imdbCriticScore, metaCriticScore, metaUserScore, ID, imageLink, cast, isThreeD, IMDBID, rank, plot;

-(float)averageScore:(NSString *)rScore arg2:(NSString *)iScore arg3:(NSString *)mScore
{
    float rVal = [rScore floatValue];
    float iVal = [iScore floatValue];
    float mVal = [mScore floatValue];
    float avg = (rVal + iVal + mVal)/3;
    return avg;
}

//for only 2 values to calculate (when a website has a N/A for rating)
-(float)averageScore2:(NSString *)rScore arg2:(NSString *)iScore
{
    float rVal = [rScore floatValue];
    float iVal = [iScore floatValue];
    float avg = (rVal + iVal)/2;
    return avg;
}

@end
