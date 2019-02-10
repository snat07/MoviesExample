//
//  GenreCell.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 26/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "GenreCell.h"

@interface GenreCell()

@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkedButton;
@property (nonatomic, strong) GenreModel *genreModel;

@end

@implementation GenreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initWithGenre:(GenreModel *)genreModel{
    
    self.genreModel = genreModel;
    self.genreLabel.text = self.genreModel.name;
    
    self.checkedButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.checkedButton.layer.borderWidth = 1.0f;
    if (self.genreModel.selected) {
        [self.checkedButton setImage:[UIImage imageNamed:@"check-icon"] forState:UIControlStateNormal];
    } else {
        [self.checkedButton setImage:nil forState:UIControlStateNormal];
    }   
}

- (IBAction)checkedTapped:(id)sender {
    self.genreModel.selected = !self.genreModel.selected;
    
    if (self.genreModel.selected) {
        [self.checkedButton setImage:[UIImage imageNamed:@"check-icon"] forState:UIControlStateNormal];
    } else {
        [self.checkedButton setImage:nil forState:UIControlStateNormal];
    }
    
    [self.delegate genreChecked:self.genreModel];
    
}

@end
