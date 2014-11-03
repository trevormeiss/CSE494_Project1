//
//  InfoViewController.m
//  CountryQuiz
//
//  Created by rrgarci7 on 10/29/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "InfoViewController.h"
#import "Country.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Country *country = [self.allCountries objectAtIndex:_selectedCountry.row];
    NSString *popString = [NSNumberFormatter localizedStringFromNumber:@(country.population)
                                                           numberStyle:NSNumberFormatterDecimalStyle];//[NSString stringWithFormat:@"%d", country.population];
    NSString *areaString = [NSNumberFormatter localizedStringFromNumber:@(country.area)
                                                            numberStyle:NSNumberFormatterDecimalStyle];//[NSString stringWithFormat:@"%d", country.area];
    areaString = [NSString stringWithFormat:@"%@ km\u00b2",areaString];
    self.name.text=country.name;
    self.countryRegion.text = country.region;
    self.countryCap.text = country.capital;
    self.countrySubr.text = country.subregion;
    self.popCount.text = popString;
    self.area.text = areaString;
    [self.flagPic setImage:[country getFlag]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
