//
//  TopScoreObject.m
//  CountryQuiz
//
//  Created by jquale on 11/10/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "TopScoreObject.h"

@implementation TopScoreObject

// initializing the object from parse
-(id)initWithDataFromParse:(NSString *)name
                 theScore:(NSString *)score
{
    if(self = [super init])
    {
        self.userName = name;
        self.userScore = score;
        
    }
    return self;
}


@end
