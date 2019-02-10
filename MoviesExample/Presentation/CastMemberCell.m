//
//  CastMemberCell.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "CastMemberCell.h"
#import "NSString+Helper.h"
#import "UIImageView+AFNetworking.h"

@interface CastMemberCell()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;

@end

@implementation CastMemberCell

- (void)initWithCastMember:(CastMemberModel *)castMemberModel {
    
    NSString *url = [NSString posterUrl:castMemberModel.profilePath];
    [self.profilePicture setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
    self.profilePicture.layer.borderColor = [UIColor orangeColor].CGColor;
    self.profilePicture.layer.borderWidth = 3.0f;
    self.profilePicture.layer.masksToBounds = YES;
    
    self.nameLabel.text = castMemberModel.name;
    self.characterLabel.text = castMemberModel.character;
}

@end
