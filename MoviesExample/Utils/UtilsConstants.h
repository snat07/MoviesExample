//
//  UtilsConstants.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Movie Categories */
typedef NS_ENUM(NSInteger, MovieCategory) {
    MovieCategory_Unknown     = -1,
    MovieCategoryPopular    = 1,
    MovieCategoryUpcoming,
    MovieCategoryTopRated,
    MovieCategoryNowPlaying,
};

NSString* NSStringFromMovieCategory(MovieCategory movieCategory);
MovieCategory MovieCategoryFromNSString(NSString *string);

/** Image Type */
typedef NS_ENUM(NSInteger, ImageType) {
    ImageType_Unknown     = -1,
    ImageTypePoster    = 1,
    ImageTypeBackDrop,
    ImageTypeProfile,
};
