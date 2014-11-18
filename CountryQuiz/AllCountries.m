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
    }
    return self;
}

-(void)getBorderingCountries{
    for(Country *country in allCountries){
        for(NSString *code in country.borderingCountries){
            for(Country *country2 in allCountries){
                if([code isEqual:country2.countryCode3]){
                    [country.borderingCountryNames insertObject:country2.name atIndex:0];
                    break;
                }
            }
        }
    }
}

@end

