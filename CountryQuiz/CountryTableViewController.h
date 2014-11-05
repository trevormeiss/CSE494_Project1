//
//  CountryTableViewController.h
//  CountryQuiz
//
//  Created by rrgarci7 on 10/29/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, retain) NSMutableArray *allCountries;
@property NSIndexPath* selected;

@end
