//
//  HighScoresViewController.m
//  CountryQuiz
//
//  Created by twslezak on 11/10/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "HighScoresViewController.h"
#include <Parse/Parse.h>

@interface HighScoresViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *flagsScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *capitalsScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *populationScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *subregionScoreLabel;

@end

@implementation HighScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self queryParseAndUpdateLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)queryParseAndUpdateLabels
{
    self.usernameLabel.text = [[PFUser currentUser] username];
    //self.flagsScoreLabel.text = [NSString stringWithFormat:@"%d", [self getScoreFromParse:@"flag"]];
    [self getScoreFromParse:@"flag" labelName:0];
    [self getScoreFromParse:@"capital" labelName:1];
    [self getScoreFromParse:@"population" labelName:2];
    [self getScoreFromParse:@"subregion" labelName:3];
    
    
}

-(void)getScoreFromParse:(NSString*)quizType labelName:(int)label
{
    
    PFUser *User = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Scores"];
    //NSLog(@"%@", User.username);
    [query whereKey:@"username" equalTo:User.username];
    [query whereKey:@"quizType" equalTo:quizType];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                //NSLog(@"%@", object.objectId);
                
                //getting the values from parse
                //self.parseObjectID = object.objectId;
                //self.parseQuizType = object[@"quizType"];
                //scoreToReturn = [NSString stringWithFormat:@"%d", [object[@"score"] intValue]];
                switch(label)
                {
                    case 0:
                        self.flagsScoreLabel.text = [NSString stringWithFormat:@"%d", [object[@"score"] intValue]];
                        break;
                    case 1:
                        self.capitalsScoreLabel.text = [NSString stringWithFormat:@"%d", [object[@"score"] intValue]];
                        break;
                    case 2:
                        self.populationScoreLabel.text = [NSString stringWithFormat:@"%d", [object[@"score"] intValue]];
                        break;
                    case 3:
                        self.subregionScoreLabel.text = [NSString stringWithFormat:@"%d", [object[@"score"] intValue]];
                        break;
                    default:
                
                        break;
                }
                
                //NSLog(@"%d", scoreToReturn);
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    //return scoreToReturn;
}


@end
