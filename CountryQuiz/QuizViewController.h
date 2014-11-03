//
//  ViewController.h
//  CountryQuiz
//
//  Created by mkarlsru on 10/22/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface QuizViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *allCountries;
@property int quizType;
@end

