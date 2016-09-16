//
//  BOHCriticReviewItem.h
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import <Foundation/Foundation.h>

@interface SingletonID : NSObject

@property NSString *movieID;

+(SingletonID *)sharedID; //class method returns singleton object
-(void)resetValues;  //resets the values

@end
