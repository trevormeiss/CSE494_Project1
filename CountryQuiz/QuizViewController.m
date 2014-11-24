//
//  ViewController.m
//  CountryQuiz
//
//  Created by mkarlsru on 10/22/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "QuizViewController.h"
#import "AllCountries.h"
#import "UNIRest.h"
#import "QuizMenuViewController.h"
#import "QuizResultsViewController.h"
#include <stdlib.h>

#define numQuestions 10
#define limit1 0.25
#define limit2 0.60

//@protocol Country <NSObject>
//@end
@interface QuizViewController ()

@property NSMutableArray *allCountries;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property int currentCountryIndex;
@property NSString *countryName;
@property Country *currentCountry;
@property NSMutableArray *falseAnswers;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *qCountLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic) float progressValue;

@property (weak, nonatomic) IBOutlet UIButton *answer1;
@property (weak, nonatomic) IBOutlet UIButton *answer2;
@property (weak, nonatomic) IBOutlet UIButton *answer3;
@property (weak, nonatomic) IBOutlet UIButton *answer4;
@property id realAnswer;
- (IBAction)answer4:(id)sender;
- (IBAction)answer3:(id)sender;
- (IBAction)answer2:(id)sender;
- (IBAction)answer1:(id)sender;
@property int correct_answer;
@property int score;
@property int currentQuestion;
@property int currentQuestionType;
@property BOOL answered;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
- (IBAction)quitButton:(id)sender;

@end

@implementation QuizViewController

@synthesize progressView,progressValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allCountries = [[AllCountries sharedCountries] allCountries];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.score = 0;
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d",self.score]];
    progressValue = 0.0f;
    self.currentQuestion = 0;
    
    [self nextQuestion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getNewCountry{
    bool quizzable;
    do{
        self.currentCountryIndex = arc4random_uniform((int)[self.allCountries count]);
        self.currentCountry = [self.allCountries objectAtIndex:self.currentCountryIndex];
        
        if(self.quizMeOn == 0)
            quizzable = self.currentCountry.learned;
        else if(self.quizMeOn == 1)
            quizzable = !self.currentCountry.learned;
        else
            quizzable = true;
    }while(!quizzable || (self.currentQuestionType == 5 && [self.currentCountry.borderingCountryNames count] == 0));
    
    [self setText];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView setImage:[self.currentCountry getFlag]];
}

-(void)setText{
    //[self.textView setText:[NSString stringWithFormat:@"%@, %@",self.currentCountry.capital,self.currentCountry.name]];
}

-(void)removeCountryFromList{
    //I don't know if we should use this or not
    //[self.allCountries removeObjectAtIndex:self.currentCountryIndex];
}

-(void)getQuestion{
    self.currentQuestionType = (int)self.quizType;
    
    // User chose random quiz
    if (self.currentQuestionType == 99) {
        self.currentQuestionType = arc4random() % 6;
    }
    
    switch (self.currentQuestionType) {
        case 0:
            [self.question setText:@"Which country's flag is this?"];
            [self getFalseAnswers:@"flag"];
            break;
        case 1:
            [self.question setText:[NSString stringWithFormat:@"What is the capital of %@?",self.currentCountry.name]];
            [self getFalseAnswers:@"capital"];
            break;
        case 2:
            [self.question setText:[NSString stringWithFormat:@"What is the population of %@?",self.currentCountry.name]];
            [self getFalseAnswers:@"population"];
            break;
        case 3:
            [self.question setText:[NSString stringWithFormat:@"What subregion is %@ in?",self.currentCountry.name]];
            [self getFalseAnswers:@"subregion"];
            break;
        case 4:
            [self.question setText:[NSString stringWithFormat:@"What region is %@ in?",self.currentCountry.name]];
            [self getFalseAnswers:@"region"];
            break;
        case 5:
            [self.question setText:[NSString stringWithFormat:@"Which country borders %@?",self.currentCountry.name]];
            [self getFalseAnswers:@"borders"];
            break;
        default:
            [self.question setText:@"Which country's flag is this?"];
            [self getFalseAnswers:@"flag"];
            break;
    }
}

