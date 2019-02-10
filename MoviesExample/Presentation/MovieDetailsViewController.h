//
//  MovieDetailsViewController.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"
#import "BaseViewController.h"

@interface MovieDetailsViewController : BaseViewController

- (instancetype) initWithMovieModel:(MovieModel *)movieModel;

@end
