//
//  NSString+ImageUrl.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "NSString+Helper.h"

static NSString *const kBaseUrl = @"https://image.tmdb.org/t/p/";
static NSString *const kW185 = @"w185";
static NSString *const kW780 = @"w780";

@implementation NSString (ImageUrl)

+ (NSString *)posterUrl:(NSString *)posterPath {
    return [NSString stringWithFormat:@"%@%@%@", kBaseUrl, kW185, posterPath];
}

+ (NSString *)backDropUrl:(NSString *)backDropPath {
    return [NSString stringWithFormat:@"%@%@%@", kBaseUrl, kW780, backDropPath];
}

+ (NSString *)profilePictureUrl:(NSString *)profilePicturePath {
    return [NSString stringWithFormat:@"%@%@%@", kBaseUrl, kW185, profilePicturePath];
}

+ (NSString *)yearText:(NSString *)dateText {
    return [dateText substringToIndex:4];
}

+ (NSString *)formatDate:(NSString *)dateText {
    NSArray *splittedDate = [dateText componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@/%@/%@", splittedDate[2], splittedDate[1], splittedDate[0]];
}

@end
