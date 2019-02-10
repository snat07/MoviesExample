//
//  RelatedMovieCell.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 24/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "RelatedMovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Helper.h"

@interface RelatedMovieCell()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;


@end

@implementation RelatedMovieCell

-(void) initWithMovie:(MovieModel *)movie {
    
    NSString *url = [NSString posterUrl:movie.posterPath];
    [self.posterImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    self.posterImageView.layer.cornerRadius = 3.0f;
    self.posterImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.posterImageView.layer.borderWidth = 1.0f;
    self.posterImageView.layer.masksToBounds = YES;

    
    self.movieNameLabel.text = movie.title;
}

@end
