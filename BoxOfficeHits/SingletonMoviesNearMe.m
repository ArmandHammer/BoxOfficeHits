//
//  MoviesNearMe.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "SingletonMoviesNearMe.h"

@implementation SingletonMoviesNearMe

static SingletonMoviesNearMe *sharedArray = nil; //static instance variable

+(SingletonMoviesNearMe *)sharedArray
{
    if(sharedArray == nil)
    {
        sharedArray = [[super allocWithZone:NULL] init];
    }
    return sharedArray;
}

+(id)allocWithZone:(NSZone *)zone //ensure singleton status
{
    return [self sharedArray];
}

-(id)copyWithZone:(NSZone *)zone //ensure singleton status
{
    return self;
}

-(void)resetValues //used to reset all the values
{
    _singletonMoviesNearMe = nil;
    _sortedMoviesByUser = nil;
}

@end
