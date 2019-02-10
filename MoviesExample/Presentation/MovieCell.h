//
//  MovieCell.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface MovieCell : UITableViewCell

- (void)initWithMovie:(MovieModel *)movie;

@end
