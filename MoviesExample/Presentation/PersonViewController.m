//
//  PersonViewController.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 24/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "PersonViewController.h"
#import "NetworkManager.h"
#import "RelatedMovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Helper.h"
#import "MovieDetailsViewController.h"

static NSString *const kCellIdentifier = @"relatedMovieCell";
static int const kMaxBiographyHeightIphone5 = 144;
static int const kMaxBiographyHeight = 212;

@interface PersonViewController ()

@property(nonatomic, strong) PersonModel *personModel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bornDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deathDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *otherMoviesCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *biographyTextViewHeight;


@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.otherMoviesCollectionView registerNib:[UINib nibWithNibName:@"RelatedMovieCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    __weak typeof(self) wSelf = self;
    [[NetworkManager sharedInstance] fetchPersonMovies:self.personModel.personId success:^(NSArray<MovieModel> *movies) {
        wSelf.personModel.personMovies = movies;
        [wSelf.otherMoviesCollectionView reloadData];
    } failure:^(NSError *error) {
        [self showAlertView:NSLocalizedString(@"moviesError", nil)];
    }];
    
    [self setupPersonDetails];
    [self addHomeButton];
}

- (void)setupPersonDetails {
    NSString *url = [NSString backDropUrl:self.personModel.profilePath];
    [self.profilePictureImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
    self.profilePictureImageView.layer.cornerRadius = 3.0f;
    self.profilePictureImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.profilePictureImageView.layer.borderWidth = 1.0f;
    self.profilePictureImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = self.personModel.name;
    if (self.personModel.birthday) {
        self.bornDateLabel.text = ![self.personModel.birthday isEqualToString:@""] ? [NSString formatDate:self.personModel.birthday] : @"";
    }
    if (self.personModel.deathday) {
    self.deathDateLabel.text = ![self.personModel.deathday isEqualToString:@""] ? [NSString formatDate:self.personModel.deathday] : @"";
    }
    self.biographyTextView.text = self.personModel.biography;
    
    int maxHeight = [self isIphone5] ? kMaxBiographyHeightIphone5 : kMaxBiographyHeight;
    CGSize sizeThatFitsTextView = [self.biographyTextView sizeThatFits:CGSizeMake(self.biographyTextView.frame.size.width, maxHeight)];
    
    self.biographyTextViewHeight.constant = sizeThatFitsTextView.height < maxHeight ? sizeThatFitsTextView.height : maxHeight;
    self.biographyTextView.scrollEnabled = sizeThatFitsTextView.height > maxHeight;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype) initWithPersonModel:(PersonModel *)personModel {
    self = [super init];
    if(self) {
        self.personModel = personModel;
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.personModel.personMovies.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RelatedMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell initWithMovie:[self.personModel.personMovies objectAtIndex:indexPath.row]];
    return cell;
}

#pragma marl - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieModel *movieModel = [self.personModel.personMovies objectAtIndex:indexPath.row];
    [self showLoadingView];
    __weak typeof(self) wSelf = self;
    [[NetworkManager sharedInstance] fetchMovieDetails:movieModel.movieId success:^(MovieModel *movieModel) {
        MovieDetailsViewController *moviesDetailViewController = [[MovieDetailsViewController alloc] initWithMovieModel:movieModel];
        [wSelf hideLoadingView];

        [wSelf.navigationController pushViewController:moviesDetailViewController animated:YES];
    } failure:^(NSError *error) {
        [wSelf showAlertView:NSLocalizedString(@"movieDetailsError", nil)];
    }];
}

@end
