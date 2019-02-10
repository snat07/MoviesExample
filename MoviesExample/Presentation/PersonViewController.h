//
//  PersonViewController.h
//  MoviesExample
//
//  Created by Sebastian Natalevich on 24/5/17.
//  Copyright © 2017 Sebastian Natalevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
#import "BaseViewController.h"

@interface PersonViewController : BaseViewController

- (instancetype) initWithPersonModel:(PersonModel *)personModel;

@end
