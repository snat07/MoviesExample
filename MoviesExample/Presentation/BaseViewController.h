//
//  BaseViewController.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 24/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

- (void)addHomeButton;
- (BOOL)isIphone5;

- (void)showLoadingView;
- (void)hideLoadingView;
- (void)showAlertView:(NSString *)message;
@end
