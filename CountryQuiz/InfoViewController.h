//
//  InfoViewController.h
//  CountryQuiz
//
//  Created by rrgarci7 on 10/29/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *popCount;
@property (weak, nonatomic) IBOutlet UILabel *countryCap;
@property (weak, nonatomic) IBOutlet UILabel *countryRegion;
@property (weak, nonatomic) IBOutlet UILabel *countrySubr;
@property (weak, nonatomic) IBOutlet UIImageView *flagPic;
@property (weak, nonatomic) IBOutlet UILabel *area;



@property (nonatomic, retain) NSMutableArray *allCountries;
@property NSIndexPath *selectedCountry;
@end
