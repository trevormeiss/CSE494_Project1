//
//  QuizMenuViewController.m
//  CountryQuiz
//
//  Created by mkarlsru on 10/27/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "QuizMenuViewController.h"
#import "QuizViewController.h"

@interface QuizMenuViewController ()
- (IBAction)flagButton:(id)sender;
- (IBAction)capitalButton:(id)sender;
- (IBAction)populationButton:(id)sender;
- (IBAction)subregionButton:(id)sender;
- (IBAction)randomButton:(id)sender;
@property int quizType;
@end

@implementation QuizMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"count:%d",[self.allCountries count]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    QuizViewController *dest = segue.destinationViewController;
    dest.allCountries = self.allCountries;
    dest.quizType = self.quizType;
}


- (IBAction)flagButton:(id)sender {
    self.quizType = 0;
    [self performSegueWithIdentifier: @"startQuiz" sender:self];
}

- (IBAction)capitalButton:(id)sender {
    self.quizType = 1;
    [self performSegueWithIdentifier: @"startQuiz" sender:self];
}

- (IBAction)populationButton:(id)sender {
    self.quizType = 2;
    [self performSegueWithIdentifier: @"startQuiz" sender:self];
}

- (IBAction)subregionButton:(id)sender {
    self.quizType = 3;
    [self performSegueWithIdentifier: @"startQuiz" sender:self];
}

- (IBAction)regionButton:(id)sender {
    self.quizType = 4;
    [self performSegueWithIdentifier: @"startQuiz" sender:self];
}

- (IBAction)randomButton:(id)sender {
    self.quizType = 5;
    [self performSegueWithIdentifier: @"startQuiz" sender:self];
}

@end
