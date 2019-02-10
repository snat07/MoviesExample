//
//  ApplicationTheme.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "ApplicationTheme.h"
#import <UIKit/UIKit.h>

@implementation ApplicationTheme

+(void)styleApplicationNavigationBarAppearance {
    
    /** UINavigationController */
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName:   [UIColor whiteColor],
                                          NSFontAttributeName:              [UIFont fontWithName:@"Futura" size:17]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];
    [[UINavigationBar appearance] setBackgroundImage:[self navigationBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"navigation_shadow"]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

+ (UIImage *)navigationBarBackgroundImage {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 4)];
    view.backgroundColor = [UIColor darkGrayColor];
    view.alpha = 0.99f;

    UIView *accentLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 2, 2)];
    accentLineView.backgroundColor = [UIColor orangeColor];
    [view addSubview:accentLineView];
    
    /** Create image from view */
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 3, 1)];
}

@end
