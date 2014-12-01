//
//  InfoViewController.h
//  CountryQuiz
//
//  Created by rrgarci7 on 10/29/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Country.h"
#import "PopulationViewController.h"

@interface InfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property Country *selectedCountry;

@end
