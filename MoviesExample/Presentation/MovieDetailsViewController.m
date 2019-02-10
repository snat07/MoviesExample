//
//  MovieDetailsViewController.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 23/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "NetworkManager.h"
#import "NSString+Helper.h"
#import "UIImageView+AFNetworking.h"
#import "CastMemberCell.h"
#import "PersonViewController.h"

static NSString *const kCellIdentifier     = @"castMemberCell";
static int const kMaxOverviewHeightIphone5 = 95;
static int const kMaxOverviewHeight        = 130;

@interface MovieDetailsViewController ()

@property (nonatomic, strong) MovieModel *movieModel;
@property (weak, nonatomic) IBOutlet UIImageView *backDropImage;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *webPageLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *castMemberCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overviewTextViewHeight;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMovieDetails];
    [self addHomeButton];
    
    [self.castMemberCollectionView registerNib:[UINib nibWithNibName:@"CastMemberCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    
    __weak typeof(self) wSelf = self;
    [[NetworkManager sharedInstance] fetchCastMemebers:self.movieModel.movieId success:^(NSArray<CastMemberModel> *castMembers) {
        wSelf.movieModel.castMembers = castMembers;
        [wSelf.castMemberCollectionView reloadData];
        
    } failure:^(NSError *error) {
        [self showAlertView:NSLocalizedString(@"castMemberError", nil)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype) initWithMovieModel:(MovieModel *)movieModel {
    self = [super init];
    if(self) {
        self.movieModel = movieModel;
    }
    
    return self;
}

- (void)setupMovieDetails {
    
    NSString *url = [NSString backDropUrl:self.movieModel.backdropPath];
    [self.backDropImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.movieModel.homepage];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    self.webPageLabel.attributedText = attributeString;
    self.overviewLabel.text = self.movieModel.overview;
    [self.overviewLabel setContentOffset: CGPointZero animated:YES];
    
    int maxHeight = [self isIphone5] ? kMaxOverviewHeightIphone5 : kMaxOverviewHeight;
    CGSize sizeThatFitsTextView = [self.overviewLabel sizeThatFits:CGSizeMake(self.overviewLabel.frame.size.width, maxHeight)];
    
    self.overviewTextViewHeight.constant = sizeThatFitsTextView.height < maxHeight ? sizeThatFitsTextView.height : maxHeight;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.movieModel.title, [NSString yearText:self.movieModel.releaseDate]];
    
    self.durationLabel.text = [NSString stringWithFormat:@"%d",self.movieModel.runtime];
    self.durationLabel.backgroundColor = [UIColor clearColor];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    self.durationLabel.layer.shadowOffset = CGSizeMake(0, 0);
    self.durationLabel.layer.shadowOpacity = 1;
    self.durationLabel.layer.shadowRadius = 4;
    
    self.averageLabel.text = [NSString stringWithFormat:@"%.01f", self.movieModel.voteAverage];
    self.averageLabel.backgroundColor = [UIColor clearColor];
    self.averageLabel.textAlignment = NSTextAlignmentCenter;
    self.averageLabel.layer.shadowOffset = CGSizeMake(0, 0);
    self.averageLabel.layer.shadowOpacity = 1;
    self.averageLabel.layer.shadowRadius = 4;

}

- (IBAction)webPageTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:self.movieModel.homepage];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
        [self showAlertView:NSLocalizedString(@"openWebPageError", nil)];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movieModel.castMembers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CastMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell initWithCastMember:[self.movieModel.castMembers objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CastMemberModel *castMemberModel = [self.movieModel.castMembers objectAtIndex:indexPath.row];
    [self showLoadingView];
    __weak typeof(self) wSelf = self;
    [[NetworkManager sharedInstance] fetchPersonDetails:castMemberModel.personId success:^(PersonModel *personModel) {
        PersonViewController *personViewController = [[PersonViewController alloc] initWithPersonModel:personModel];
        [wSelf hideLoadingView];
        [wSelf.navigationController pushViewController:personViewController animated:YES];
    } failure:^(NSError *error) {
        [wSelf showAlertView:NSLocalizedString(@"personDetailError", nil)];
    }];
}



@end
