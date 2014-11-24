//
//  HighScoreViewController.m
//  CountryQuiz
//
//  Created by Trevor Meiss on 11/17/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "HighScoreViewController.h"
#import <Parse/Parse.h>

#define highScoreCount 10

@interface HighScoreViewController ()

- (IBAction)backButton:(id)sender;

- (IBAction)difficultyControl:(id)sender;
- (IBAction)quizTypeControl1:(id)sender;
- (IBAction)quizTypeControl2:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyControlOutlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *quizTypeControlOutlet1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *quizTypeControlOutlet2;

@property (weak, nonatomic) IBOutlet UILabel *username1;
@property (weak, nonatomic) IBOutlet UILabel *username2;
@property (weak, nonatomic) IBOutlet UILabel *username3;
@property (weak, nonatomic) IBOutlet UILabel *username4;
@property (weak, nonatomic) IBOutlet UILabel *username5;
@property (weak, nonatomic) IBOutlet UILabel *username6;
@property (weak, nonatomic) IBOutlet UILabel *username7;
@property (weak, nonatomic) IBOutlet UILabel *username8;
@property (weak, nonatomic) IBOutlet UILabel *username9;
@property (weak, nonatomic) IBOutlet UILabel *username10;

@property (weak, nonatomic) IBOutlet UILabel *score1;
@property (weak, nonatomic) IBOutlet UILabel *score2;
@property (weak, nonatomic) IBOutlet UILabel *score3;
@property (weak, nonatomic) IBOutlet UILabel *score4;
@property (weak, nonatomic) IBOutlet UILabel *score5;
@property (weak, nonatomic) IBOutlet UILabel *score6;
@property (weak, nonatomic) IBOutlet UILabel *score7;
@property (weak, nonatomic) IBOutlet UILabel *score8;
@property (weak, nonatomic) IBOutlet UILabel *score9;
@property (weak, nonatomic) IBOutlet UILabel *score10;

@property NSArray *usernameArray;
@property NSArray *scoreArray;

@end

@implementation HighScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.quizTypeControlOutlet1 addTarget:self action:@selector(disableOtherSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.quizTypeControlOutlet2 addTarget:self action:@selector(disableOtherSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    [self initSegmentedControls];
}

- (void)viewWillAppear:(BOOL)animated {
    self.usernameArray = [NSArray arrayWithObjects:self.username1, self.username2, self.username3, self.username4, self.username5, self.username6, self.username7, self.username8, self.username9, self.username10, nil];
    self.scoreArray = [NSArray arrayWithObjects:self.score1, self.score2, self.score3, self.score4, self.score5, self.score6, self.score7, self.score8, self.score9, self.score10, nil];
    
    [self populateLabels];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)difficultyControl:(id)sender {
    self.difficulty = [sender selectedSegmentIndex];
    [self populateLabels];
}

- (IBAction)quizTypeControl1:(id)sender {
    self.quizType = [sender selectedSegmentIndex];
    [self populateLabels];
}

- (IBAction)quizTypeControl2:(id)sender {
    self.quizType = [sender selectedSegmentIndex] + self.quizTypeControlOutlet1.numberOfSegments;
    [self populateLabels];
}

- (void) disableOtherSegmentedControl:(id)sender
{
    if (sender == self.quizTypeControlOutlet1) {
        self.quizTypeControlOutlet2.selectedSegmentIndex = -1;
    }
    else if (sender == self.quizTypeControlOutlet2) {
        self.quizTypeControlOutlet1.selectedSegmentIndex = -1;
    }
}

- (void)initSegmentedControls {
    
    // If we come to the High Scores View after taking a quiz, the segmented controls should match the settings of the quiz taken
    if (self.difficulty > 0 && self.difficulty < self.difficultyControlOutlet.numberOfSegments) {
        self.difficultyControlOutlet.selectedSegmentIndex = self.difficulty;
    }
    else {
        self.difficulty = 0;
        self.difficultyControlOutlet.selectedSegmentIndex = 0;
    }
    
    if (self.quizType > 0 && self.quizType < (self.quizTypeControlOutlet1.numberOfSegments + self.quizTypeControlOutlet2.numberOfSegments)) {
        if (self.quizType < self.quizTypeControlOutlet1.numberOfSegments) {
            self.quizTypeControlOutlet1.selectedSegmentIndex = self.quizType;
        }
        else {
            self.quizTypeControlOutlet2.selectedSegmentIndex = self.quizType - self.quizTypeControlOutlet1.numberOfSegments;
        }
    }
    else {
        self.quizType = 0;
        self.quizTypeControlOutlet1.selectedSegmentIndex = 0;
    }
}

- (void)populateLabels {
    int count = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
    [query orderByDescending:@"score"];
    [query whereKey:@"difficulty" equalTo:[self stringFromDifficulty:self.difficulty]];
    [query whereKey:@"quizType" equalTo:[self stringFromQuizType:self.quizType]];
    
    while (count < highScoreCount)
    {
        query.skip = count;
        PFObject *found = [query getFirstObject];
        if (!found) {
            // No more high scores, so hide the remaining labels
            while (count < highScoreCount) {
                [[self.usernameArray objectAtIndex:count] setHidden:YES];
                [[self.scoreArray objectAtIndex:count] setHidden:YES];
                count++;
            }
        } else {
            [[self.usernameArray objectAtIndex:count] setHidden:NO];
            [[self.usernameArray objectAtIndex:count] setText:[NSString stringWithFormat:@"%d.     %@", (count+1), [found objectForKey:@"playerName"]]];
            
            [[self.scoreArray objectAtIndex:count] setHidden:NO];
            [[self.scoreArray objectAtIndex:count] setText:[found objectForKey:@"score"]];
            
            // Make the text bold for current user scores
            if ([[found objectForKey:@"playerName"] isEqual:[[PFUser currentUser] username]]) {
                [[self.usernameArray objectAtIndex:count] setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [[self.scoreArray objectAtIndex:count] setFont:[UIFont boldSystemFontOfSize:14.0f]];
            }
            
            count++;
        }
    }
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
