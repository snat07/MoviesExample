//
//  BaseViewController.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 24/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "BaseViewController.h"
#import "TWTSimpleAnimationController.h"
#import "AppDelegate.h"



@interface BaseViewController ()
@property (strong, nonatomic)  UIView *loadingView;
@property (strong, nonatomic)  UIActivityIndicatorView *loadingActivityIndicator;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    self.navigationController.delegate = self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        self.navigationController.delegate = [self.navigationController.viewControllers lastObject];
    }
    [super viewWillDisappear:animated];
}

- (void)addHomeButton {
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"home-icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
}

-(void)backToMainView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)isIphone5 {
    return !([UIScreen mainScreen].bounds.size.height > 568);
}

- (void)createLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.loadingView.backgroundColor = [UIColor darkGrayColor];
    self.loadingView.alpha = 0.75;
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.loadingView.bounds.size.width/2 - 40, self.loadingView.bounds.size.height/2 - 40, 80, 30)];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"LOADING";
    loadingLabel.font = [UIFont fontWithName:@"Thonburi Light" size:18];
    loadingLabel.textColor = [UIColor lightGrayColor];
    
    self.loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.loadingView.bounds.size.width/2 - 10, self.loadingView.bounds.size.height/2 - 10, 20, 20)];
    
    [self.loadingView addSubview:loadingLabel];
    [self.loadingView addSubview:self.loadingActivityIndicator];
}

- (void)showLoadingView {
    if (!self.loadingView) {
        [self createLoadingView];
    }
    [self.view addSubview:self.loadingView];
    [self.loadingActivityIndicator startAnimating];
    
}
- (void)hideLoadingView {
    [self.loadingView removeFromSuperview];
    [self.loadingActivityIndicator stopAnimating];
}

- (void)showAlertView:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"An error just occured" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];

    [self presentViewController:alertController animated:YES completion:nil];
    [self hideLoadingView];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    TWTSimpleAnimationController *animationController = [[TWTSimpleAnimationController alloc] init];
    animationController.duration = 0.5;
    animationController.options = (  operation == UINavigationControllerOperationPush
                                   ? UIViewAnimationOptionTransitionFlipFromRight
                                   : UIViewAnimationOptionTransitionFlipFromLeft);
    return animationController;
}


@end
