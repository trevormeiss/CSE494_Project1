//
//  AllCountries1.h
//  CountryQuiz
//
//  Created by Trevor Meiss on 11/17/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AllCountries : NSObject {
    NSMutableArray *allCountries;
}

@property (nonatomic, retain) NSMutableArray *allCountries;

+ (id)sharedCountries;
+ (void)loadUserLearnedInfo:(NSMutableArray *)allCountries;

@end
