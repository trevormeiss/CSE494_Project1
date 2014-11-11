//
//  ScoreBoardViewController.m
//  CountryQuiz
//
//  Created by jquale on 11/10/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "TopScoreObject.h"
#import <Parse/Parse.h>

@interface ScoreBoardViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ScoreBoardViewController

- (void)viewDidLoad
{
     self.scoreArray = [[NSMutableArray alloc] init];
    [self loadTopScore];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTopScore
{
    
    PFQuery* query = [PFQuery queryWithClassName:@"_User"];
    query.limit = 10;
    
    // Sorts the results in order by the score field
    [query orderByDescending:@"score"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects)
            {
                NSString* pName = object[@"username"];
                NSString* pScore = object[@"score"];
                
                TopScoreObject* TSO = [[TopScoreObject alloc] initWithDataFromParse:pName theScore:pScore];
                
                [self.scoreArray addObject:TSO];
            }
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        NSMutableArray *newIndexPaths = [NSMutableArray new];
        for(int i=0; i<self.scoreArray.count; i++)
        {
            [newIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
    }];
    
}

#pragma mark - TableViewDelegation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scoreArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create cell
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    TopScoreObject* topScore = self.scoreArray[indexPath.row];

    NSString* testString = [NSString stringWithFormat:@"%@  %@  %@", topScore.userName, @" - ", topScore.userScore];
    cell.textLabel.text = testString;

    return cell;
}
@end
