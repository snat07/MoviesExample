//
//  PersonModel.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "MovieModel.h"

@protocol MovieModel

@end

@interface PersonModel : JSONModel

@property (nonatomic) int                                    personId;
@property (nonatomic, strong) NSString<Optional>             *biography;
@property (nonatomic, strong) NSString<Optional>             *birthday;
@property (nonatomic, strong) NSString<Optional>             *deathday;
@property (nonatomic, strong) NSString                       *name;
@property (nonatomic, strong) NSString<Optional>             *profilePath;
@property (nonatomic) float                                  popularity;
@property (nonatomic, strong) NSArray<MovieModel, Optional>  *personMovies;


@end
