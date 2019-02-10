//
//  NetworkManager.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 22/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const kApiKey       = @"5fa91f4d299a99ecc758dfeb22e26c10";
static NSString *const kBaseUrl      = @"https://api.themoviedb.org/3/";
static NSString *const kResults      = @"results";
static NSString *const kMovie        = @"movie";
static NSString *const kCredits      = @"credits";
static NSString *const kCast         = @"cast";
static NSString *const kPerson       = @"person";
static NSString *const kMovieCredits = @"movie_credits";
static NSString *const kGenre        = @"genre";
static NSString *const kGenres       = @"genres";

@interface NetworkManager()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation NetworkManager

+ (instancetype)sharedInstance {
    
    static NetworkManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.manager = [AFHTTPSessionManager manager];
        
    });
    return sharedInstance;
}

- (void)fetchMovies:(int)page
      movieCategory:(MovieCategory)movieCategory
            success:(MoviesSuccess)success
            failure:(ModelParseFailure)failure {
    
    NSString *movieCategoryString = NSStringFromMovieCategory(movieCategory);
    NSString *url = [NSString stringWithFormat:@"%@%@/%@?api_key=%@&page=%d", kBaseUrl, kMovie, movieCategoryString, kApiKey, page];
    
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSError *error;
        NSArray *results = responseObject[kResults];
        NSMutableArray *movies = [MovieModel arrayOfModelsFromDictionaries:results error:&error];
        if (movies) {
            success(movies);
        } else {
            failure(error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}

- (void)fetchMovieDetails:(int)movieId
                 success:(MovieDetailSuccess)success
                 failure:(ModelParseFailure)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%d?api_key=%@", kBaseUrl, kMovie, movieId, kApiKey];
    
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSError *error;
        MovieModel *movie = [[MovieModel alloc] initWithDictionary:responseObject error:&error];
        if (movie) {
            success(movie);
        } else {
            failure(error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];

}

- (void)fetchCastMemebers:(int)movieId
                  success:(CastMembersSuccess)success
                  failure:(ModelParseFailure)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%d/%@?api_key=%@", kBaseUrl, kMovie, movieId, kCredits, kApiKey];
    
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSError *error;
        NSArray *results = responseObject[kCast];
        NSMutableArray *castMembers = [CastMemberModel arrayOfModelsFromDictionaries:results error:&error];
        if (castMembers) {
            success(castMembers);
        } else {
            failure(error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}

- (void)fetchPersonDetails:(int)personId
                   success:(PersonDetailSuccess)success
                   failure:(ModelParseFailure)failure {
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%d?api_key=%@", kBaseUrl, kPerson, personId, kApiKey];
    
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSError *error;
        PersonModel *person = [[PersonModel alloc] initWithDictionary:responseObject error:&error];
        if (person) {
            success(person);
        } else {
            failure(error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}

- (void)fetchPersonMovies:(int)personId
                  success:(MoviesSuccess)success
                  failure:(ModelParseFailure)failure {

    NSString *url = [NSString stringWithFormat:@"%@%@/%d/%@?api_key=%@", kBaseUrl, kPerson, personId, kMovieCredits, kApiKey];

    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSError *error;
        NSArray *results = responseObject[kCast];
        NSMutableArray *movies = [MovieModel arrayOfModelsFromDictionaries:results error:&error];
        if (movies) {
            success(movies);
        } else {
            failure(error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}

- (void)fetchGenres:(GenresSuccess)success
            failure:(ModelParseFailure)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/list?api_key=%@", kBaseUrl, kGenre, kMovie, kApiKey];
    
    [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSError *error;
        NSArray *results = responseObject[kGenres];
        NSMutableArray *genres = [GenreModel arrayOfModelsFromDictionaries:results error:&error];
        if (genres) {
            success(genres);
        } else {
            failure(error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}


@end
