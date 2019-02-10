//
//  NetworkManager.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 22/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieModel.h"
#import "CastMemberModel.h"
#import "PersonModel.h"
#import "UtilsConstants.h"
#import "GenreModel.h"

typedef void (^MoviesSuccess)(NSArray *movies);
typedef void (^MovieDetailSuccess)(MovieModel *movieModel);
typedef void (^CastMembersSuccess)(NSArray *castMembers);
typedef void (^PersonDetailSuccess)(PersonModel *personModel);
typedef void (^GenresSuccess)(NSArray *genres);
typedef void (^ModelParseFailure)(NSError *error);

@interface NetworkManager : NSObject


+ (instancetype)sharedInstance;

- (void)fetchMovies:(int)page
      movieCategory:(MovieCategory)movieCategory
            success:(MoviesSuccess)success
                  failure:(ModelParseFailure)failure;

- (void)fetchMovieDetails:(int)movieId
                 success:(MovieDetailSuccess)success
                 failure:(ModelParseFailure)failure;

- (void)fetchCastMemebers:(int)movieId
                  success:(CastMembersSuccess)success
                  failure:(ModelParseFailure)failure;

- (void)fetchPersonDetails:(int)personId
                  success:(PersonDetailSuccess)success
                  failure:(ModelParseFailure)failure;

- (void)fetchPersonMovies:(int)personId
                  success:(MoviesSuccess)success
                  failure:(ModelParseFailure)failure;

- (void)fetchGenres:(GenresSuccess)success
                  failure:(ModelParseFailure)failure;

@end
