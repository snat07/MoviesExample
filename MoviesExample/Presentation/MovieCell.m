//
//  MovieCell.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Helper.h"


@interface MovieCell()

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *avergeLabel;

@end

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initWithMovie:(MovieModel *)movie {
    
    NSString *url = [NSString posterUrl:movie.posterPath];
    [self.posterImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    
    self.movieTitle.text = movie.title;
    self.yearLabel.text = [NSString yearText:movie.releaseDate];
    self.overviewLabel.text = movie.overview;
    self.avergeLabel.text = [NSString stringWithFormat:@"%.01f", movie.voteAverage];
}

@end
