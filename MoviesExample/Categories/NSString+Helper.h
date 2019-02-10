//
//  NSString+ImageUrl.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

+ (NSString *)posterUrl:(NSString *)posterPath;
+ (NSString *)backDropUrl:(NSString *)backDropPath;
+ (NSString *)profilePictureUrl:(NSString *)profilePicturePath;

+ (NSString *)yearText:(NSString *)dateText;
+ (NSString *)formatDate:(NSString *)dateText;

@end
