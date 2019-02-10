//
//  CastMemberModel.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 22/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "CastMemberModel.h"

@implementation CastMemberModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"castId":      @"cast_id",
                                                                  @"personId":    @"id",
                                                                  @"profilePath": @"profile_path",
                                                                  }];
}

@end
