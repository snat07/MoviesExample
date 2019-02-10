//
//  PersonModel.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"personId":      @"id",
                                                                  @"profilePath":   @"profile_path",
                                                                  }];
}



@end
