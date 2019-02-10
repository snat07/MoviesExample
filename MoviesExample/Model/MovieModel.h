//
//  MovieModel.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 22/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "CastMemberModel.h"

@protocol CastMemberModel

@end

@interface MovieModel : JSONModel

// Basic properties
@property (nonatomic) int                                        movieId;
@property (nonatomic, strong) NSString                           *originalTitle;
@property (nonatomic, strong) NSString                           *title;
@property (nonatomic, strong) NSString<Optional>                 *originalLanguage;
@property (nonatomic, strong) NSString<Optional>                 *overview;
@property (nonatomic, strong) NSString<Optional>                 *releaseDate;
@property (nonatomic, strong) NSString<Optional>                 *posterPath;
@property (nonatomic, strong) NSString<Optional>                 *backdropPath;
@property (nonatomic) long                                       popularity;
@property (nonatomic) long                                       voteCount;
@property (nonatomic) double                                     voteAverage;
@property (nonatomic, strong) NSArray<Optional>                  *genres;



// Details properties
@property (nonatomic) int                                        runtime;
@property (nonatomic, strong) NSArray<CastMemberModel, Optional> *castMembers;
@property (nonatomic, strong) NSString<Optional>                 *homepage;

@end
