//
//  ScoreBoardViewController.h
//  CountryQuiz
//
//  Created by jquale on 11/10/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreBoardViewController : UIViewController
    <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray* scoreArray;

- (void)loadTopScore;

@end
