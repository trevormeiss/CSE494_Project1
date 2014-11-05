//
//  Country.h
//  CountryQuiz
//
//  Created by mkarlsru on 10/24/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Country : NSObject
@property NSString *name;
@property int population;
@property int index;
@property NSString *capital;
@property int area;
@property NSString *region;
@property NSString *subregion;
@property NSString *countryCode2;
@property NSString *countryCode3;
@property NSArray *borderingCountries;
@property bool learned;
-(void)insertInfo:(NSDictionary*)newCountry;
-(UIImage *)getFlag;

@end
