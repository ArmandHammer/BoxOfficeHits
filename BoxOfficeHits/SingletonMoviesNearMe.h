//
//  MoviesNearMe.h
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import <Foundation/Foundation.h>

@interface SingletonMoviesNearMe : NSObject

//define the array
@property NSArray *singletonMoviesNearMe;
@property NSArray *sortedMoviesByUser;

+(SingletonMoviesNearMe *)sharedArray; //class method returns singleton object
-(void)resetValues;  //resets the values

@end
