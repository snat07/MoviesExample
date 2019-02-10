//
//  GenreCell.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 26/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenreModel.h"

@protocol CheckBoxDelegate

- (void)genreChecked:(GenreModel *)genreModel;

@end

@interface GenreCell : UICollectionViewCell

@property (nonatomic, assign) id <CheckBoxDelegate> delegate;
- (void)initWithGenre:(GenreModel *)genreModel;


@end
