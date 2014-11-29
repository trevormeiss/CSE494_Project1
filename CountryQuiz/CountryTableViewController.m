//
//  CountryTableViewController.m
//  CountryQuiz
//
//  Created by rrgarci7 on 10/29/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "CountryTableViewController.h"
#import "AllCountries.h"
#import "Country.h"
#import "InfoViewController.h"

@interface CountryTableViewController ()

@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property NSIndexPath* selectedIndex;
@property NSMutableArray *allCountries;
@property NSArray *regionTitles;
@property NSArray *subregionTitles;
@property NSArray *alphaIndexTitles;
@property NSString *sectionType;
- (IBAction)sortButton:(id)sender;


@end


@implementation CountryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionType = @"name";
    self.allCountries = [[AllCountries sharedCountries] allCountries];
    
    self.regionTitles = [[[NSSet setWithArray:[self.allCountries valueForKey:@"region"]] allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.subregionTitles = [[[NSSet setWithArray:[self.allCountries valueForKey:@"subregion"]] allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSMutableSet *mySet = [[NSMutableSet alloc] init];
    for (Country *country in self.allCountries)
    {
        NSString *s = [country valueForKey:@"name"];
        if (s.length > 0 )
            [mySet addObject:[s substringToIndex:1]];
    }
    self.alphaIndexTitles  = [[mySet allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numSections = 1;
    
    if ([self.sectionType isEqualToString:@"name"]) {
        numSections = [self.alphaIndexTitles count];
    } else if ([self.sectionType isEqualToString:@"region"]) {
        numSections = [self.regionTitles count];
    } else if ([self.sectionType isEqualToString:@"subregion"]) {
        numSections = [self.subregionTitles count];
    }
    
    return numSections;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* currentSectionTitle = nil;
    NSInteger numRows = self.allCountries.count;
    
    if ([self.sectionType isEqualToString:@"name"]) {
        currentSectionTitle = [self.alphaIndexTitles objectAtIndex:section];
        numRows = 0;
        for (Country *country in self.allCountries) {
            if ([country.name hasPrefix:currentSectionTitle]) {
                numRows++;
            }
        }
    } else if ([self.sectionType isEqualToString:@"region"]) {
        currentSectionTitle = [self.regionTitles objectAtIndex:section];
        numRows = 0;
        for (Country *country in self.allCountries) {
            if ([country.region isEqualToString:currentSectionTitle]) {
                numRows++;
            }
        }
    } else if ([self.sectionType isEqualToString:@"subregion"]) {
        currentSectionTitle = [self.subregionTitles objectAtIndex:section];
        numRows = 0;
        for (Country *country in self.allCountries) {
            if ([country.subregion isEqualToString:currentSectionTitle]) {
                numRows++;
            }
        }
    }
    
    return numRows;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Country *country = [self countryAtIndexPath:indexPath];
    
    cell.textLabel.text = country.name; // the title
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *indexTitles = nil;
    if ([self.sectionType isEqualToString:@"name"]) {
        indexTitles = self.alphaIndexTitles;
    }
    
    // This looks pretty bad
    /*if ([self.sectionType isEqualToString:@"region"]) {
        indexTitles = self.regionTitles;
    } else if ([self.sectionType isEqualToString:@"subregion"]) {
        indexTitles = self.subregionTitles;
    }*/
    
    return indexTitles;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = [tableView indexPathForSelectedRow];
    [self performSegueWithIdentifier:@"countryToInfo" sender:self];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* headerTitle = nil;
    
    if ([self.sectionType isEqualToString:@"name"]) {
        headerTitle = [self.alphaIndexTitles objectAtIndex:section];
    } else if ([self.sectionType isEqualToString:@"region"]) {
        headerTitle = [self.regionTitles objectAtIndex:section];
    } else if ([self.sectionType isEqualToString:@"subregion"]) {
        headerTitle = [self.subregionTitles objectAtIndex:section];
    }
    
    return headerTitle;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"countryToInfo"])
    {
        InfoViewController *dest = segue.destinationViewController;
        dest.selectedCountry = [self countryAtIndexPath:self.selectedIndex];
    }
}

- (IBAction)sortButton:(id)sender {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Sort countries by"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction *action)
                                  {
                                       //NSLog(@"Cancel action");
                                  }];
    
    UIAlertAction *alphaAction = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Alphabetical", @"Alphabetical action")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      [self sortCountriesByString:@"name" ascending:YES];
                                      self.sectionType = @"name";
                                      [self.tableView reloadData];
                                  }];
    UIAlertAction *regionAction = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Region", @"Region action")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      [self sortCountriesByString:@"region" ascending:YES];
                                      self.sectionType = @"region";
                                      [self.tableView reloadData];
                                  }];
    UIAlertAction *subregionAction = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Subregion", @"Subregion action")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      [self sortCountriesByString:@"subregion" ascending:YES];
                                      self.sectionType = @"subregion";
                                      [self.tableView reloadData];
                                  }];
    UIAlertAction *populationAction = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Population", @"Population action")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      [self sortCountriesByInt:@"population" ascending:NO];
                                      self.sectionType = @"population";
                                      [self.tableView reloadData];
                                  }];
    UIAlertAction *areaAction = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"Area", @"Area action")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      [self sortCountriesByInt:@"area" ascending:NO];
                                      self.sectionType = @"area";
                                      [self.tableView reloadData];
                                  }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:alphaAction];
    [alertController addAction:regionAction];
    [alertController addAction:subregionAction];
    [alertController addAction:populationAction];
    [alertController addAction:areaAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sortCountriesByInt:(NSString *)type ascending:(BOOL)ascendingBool{
    NSComparator comparePopulation = ^(id string1, id string2)
    {
        NSNumber *number1 = [NSNumber numberWithFloat:[string1 floatValue]];
        NSNumber *number2 = [NSNumber numberWithFloat:[string2 floatValue]];
        
        return [number1 compare:number2];
    };
    
    // sort list and create nearest list
    NSSortDescriptor *sortDescriptorNearest = [NSSortDescriptor sortDescriptorWithKey:type ascending:ascendingBool comparator:comparePopulation];
    self.allCountries = (NSMutableArray *)[self.allCountries sortedArrayUsingDescriptors:@[sortDescriptorNearest]];
}

- (void)sortCountriesByString:(NSString *)type ascending:(BOOL)ascendingBool {
    NSSortDescriptor *stringDescriptor = [[NSSortDescriptor alloc] initWithKey:type
                                        ascending:ascendingBool
                                        selector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.allCountries = (NSMutableArray *)[self.allCountries sortedArrayUsingDescriptors:@[stringDescriptor]];
}

- (Country *)countryAtIndexPath:(NSIndexPath *)indexPath {
    Country *country;
    
    if ([self.sectionType isEqualToString:@"name"]) {
        NSString *sectionTitle = [self.alphaIndexTitles objectAtIndex:indexPath.section];
        NSMutableArray *sectionCountries = [[NSMutableArray alloc] init];
        for (Country *countryLoop in self.allCountries)
        {
            if ([[countryLoop valueForKey:@"name"] hasPrefix:sectionTitle]) {
                [sectionCountries addObject:countryLoop];
            }
        }
        
        country = [sectionCountries objectAtIndex:indexPath.row];
    } else if ([self.sectionType isEqualToString:@"region"]) {
        NSString *sectionTitle = [self.regionTitles objectAtIndex:indexPath.section];
        NSMutableArray *sectionCountries = [[NSMutableArray alloc] init];
        for (Country *countryLoop in self.allCountries)
        {
            if ([[countryLoop valueForKey:@"region"] isEqualToString:sectionTitle]) {
                [sectionCountries addObject:countryLoop];
            }
        }
        country = [sectionCountries objectAtIndex:indexPath.row];
        
    } else if ([self.sectionType isEqualToString:@"subregion"]) {
        NSString *sectionTitle = [self.subregionTitles objectAtIndex:indexPath.section];
        NSMutableArray *sectionCountries = [[NSMutableArray alloc] init];
        for (Country *countryLoop in self.allCountries)
        {
            if ([[countryLoop valueForKey:@"subregion"] isEqualToString:sectionTitle]) {
                [sectionCountries addObject:countryLoop];
            }
        }
        country = [sectionCountries objectAtIndex:indexPath.row];
    } else {
        country = [self.allCountries objectAtIndex:indexPath.row];
    }
    
    return country;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
