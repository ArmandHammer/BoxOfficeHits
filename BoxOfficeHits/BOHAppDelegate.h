//
//  BOHAppDelegate.h
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import <UIKit/UIKit.h>
#import "BoxOfficeListViewController.h"
#import "UserMovieListViewController.h"
#import "CriticMovieListViewController.h"
#import "CriticWebViewController.h"

@interface BOHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *criticNavigationController;
@property (strong, nonatomic) UINavigationController *userNavigationController;
@property (strong, nonatomic) UINavigationController *boxOfficeNavigationController;

@property (strong, nonatomic) BoxOfficeListViewController *boxOfficeListViewController;
@property (strong, nonatomic) UserMovieListViewController *userMovieListViewController;
@property (strong, nonatomic) CriticMovieListViewController *criticMovieListViewController;
@property (strong, nonatomic) ReviewsTableViewController *reviewsTableViewController;
@property (strong, nonatomic) CriticWebViewController *criticWebViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
