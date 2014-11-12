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
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property Country *country;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.country = [self.allCountries objectAtIndex:_selectedCountry.row];
    NSString *popString = [NSNumberFormatter localizedStringFromNumber:@(self.country.population)
                                                           numberStyle:NSNumberFormatterDecimalStyle];//[NSString stringWithFormat:@"%d", country.population];
    NSString *areaString = [NSNumberFormatter localizedStringFromNumber:@(self.country.area)
                                                            numberStyle:NSNumberFormatterDecimalStyle];//[NSString stringWithFormat:@"%d", country.area];
    areaString = [NSString stringWithFormat:@"%@ km\u00b2",areaString];
    self.name.text=self.country.name;
    self.countryRegion.text = self.country.region;
    self.countryCap.text = self.country.capital;
    self.countrySubr.text = self.country.subregion;
    self.popCount.text = popString;
    self.area.text = areaString;
    [self.flagPic setImage:[self.country getFlag]];
    [self getMap];
}

-(void)getMap{
    CLLocationCoordinate2D countryCoodinates;
    countryCoodinates.latitude = self.country.latitude;
    countryCoodinates.longitude= self.country.longitude;
    
    //Figure out how far to zoom in
    double zoomDistance = self.country.area + (self.country.area)/3;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(countryCoodinates, zoomDistance, zoomDistance);
    
    [self.mapView setRegion:viewRegion animated:YES];
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
