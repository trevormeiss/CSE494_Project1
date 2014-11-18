//
//  HighScoreViewController.m
//  CountryQuiz
//
//  Created by Trevor Meiss on 11/17/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "HighScoreViewController.h"

@interface HighScoreViewController ()

- (IBAction)backButton:(id)sender;

- (IBAction)difficultyControl:(id)sender;
- (IBAction)quizTypeControl1:(id)sender;
- (IBAction)quizTypeControl2:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyControlOutlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *quizTypeControlOutlet1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *quizTypeControlOutlet2;

@end

@implementation HighScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.quizTypeControlOutlet1 addTarget:self action:@selector(disableOtherSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.quizTypeControlOutlet2 addTarget:self action:@selector(disableOtherSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    [self initSegmentedControls];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)difficultyControl:(id)sender {
    self.difficulty = [sender selectedSegmentIndex];
}

- (IBAction)quizTypeControl1:(id)sender {
    self.quizType = [sender selectedSegmentIndex];
}

- (IBAction)quizTypeControl2:(id)sender {
    self.quizType = [sender selectedSegmentIndex] + self.quizTypeControlOutlet1.numberOfSegments;
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

- (void) initSegmentedControls {
    
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

@end
