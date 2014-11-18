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
- (IBAction)tryAgainButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *quizTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;

@end


@implementation QuizResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLabels];
    [self checkForHighScore];
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

- (IBAction)tryAgainButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkForHighScore {
    //TODO: implement a way to save score based on difficulty and quiz type
    //Update highScoreLabel
}

- (void)setLabels {
    NSString *diff, *qType;
    
    switch (self.difficulty) {
        case 0:
            diff = @"Easy";
            break;
        case 1:
            diff = @"Medium";
            break;
        case 2:
            diff = @"Hard";
            break;
        default:
            diff = @"Unknown";
            break;
    }
    
    switch (self.quizType) {
        case 0:
            qType = @"Flags";
            break;
        case 1:
            qType = @"Capitals";
            break;
        case 2:
            qType = @"Population";
            break;
        case 3:
            qType = @"Subregion";
            break;
        case 4:
            qType = @"Region";
            break;
        case 5:
            qType = @"Borders";
            break;
        case 99:
            qType = @"Random";
            break;
        default:
            qType = @"Unknown";
            break;
    }
    
    self.difficultyLabel.text = diff;
    self.quizTypeLabel.text = qType;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.score];
}

@end
