//
//  CastMemberModel.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 22/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface CastMemberModel : JSONModel

@property (nonatomic) int                        castId;
@property (nonatomic, strong) NSString           *character;
@property (nonatomic, strong) NSString           *name;
@property (nonatomic) int                        personId;
@property (nonatomic, strong) NSString<Optional> *profilePath;

@end
