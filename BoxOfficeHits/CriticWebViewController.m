//
//  CriticWebViewController.m
//  BoxOfficeHits
//
//  Created by Armand Obreja
//  Copyright (c) 2014 Armand Obreja. All rights reserved.

#import "CriticWebViewController.h"

@interface CriticWebViewController ()

@end

@implementation CriticWebViewController

- (void)loadView
{
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *wv = [[UIWebView alloc] initWithFrame:screenFrame];
    // Tell web view to scale web content to fit within bounds of webview
    [wv setScalesPageToFit:YES];
    [self setView:wv];
}

- (UIWebView *)webView
{
    return (UIWebView *)[self view];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Error loading webpage!: %@",
                             [error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *wav = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:errorString
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [wav show];
}


@end
