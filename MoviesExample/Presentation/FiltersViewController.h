//
//  FiltersViewController.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 25/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenreCell.h"
#import "BaseViewController.h"

@interface FiltersViewController : BaseViewController<CheckBoxDelegate>

- (void) clearAllFilters;
- (BOOL) hasFilters;
- (NSArray *) getSelectedGenres;
- (int) getYearSince;
- (int) getYearUntil;
- (double)getRangeFrom;
- (double)getRangeTo;

@end
