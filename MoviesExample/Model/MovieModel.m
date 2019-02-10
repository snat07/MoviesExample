//
//  MovieModel.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 22/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"movieId":                @"id",
                                                                  @"originalTitle":    @"original_title",
                                                                  @"originalLanguage": @"original_language",
                                                                  @"releaseDate":      @"release_date",
                                                                  @"posterPath":       @"poster_path",
                                                                  @"backdropPath":     @"backdrop_path",
                                                                  @"voteCount":        @"vote_count",
                                                                  @"voteAverage":      @"vote_average",
                                                                  @"genres":           @"genre_ids",
                                                                  }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"runtime"] ||
        [propertyName isEqualToString:@"popularity"] ||
        [propertyName isEqualToString:@"voteCount"] ||
        [propertyName isEqualToString:@"voteAverage"] ){
        return YES;
    };
    return NO;
}

@end
