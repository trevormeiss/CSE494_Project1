//
//  InfoViewController.m
//  CountryQuiz
//
//  Created by rrgarci7 on 10/29/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "InfoViewController.h"
#import "AllCountries.h"
#import "Country.h"

@interface InfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *popCount;
@property (weak, nonatomic) IBOutlet UILabel *countryCap;
@property (weak, nonatomic) IBOutlet UILabel *countryRegion;
@property (weak, nonatomic) IBOutlet UILabel *countrySubr;
@property (weak, nonatomic) IBOutlet UIImageView *flagPic;
@property (weak, nonatomic) IBOutlet UILabel *area;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISwitch *learnedSwitch;
@property (weak, nonatomic) IBOutlet UILabel *learnedLabel;
@property NSIndexPath* selected;

@property NSMutableArray *allCountries;
@property Country *country;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allCountries = [[AllCountries sharedCountries] allCountries];
    
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
    self.flagPic.contentMode = UIViewContentModeScaleAspectFit;
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

- (IBAction)learned:(id)sender {
    if(self.learnedSwitch.on){
        self.country.learned = true;
        self.learnedLabel.text = @"Learned!";
    }
    else{
        self.country.learned = false;
        self.learnedLabel.text = @"Not learned";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // this method is more complicated with multiple sections
    return [self.country.borderingCountryObjects count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //cell.imageView.image = self.constellationImages[indexPath.row]; // a UIImage
    Country *country = [self.country.borderingCountryObjects objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    cell.textLabel.text = country.name; // the title
    // cell.detailTextLabel.text = self.constellationDetail[indexPath.row]; // the subtitle
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];
    else
        cell.backgroundColor = [UIColor whiteColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //_selected = [tableView indexPathForSelectedRow];
    //[self performSegueWithIdentifier:@"countryToInfo" sender:self];
}

@end
