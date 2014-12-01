//
//  PopulationViewController.h
//  CountryQuiz
//
//  Created by mkarlsru on 12/1/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface PopulationViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property NSString *countryCode;
@property NSString *countryName;

@end
