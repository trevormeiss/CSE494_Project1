//
//  Country.m
//  CountryQuiz
//
//  Created by mkarlsru on 10/24/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "Country.h"

@implementation Country

-(void)insertInfo:(NSDictionary*)newCountry{
    
    
    self.name = [newCountry objectForKey:@"name"];
    self.population = [[newCountry objectForKey:@"population"] intValue];
    //self.index
    self.capital = [newCountry objectForKey:@"capital"];
    
    @try {
        self.area = [[newCountry objectForKey:@"area"] intValue];
    }
    @catch (NSException *exception) {
        self.area = 0;
    }
    
    //self.area = (int)[newCountry objectForKey:@"area"];
    self.region = [newCountry objectForKey:@"region"];
    self.subregion = [newCountry objectForKey:@"subregion"];
    self.countryCode2 = [newCountry objectForKey:@"alpha2Code"];
    self.countryCode3 = [newCountry objectForKey:@"alpha3Code"];
    self.borderingCountries = [newCountry objectForKey:@"borders"];
    self.learned=false;
}

-(UIImage *)getFlag{
    NSString *countryCode = [self.countryCode2 lowercaseString];
    NSString *imageURL = [NSString stringWithFormat:@"http://www.geonames.org/flags/x/%@.gif",countryCode];
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
}

-(void)getBorderingCountries{
    //Should we make another API call for this, or use our already saved data???
    
    NSArray *borders = self.borderingCountries;
    for(NSString *border in borders) {
        NSString *borderCode = [border lowercaseString];
        NSString *requestString = [NSString stringWithFormat:@"http://restcountries.eu/rest/v1/alpha/%@",borderCode];
        NSData *requestData =[NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
        NSError *e = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:requestData options: NSJSONReadingMutableContainers error: &e];
        NSString *nameOfBorderingCountry = [response objectForKey:@"name"];
        NSLog(@"Bordering country: %@",nameOfBorderingCountry);
    }
}

@end
