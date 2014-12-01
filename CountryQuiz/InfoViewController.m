//
//  InfoViewController.m
//  CountryQuiz
//
//  Created by rrgarci7 on 10/29/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "InfoViewController.h"
#import "AllCountries.h"

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

@property Country *country;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.country = self.selectedCountry;
    
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
    [self setLearnedSwitch];
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
    [self saveUserLearnedInfo:self.country];
}

-(void)setLearnedSwitch{
    if(self.country.learned){
        self.learnedSwitch.on = true;
        self.learnedLabel.text = @"Learned!";
    }
    else{
        self.learnedSwitch.on = false;
        self.learnedLabel.text = @"Not learned";
    }
}

-(void)saveUserLearnedInfo:(Country *)countryToSave{
    //Save total to Parse
    
    NSString *countryName = countryToSave.name;
    bool learned = countryToSave.learned;
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserLearned"];
    [query whereKey:@"user" equalTo:[[PFUser currentUser] username]];
    [query whereKey:@"countryName" equalTo:countryName];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            //NSLog(@"Found Country");
            // Found UserStats
            PFObject *row = [objects objectAtIndex:0];
            [row setObject:@(learned) forKey:@"learned"];
            // Save
            [row saveInBackground];
        } else {
            // Did not find any stats on the country for the current user
            //NSLog(@"Saving new object");
            PFObject *row = [PFObject objectWithClassName:@"UserLearned"];
            [row setObject:countryName forKey:@"countryName"];
            [row setObject:@(learned) forKey:@"learned"];
            [row setObject:[[PFUser currentUser] username] forKey:@"user"];
            //commit the new object to the parse database
            [row saveInBackground];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PopulationViewController *dest = segue.destinationViewController;
    dest.countryCode = self.country.countryCode3;
    dest.countryName = self.country.name;
}

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
    /*if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];
    else
        cell.backgroundColor = [UIColor whiteColor];*/
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //_selected = [tableView indexPathForSelectedRow];
    //[self performSegueWithIdentifier:@"countryToInfo" sender:self];
}

@end
