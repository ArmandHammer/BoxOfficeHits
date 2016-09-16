//
//  BOHCriticReviewItem.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "SingletonID.h"

@implementation SingletonID

static SingletonID *sharedID = nil; //static instance variable

+(SingletonID *)sharedID
{
    if(sharedID == nil)
    {
        sharedID = [[super allocWithZone:NULL] init];
    }
    return sharedID;
}

+(id)allocWithZone:(NSZone *)zone //ensure singleton status
{
    return [self sharedID];
}

-(id)copyWithZone:(NSZone *)zone //ensure singleton status
{
    return self;
}

-(void)resetValues //used to reset all the values
{
    sharedID = nil;
}


@end
