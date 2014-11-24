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
#import <Social/Social.h>

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
    
    PFObject *gameScore = [PFObject objectWithClassName:@"GameScore"];
    gameScore[@"score"] = [NSString stringWithFormat:@"%ld", (long)self.score];
    gameScore[@"playerName"] = [[PFUser currentUser] username];
    gameScore[@"difficulty"] = [self stringFromDifficulty:self.difficulty];
    gameScore[@"quizType"] = [self stringFromQuizType:self.quizType];
    [gameScore saveInBackground];
    
    //TODO: implement a way to save score based on difficulty and quiz type
    //Update highScoreLabel
}

- (IBAction)postToFacebook:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText: [NSString stringWithFormat:@"I just got a score of %ld on the %@ quiz on the CountryQuiz iOS app!", (long)self.score, self.quizTypeLabel.text]];
    [self presentViewController:controller animated:YES completion:Nil];
    
}

- (IBAction)postToTwitter:(id)sender {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText: [NSString stringWithFormat:@"I just got a score of %ld on the %@ quiz on the CountryQuiz iOS app!", (long)self.score, self.quizTypeLabel.text]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (void)setLabels {

    self.difficultyLabel.text = [NSString stringWithFormat:@"Difficulty: %@", [self stringFromDifficulty:self.difficulty]];
    self.quizTypeLabel.text = [NSString stringWithFormat:@"%@", [self stringFromQuizType:self.quizType]];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.score];
}

- (NSString *)stringFromDifficulty:(NSInteger)difficulty {
    NSString *diff;
    
    switch (difficulty) {
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
    
    return diff;
}

- (NSString *)stringFromQuizType:(NSInteger)quizType {
    NSString *qType;
    
    switch (quizType) {
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
    
    return qType;
}

@end
