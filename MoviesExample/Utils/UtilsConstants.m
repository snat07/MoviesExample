//
//  UtilsConstants.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "UtilsConstants.h"

NSInteger ValueWithDictionary(NSDictionary *dictionary, id key);
NSString* KeyWithDictionary(NSDictionary *dictionary, NSInteger value);

#pragma mark - Movie Categories
NSDictionary* MovieCategoryMapping() {
    static NSDictionary *movieCategoryMapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        movieCategoryMapping = @{@"unknown":        @(MovieCategory_Unknown),
                                 @"popular":        @(MovieCategoryPopular),
                                 @"upcoming":       @(MovieCategoryUpcoming),
                                 @"top_rated":      @(MovieCategoryTopRated),
                                 @"now_playing":    @(MovieCategoryNowPlaying),
                                };
    });
    return movieCategoryMapping;
}

NSString* NSStringFromMovieCategory(MovieCategory movieCategory) {
    return KeyWithDictionary(MovieCategoryMapping(), movieCategory);
    
}
MovieCategory MovieCategoryFromNSString(NSString *string) {
    return ValueWithDictionary(MovieCategoryMapping(), string);
}

#pragma mark - Private (Dictionary Mapping)
NSInteger ValueWithDictionary(NSDictionary *dictionary, id key) {
    
    NSNumber *valueNumber = dictionary[key ?: NSNull.null];
    if ([valueNumber isKindOfClass:[NSNumber class]]) {
        return valueNumber.integerValue;
    } else {
        return -1;
    }
}

NSString* KeyWithDictionary(NSDictionary *dictionary, NSInteger value) {
    
    NSNumber *object = @(value);
    __block id result;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id anObject, BOOL *stop) {
        if ([object isEqual:anObject]) {
            result = key;
            *stop = YES;
        }
    }];
    return result;
}

