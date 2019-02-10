//
//  FiltersViewController.m
//  MoviesExample
//
//  Created by Sebastian Natalevich on 25/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import "FiltersViewController.h"
#import "NetworkManager.h"
#import "GenreModel.h"

static NSString *const kCellIdentifier = @"genreCell";
static int const  kMaxYears = INT_MAX;
static int const  kMaxRange = 10;
static int const  kMinYears = 0;
static int const  kMinRange = 0;

typedef NS_ENUM(NSInteger, YearTextField) {
    yearSince    = 1,
    yearUntil,
};

typedef NS_ENUM(NSInteger, RangeTextField) {
    rangeFrom    = 1,
    rangeTo,
};


@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UITextField *yearUntilTextField;
@property (weak, nonatomic) IBOutlet UITextField *rangeFromTextField;
@property (weak, nonatomic) IBOutlet UITextField *rangeToTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearSinceTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *genresCollectionView;

@property (weak, nonatomic) IBOutlet UIPickerView *yearsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *rangePickerView;
@property (weak, nonatomic) IBOutlet UIView *disablingView;

@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSArray *years;
@property (nonatomic, strong) NSArray *ranges;
@property (nonatomic) int selectedTextField;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.genresCollectionView registerNib:[UINib nibWithNibName:@"GenreCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    
    __weak typeof(self) wSelf = self;
    
    [[NetworkManager sharedInstance] fetchGenres:^(NSArray *genres) {
        wSelf.genres = genres;
        [wSelf.genresCollectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    [self createFiltersValues];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.genresCollectionView reloadData];
}

- (void)createFiltersValues {
    NSMutableArray *years = [[NSMutableArray alloc] init];
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    
    [years addObject:@""];
    [ranges addObject:@""];
    
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger todaysYear = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
    for (NSInteger i = todaysYear; i >= 1950; i--) {
        [years addObject:[NSNumber numberWithInteger:i]];
    }
    
    for (double i = 1; i <= 10; i += 0.1) {
        [ranges addObject:[NSString stringWithFormat:@"%.01f",i]];
    }
    
    self.years = [years copy];
    self.ranges = [ranges copy];
}


#pragma mark - UIPickerViewDataSource
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.yearsPickerView) {
        return self.years.count;
    } else {
        return self.ranges.count;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.yearsPickerView) {
        return [NSString stringWithFormat:@"%@", [self.years objectAtIndex:row]];
    } else {
        return [self.ranges objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.yearsPickerView) {
        NSString *yearString = [NSString stringWithFormat:@"%@", [self.years objectAtIndex:row]];
        if (self.selectedTextField == yearSince) {
            self.yearSinceTextField.text = yearString;
        } else if (self.selectedTextField == yearUntil) {
            self.yearUntilTextField.text = yearString;
        }
        self.yearsPickerView.hidden = YES;
        
        
    } else {
        NSString *rangeString = [self.ranges objectAtIndex:row];
        if (self.selectedTextField == rangeFrom) {
            self.rangeFromTextField.text = rangeString;
        } else if (self.selectedTextField == rangeTo) {
            self.rangeToTextField.text = rangeString;
        }
        self.rangePickerView.hidden = YES;
    }
    self.disablingView.hidden = YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.genres.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GenreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    [cell initWithGenre:[self.genres objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"here");
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.yearSinceTextField || textField == self.yearUntilTextField) {
        self.yearsPickerView.hidden = NO;
        self.selectedTextField = textField == self.yearSinceTextField ? yearSince : yearUntil;
    } else if (textField == self.rangeToTextField || textField == self.rangeFromTextField) {
        self.rangePickerView.hidden = NO;
        self.selectedTextField = textField == self.rangeFromTextField ? rangeFrom : rangeTo;
    }
    self.disablingView.hidden = NO;
    return NO;
}

#pragma mark - CheckBoxDelegate
- (void)genreChecked:(GenreModel *)genreModel {
    
    for (GenreModel *genre in self.genres) {
        if (genre.genreId == genreModel.genreId) {
            genre.selected  = genreModel.selected;
            break;
        }
    }
}

- (void)clearAllFilters {
    self.yearSinceTextField.text = @"";
    self.yearUntilTextField.text = @"";
    self.rangeToTextField.text   = @"";
    self.rangeFromTextField.text = @"";
    
    for (GenreModel *genre in self.genres) {
        genre.selected = NO;
    }
}

- (NSArray *) getSelectedGenres {
    NSMutableArray *selectedGenres = [[NSMutableArray alloc] init];
    for (GenreModel *genre in self.genres) {
        if (genre.selected) {
            [selectedGenres addObject:[NSNumber numberWithInt:genre.genreId]];
        }
    }
    return selectedGenres;
}
- (int) getYearSince {
    return [self.yearSinceTextField.text isEqualToString:@""] ? kMinYears : [self.yearSinceTextField.text intValue];
}
- (int) getYearUntil {
    return [self.yearUntilTextField.text isEqualToString:@""] ? kMaxYears : [self.yearUntilTextField.text intValue];
}
- (double)getRangeFrom {
    return [self.rangeFromTextField.text isEqualToString:@""] ? kMinRange : [self.rangeFromTextField.text doubleValue];
}
- (double)getRangeTo {
    return [self.rangeToTextField.text isEqualToString:@""] ? kMaxRange : [self.rangeToTextField.text doubleValue];
}

- (BOOL)hasFilters {
    return !([self getYearSince] == kMinYears && [self getYearUntil] == kMaxYears && [self getRangeFrom] == kMinRange && [self getRangeTo] == kMaxRange && [self getSelectedGenres].count == 0);
}

- (IBAction)cancelTapped:(id)sender {
    [self clearAllFilters];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)acceptTapped:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
