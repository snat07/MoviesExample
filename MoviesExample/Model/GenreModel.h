//
//  GenresModel.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface GenreModel : JSONModel

@property (nonatomic) int              genreId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL             selected;

@end