-(void)getFalseAnswers:(NSString *)questionType{
    NSString *realAnswer;
    
    if([questionType  isEqual: @"capital"])
        realAnswer = self.currentCountry.capital;
    else if([questionType  isEqual: @"flag"])
        realAnswer = self.currentCountry.name;
    else if([questionType  isEqual: @"population"]){
        int rounded = 1000000*((self.currentCountry.population+500000)/1000000);
        realAnswer = [NSNumberFormatter localizedStringFromNumber:@(rounded)
                                                      numberStyle:NSNumberFormatterDecimalStyle];//[@(self.currentCountry.population) stringValue];
        if([realAnswer isEqual: @"0"]){
            realAnswer = @"<1,000,000";
        }
    }
    else if([questionType isEqual:@"subregion"]){
        realAnswer = self.currentCountry.subregion;
    }
    else if([questionType isEqual:@"region"]){
        realAnswer = self.currentCountry.region;
    }
    else if([questionType isEqual:@"borders"]){
        //pick random border
        int randomIndex = arc4random_uniform((int)[self.currentCountry.borderingCountryNames count]);
        realAnswer = [self.currentCountry.borderingCountryNames objectAtIndex:randomIndex];
    }
    
    //get three false answers
    self.falseAnswers = [[NSMutableArray alloc]init];
    int numOfFalseAnswers = 0;
    while(numOfFalseAnswers < 3){
        int randomIndex = arc4random_uniform((int)[self.allCountries count]);
        Country *country = [self.allCountries objectAtIndex:randomIndex];
        NSString *answer;
        if([questionType  isEqual: @"capital"])
            answer = country.capital;
        else if([questionType  isEqual: @"flag"])
            answer = country.name;
        else if([questionType  isEqual: @"population"]){
            int rounded = 1000000*((country.population+500000)/1000000);
            answer = [NSNumberFormatter localizedStringFromNumber:@(rounded)
                                                      numberStyle:NSNumberFormatterDecimalStyle];//[@(country.population) stringValue];
            if([answer isEqual: @"0"]){
                answer = @"<1,000,000";
            }
        }
        else if ([questionType isEqual:@"subregion"]){
            answer = country.subregion;
        }
        else if([questionType isEqual:@"region"]){
            answer = country.region;
        }
        else if([questionType isEqual:@"borders"]){
            answer = country.name;
        }
        
        if([questionType isEqual:@"borders"] && ([self.currentCountry.borderingCountryNames containsObject:answer] || [answer isEqual:self.currentCountry.name])){
            //need to get another answer
        }
        else if(![self.falseAnswers containsObject:answer] && [answer length] != 0 && ![answer isEqual:realAnswer]){
            [self.falseAnswers insertObject:answer atIndex:0];
            numOfFalseAnswers++;
        }
    }
    
    NSMutableArray *arrayOfAnswers = [NSMutableArray arrayWithObjects:self.answer1,self.answer2,self.answer3,self.answer4, nil];
    
    while(numOfFalseAnswers != 0){
        int randomIndex = arc4random_uniform((int)[arrayOfAnswers count]);
        [[arrayOfAnswers objectAtIndex:randomIndex] setTitle:[self.falseAnswers objectAtIndex:numOfFalseAnswers - 1] forState:UIControlStateNormal];
        [arrayOfAnswers removeObjectAtIndex:randomIndex];
        numOfFalseAnswers--;
    }
    
    //add real answer
    [[arrayOfAnswers objectAtIndex:0] setTitle:realAnswer forState:UIControlStateNormal];
    self.realAnswer = [arrayOfAnswers objectAtIndex:0];
}

-(void)resetButtonColors{
    [self.answer1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.answer2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.answer3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.answer4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)nextQuestion{
    if (self.currentQuestion < numQuestions) {
        [self resetProgressView];
        [self resetButtonColors];
        [self getNewCountry];
        [self getQuestion];
        self.currentQuestion++;
        self.qCountLabel.text = [NSString stringWithFormat:@"Question %d/%d", self.currentQuestion, numQuestions];
        self.answered = NO;
        [self enableButtons];
        [self increaseProgressValue];
    }
    else {
        [self endQuiz];
    }
}
- (IBAction)answer1:(id)sender {
    [self evaluateScore:self.answer1];
}
- (IBAction)answer2:(id)sender {
    [self evaluateScore:self.answer2];
}
- (IBAction)answer3:(id)sender {
    [self evaluateScore:self.answer3];
}
- (IBAction)answer4:(id)sender {
    [self evaluateScore:self.answer4];
}

-(void)evaluateScore:(id)selectedAnswer{
    self.answered = YES;
    [self disableButtons];
    if([selectedAnswer currentTitle] == [self.realAnswer currentTitle]){
        //correct answer
        int scoreAdd = 1;
        if (progressValue < limit1) {
            scoreAdd = 4;
        }
        else if (progressValue < limit2) {
            scoreAdd = 3;
        }
        else if (progressValue < 1) {
            scoreAdd = 2;
        }
        self.score += scoreAdd;
        [selectedAnswer setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    else{
        //wrong answer
        //self.score --;
        [selectedAnswer setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.realAnswer setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d",self.score]];
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(nextQuestion)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)disableButtons {
    self.answer1.enabled = NO;
    self.answer2.enabled = NO;
    self.answer3.enabled = NO;
    self.answer4.enabled = NO;
}

- (void)enableButtons {
    self.answer1.enabled = YES;
    self.answer2.enabled = YES;
    self.answer3.enabled = YES;
    self.answer4.enabled = YES;
}

- (void)endQuiz {
    [self performSegueWithIdentifier:@"quizResults" sender:self];
}

-(void)increaseProgressValue {
    if(progressView.progress < 1 && !self.answered)
    {
        progressValue = progressValue+0.02;
        progressView.progress = progressValue;
        if (progressValue < limit1) {
            progressView.progressTintColor = [UIColor greenColor];
        }
        else if (progressValue < limit2) {
            progressView.progressTintColor = [UIColor yellowColor];
        }
        else {
            progressView.progressTintColor = [UIColor orangeColor];
        }
        
        [self performSelector:@selector(increaseProgressValue) withObject:self afterDelay:0.1];
    }
    if (progressView.progress >= 1 && !self.answered) {
        progressView.progressTintColor = [UIColor redColor];
    }
}

-(void)resetProgressView {
    progressValue = 0;
    progressView.progress = 0;
}


- (IBAction)quitButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual: @"quizResults"]){
        QuizResultsViewController *dest = segue.destinationViewController;

        dest.difficulty = self.difficulty;
        dest.quizType = self.quizType;
        dest.score = self.score;
        dest.quizMeOn = self.quizMeOn;
    }
}

@end
