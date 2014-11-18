//
//  QuizResultsViewController.m
//  CountryQuiz
//
//  Created by Trevor Meiss on 11/17/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "QuizResultsViewController.h"
#import "HighScoreViewController.h"
#import "MainMenuViewController.h"
#import <Parse/Parse.h>

@interface QuizResultsViewController ()
- (IBAction)mainMenuButton:(id)sender;

@end


@implementation QuizResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual: @"highScore"]){
        HighScoreViewController *dest = segue.destinationViewController;
        dest.difficulty = self.difficulty;
        dest.quizType = self.quizType;
    }
}

- (IBAction)mainMenuButton:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainMenuViewController *mainMenuVC = [storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainMenuVC];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
