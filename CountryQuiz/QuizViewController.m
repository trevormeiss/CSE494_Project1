//
//  ViewController.m
//  CountryQuiz
//
//  Created by mkarlsru on 10/22/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "QuizViewController.h"
#import "UNIRest.h"
#import "QuizMenuViewController.h"
#import "DXAlertView.h"
#include <stdlib.h>
#include <Parse/Parse.h>

#define numQuestions 10
//#define limit1 0.25
//#define limit2 0.60

#define limit1 0.10
#define limit2 0.10

//@protocol Country <NSObject>
//@end
@interface QuizViewController ()

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
@property BOOL answered;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
- (IBAction)quitButton:(id)sender;

//parse values
@property NSString *parseObjectID;
@property NSString *parseQuizType;
@property int parseQuizHighScore;
@property bool addNewItem;

@end

@implementation QuizViewController

@synthesize progressView,progressValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addNewItem = false;
    // Do any additional setup after loading the view, typically from a nib.
    //[self removeCountryFromList];
    
    progressValue = 0.0f;
    self.currentQuestion = 0;
    
    [self queryParse];
    [self nextQuestion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getNewCountry{
    self.currentCountryIndex = arc4random_uniform((int)[self.allCountries count]);
    self.currentCountry = [self.allCountries objectAtIndex:self.currentCountryIndex];
    [self setText];
    [self.imageView setImage:[self.currentCountry getFlag]];
}

-(void)setText{
    //[self.textView setText:[NSString stringWithFormat:@"%@, %@",self.currentCountry.capital,self.currentCountry.name]];
}

-(void)removeCountryFromList{
    //I don't know if we should use this or not
    [self.allCountries removeObjectAtIndex:self.currentCountryIndex];
}

-(void)getQuestion{
    int currentQuizType = self.quizType;
    
    // User chose random quiz
    if (currentQuizType == 5) {
        currentQuizType = arc4random() % 4;
        
        //reupdating quiz type if it's random
        self.quizType = currentQuizType;
    }
    
    switch (currentQuizType) {
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
        
        if(![self.falseAnswers containsObject:answer] && [answer length] != 0 && ![answer isEqual:realAnswer]){
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
    
    PFUser *User = [PFUser currentUser];
    
    if (self.parseQuizHighScore < self.score && self.addNewItem == false){
        //updating the value of the score following parse docs
        PFQuery *query = [PFQuery queryWithClassName:@"Scores"];
        [query whereKey:@"username" equalTo:User.username];
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:self.parseObjectID block:^(PFObject *score, NSError *error) {
            
            // Now let's update it with some new data. In this case, only cheatMode and score
            // will get sent to the cloud. playerName hasn't changed.
            score[@"score"] = [NSNumber numberWithInt:self.score];
            score[@"quizType"] = self.parseQuizType;
            [score saveInBackground];
            
        }];
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"Congratulations" contentText:[NSString stringWithFormat:@"New high score of %d!", self.score] leftButtonTitle:nil rightButtonTitle:@"Done"];
        [alert show];
        alert.rightBlock = ^() {
            //NSLog(@"Button clicked");
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        alert.dismissBlock = ^() {
            //NSLog(@"Do something interesting after dismiss block");
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    //not a new high score
    else if (self.parseQuizHighScore >= self.score && self.addNewItem == false)
    {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Score: %d", self.score] contentText:@"Not a high score" leftButtonTitle:nil rightButtonTitle:@"Done"];
        [alert show];
        alert.rightBlock = ^() {
            //NSLog(@"Button clicked");
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        alert.dismissBlock = ^() {
            //NSLog(@"Do something interesting after dismiss block");
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    
    if (self.addNewItem == true)
    {
        PFUser *User = [PFUser currentUser];
        //if no objects were received from parse add a new one
        PFObject *parseUser = [PFObject objectWithClassName:@"Scores"];
        parseUser[@"score"] = [NSNumber numberWithInt:self.score];
        parseUser[@"quizType"] = [self getQuizTypeString:self.quizType];
        parseUser[@"username"] = User.username;
        [parseUser saveInBackground];
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"Congratulations" contentText:[NSString stringWithFormat:@"New high score of %d!", self.score] leftButtonTitle:nil rightButtonTitle:@"Done"];
        [alert show];
        alert.rightBlock = ^() {
            //NSLog(@"Button clicked");
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        alert.dismissBlock = ^() {
            //NSLog(@"Do something interesting after dismiss block");
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
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

- (NSString *) getQuizTypeString:(int) currentQuizType
{
    NSString * quizType;
    
    switch (currentQuizType) {
        case 0:
            quizType = @"flag";
            break;
        case 1:
            quizType = @"capital";
            break;
        case 2:
            quizType = @"population";
            break;
        case 3:
            quizType = @"subregion";
            break;
        default:
            quizType = @"invalid";
            break;
    }
    
    return quizType;
}

-(void) queryParse
{
    PFUser *User = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Scores"];
    //NSLog(@"%@", User.username);
    [query whereKey:@"username" equalTo:User.username];
    [query whereKey:@"quizType" equalTo:[self getQuizTypeString:self.quizType]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                //NSLog(@"%@", object.objectId);
                
                //getting the values from parse
                self.parseObjectID = object.objectId;
                self.parseQuizType = object[@"quizType"];
                self.parseQuizHighScore = [object[@"score"] intValue];
            }
            if (objects.count == 0)
            {
                //if no objects were received from parse set flag to add a new one
                self.addNewItem = true;
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
