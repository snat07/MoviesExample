//
//  MainViewController.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 21/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "MoviesViewController.h"
#import "NetworkManager.h"
#import "MovieCell.h"
#import "MovieDetailsViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "UtilsConstants.h"
#import "FiltersViewController.h"
#import "NSString+Helper.h"

static NSString *const kCellIdentifier = @"movieCell";

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *movieTypesSegmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clearFiltersButtonHeight;
@property (weak, nonatomic) IBOutlet UIButton *clearFiltersButton;

@property (nonatomic, strong) NSArray *allMovies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (nonatomic) int page;
@property (nonatomic) MovieCategory selectedCategory;
@property (nonatomic, strong) FiltersViewController *filtersViewController;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    self.page = 1;
    self.selectedCategory = MovieCategoryPopular;
    
    [self showLoadingView];
    __weak typeof(self) wSelf = self;
    [[NetworkManager sharedInstance] fetchMovies:self.page movieCategory:self.selectedCategory success:^(NSArray *movies) {
        wSelf.allMovies = movies;
        wSelf.filteredMovies = movies;
        [wSelf.moviesTableView setContentOffset:CGPointZero animated:YES];
        [wSelf.moviesTableView reloadData];
        
        [wSelf hideLoadingView];
    } failure:^(NSError *error) {
        [self showAlertView:NSLocalizedString(@"moviesError", nil)];
    }];
    
    // setup infinite scrolling
    [self.moviesTableView addInfiniteScrollingWithActionHandler:^{
        [wSelf loadMoreMovies];
    }];
    
    [self setupSegmentedControl];
    [self addFilterButton];
    [self hideClearFilterButton];
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"MOVIES";
    
    if (self.filtersViewController && self.presentedViewController == self.filtersViewController) {
        if ([self.filtersViewController hasFilters]) {
            [self showClearFilterButton];
        } else {
            [self hideClearFilterButton];
        }
        self.filteredMovies = [self applyFilters:self.allMovies];
        [self.moviesTableView reloadData];
    }
}

- (void)setupSegmentedControl {
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.movieTypesSegmentedControl setTitleTextAttributes:attributes
                                                   forState:UIControlStateNormal];
}

- (void)addFilterButton {
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"filter-icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(filterButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

-(void)filterButtonTapped{
    if (!self.filtersViewController) {
        self.filtersViewController = [[FiltersViewController alloc] init];
    }
    [self.navigationController presentViewController:self.filtersViewController animated:YES completion:nil];
    
}

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell initWithMovie:[self.filteredMovies objectAtIndex:indexPath.row]];
    
    return cell;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieModel *movieModel = [self.filteredMovies objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showLoadingView];
    __weak typeof(self) wSelf = self;
    [[NetworkManager sharedInstance] fetchMovieDetails:movieModel.movieId success:^(MovieModel *movieModel) {
        
        MovieDetailsViewController *moviesDetailViewController = [[MovieDetailsViewController alloc] initWithMovieModel:movieModel];
        [wSelf hideLoadingView];
        wSelf.navigationController.delegate = self;
        [wSelf.navigationController pushViewController:moviesDetailViewController animated:YES];
    } failure:^(NSError *error) {
        [self showAlertView:NSLocalizedString(@"movieDetailsError", nil)];
    }];
}

- (void)loadMoreMovies {
    self.page++;
    __weak typeof(self) wSelf = self;
    [[NetworkManager sharedInstance] fetchMovies:self.page movieCategory:self.selectedCategory success:^(NSArray *movies) {
        
        NSArray *appendedArray = [wSelf.allMovies arrayByAddingObjectsFromArray:movies];
        wSelf.allMovies = appendedArray;
        
        if (self.filtersViewController) {
            NSArray *appendedFilterArray = [wSelf.filteredMovies arrayByAddingObjectsFromArray:[self applyFilters:movies]];
            wSelf.filteredMovies = appendedFilterArray;
        
        }else {
            wSelf.filteredMovies = appendedArray;
        }
        
        
        [wSelf.moviesTableView reloadData];
        [wSelf.moviesTableView.infiniteScrollingView stopAnimating];
    } failure:^(NSError *error) {
        [self showAlertView:NSLocalizedString(@"moreMoviesError", nil)];
    }];
}

- (IBAction)movieTypesTapped:(UISegmentedControl *)sender {

    self.selectedCategory = sender.selectedSegmentIndex + 1;
    self.page = 1;
    __weak typeof(self) wSelf = self;
    [self showLoadingView];
    
    [[NetworkManager sharedInstance] fetchMovies:self.page movieCategory:self.selectedCategory success:^(NSArray *movies) {
        wSelf.allMovies = movies;
        if (self.filtersViewController) {
            wSelf.filteredMovies = [wSelf applyFilters:movies];
        }else {
            wSelf.filteredMovies = movies;
        }
        [wSelf.moviesTableView setContentOffset:CGPointZero animated:YES];
        [wSelf.moviesTableView reloadData];
        [wSelf hideLoadingView];
    } failure:^(NSError *error) {
        
        [self showAlertView:NSLocalizedString(@"moviesError", nil)];
    }];
 
}

- (NSArray *)applyFilters:(NSArray *)movies {
    
    if (![self.filtersViewController hasFilters]) {
        return movies;
    }
    
    NSArray *genresSelected = [self.filtersViewController getSelectedGenres];
    NSMutableArray *genresFilteredArray = [[NSMutableArray alloc] init];
    for (NSNumber *genreId in genresSelected) {
        for (MovieModel *movie in movies) {
            if ([movie.genres containsObject:genreId] && ![genresFilteredArray containsObject:movie]) {
                [genresFilteredArray addObject:movie];
            }
        }
    }
    if (genresSelected.count == 0) {
        genresFilteredArray = [movies copy];
    }

    
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    int yearSince = self.filtersViewController.getYearSince;
    int yearUntil = self.filtersViewController.getYearUntil;
    double rangeFrom = self.filtersViewController.getRangeFrom;
    double rangeTo = self.filtersViewController.getRangeTo;
    for (MovieModel *movie in genresFilteredArray) {
        int year = [[NSString yearText:movie.releaseDate] intValue];
        if (movie.voteAverage >= rangeFrom && movie.voteAverage <= rangeTo &&
            year >= yearSince && year <= yearUntil) {
            [filteredArray addObject:movie];
        }
    }
    
    return filteredArray;
}

- (void)showClearFilterButton {
    self.clearFiltersButton.hidden = NO;
    self.clearFiltersButtonHeight.constant = 30;
}

- (void)hideClearFilterButton {
    self.clearFiltersButton.hidden = YES;
    self.clearFiltersButtonHeight.constant = 0;
    [self.moviesTableView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)clearFiltersTapped:(id)sender {
    [self.filtersViewController clearAllFilters];
    [self hideClearFilterButton];
    self.filteredMovies = [self applyFilters:self.allMovies];
    [self.moviesTableView reloadData];
    
}


@end
