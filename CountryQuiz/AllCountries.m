//
//  AllCountries1.m
//  CountryQuiz
//
//  Created by Trevor Meiss on 11/17/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "AllCountries.h"
#import "Country.h"

@implementation AllCountries

@synthesize allCountries;

+ (id)sharedCountries {
    static AllCountries *sharedCountries = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCountries = [[self alloc] init];
    });
    
    return sharedCountries;
}

- (id)init {
    if (self = [super init]) {
        allCountries = [[NSMutableArray alloc] initWithObjects:nil];
        
        NSString *requestString = @"http://restcountries.eu/rest/v1";
        NSData *requestData =[NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
        NSError *e = nil;
        NSArray *countryArray = [NSJSONSerialization JSONObjectWithData:requestData options: NSJSONReadingMutableContainers error: &e];
        
        for(NSDictionary *countryData in countryArray) {
            Country *newCountry = [[Country alloc]init];
            [newCountry insertInfo:countryData];
            [allCountries insertObject:newCountry atIndex:0];
        }
        
        //reverse order of countries
        allCountries = (NSMutableArray *)[[allCountries reverseObjectEnumerator] allObjects];
        [self getBorderingCountries];
        [self loadUserLearnedInfo];
    }
    return self;
}

-(void)getBorderingCountries{
    for(Country *country in allCountries){
        for(NSString *code in country.borderingCountries){
            for(Country *country2 in allCountries){
                if([code isEqual:country2.countryCode3]){
                    [country.borderingCountryObjects insertObject:country2  atIndex:0];
                    [country.borderingCountryNames insertObject:country2.name atIndex:0];
                    break;
                }
            }
        }
    }
}

-(void)loadUserLearnedInfo{
    PFQuery *query = [PFQuery queryWithClassName:@"UserLearned"];
    [query whereKey:@"user" equalTo:[[PFUser currentUser] username]];
    
    NSMutableDictionary *learnedInfo = [[NSMutableDictionary alloc] init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *row in objects)
        {
            NSString *countryName = row[@"countryName"];
            bool learned = [row[@"learned"] boolValue];
            [learnedInfo setObject:@(learned) forKey:countryName];
        }
        for(Country *country in allCountries){
            NSString *countryName = country.name;
            country.learned = [learnedInfo[countryName] boolValue];
        }
    }];
}

/*
-(void)saveUserLearnedInfo{
    //Save total to Parse
    
    for(Country *country in allCountries){
        NSString *countryName = country.name;
        bool learned = country.learned;
        
        PFObject *row = [PFObject objectWithClassName:@"UserLearned"];
        [row setObject:countryName forKey:@"countryName"];
        [row setObject:@(learned) forKey:@"learned"];
        [row setObject:[[PFUser currentUser] username] forKey:@"user"];
        //commit the new object to the parse database
        [row saveInBackground];
    }
}
*/


@end

