//
//  TopScoreObject.h
//  CountryQuiz
//
//  Created by jquale on 11/10/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopScoreObject : NSObject

@property NSString* userName;
@property NSString* userScore;

-(id)initWithDataFromParse:(NSString *)name
                  theScore:(NSString *)score;


@end
