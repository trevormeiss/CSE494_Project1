//
//  MainMenuViewController.m
//  CountryQuiz
//
//  Created by mkarlsru on 10/27/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "MainMenuViewController.h"
#import "QuizMenuViewController.h"
#import "CountryTableViewController.h" 
#import "AllCountries.h"
#import <Parse/Parse.h>

@interface MainMenuViewController ()

- (IBAction)LogOutButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property NSMutableArray *allCountries;
@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Call this just to load the Countries while the user decides what to do
    if([PFUser currentUser])
        self.allCountries = [[AllCountries sharedCountries] allCountries];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %@", [[PFUser currentUser] objectForKey:@"score"]];
    self.usernameLabel.text = [[PFUser currentUser] username];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        [self showLogInView];
    }
}

- (void)showLogInView {
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    [logInViewController setFields: PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten];
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
     
    /* self.view.backgroundColor = [UIColor colorWithPatternImage:
     [UIImage imageNamed:@"Flags_Background.jpg"]]; */
    /*label.text = @"My Logo";
     [label sizeToFit];
     self.logInView.logo = label; // logo can be any UIView*/
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
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
    if([segue.identifier isEqual: @"quiz"]){
        //QuizMenuViewController *dest = segue.destinationViewController;
        //dest.allCountries = self.allCountries;
    }
    else if([segue.identifier isEqual: @"learn"]){
        //CountryTableViewController *dest = segue.destinationViewController;
        //dest.allCountries = self.allCountries;
    }
    else if([segue.identifier isEqual: @"highScore"]){
        
    }
}

#pragma mark - Parse Stuff

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    //self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %@", [[PFUser currentUser] objectForKey:@"score"]];
    self.usernameLabel.text = [[PFUser currentUser] username];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    //Sign up user with highScore of 0
    
    //user[@"score"] = @(self.score);
    [user save];
    
    [self dismissViewControllerAnimated:YES completion:Nil]; // Dismiss the PFSignUpViewController
    
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (IBAction)LogOutButton:(id)sender {
    [PFUser logOut];
    [self showLogInView];
}
@end
