//
//  PopulationViewController.m
//  CountryQuiz
//
//  Created by mkarlsru on 12/1/14.
//  Copyright (c) 2014 mkarlsru. All rights reserved.
//

#import "PopulationViewController.h"

@interface PopulationViewController ()

@property NSArray *entries;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;
@property (weak, nonatomic) IBOutlet UILabel *popLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PopulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPopulationStats];
    
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableTouchReport = YES;
    [self.titleLabel setText:self.countryName];
    if([self.entries count] > 0){
        NSInteger population = [[[self.entries objectAtIndex:[self.entries count]-1] valueForKey:@"value"] integerValue];
    
        [self.popLabel setText:[NSNumberFormatter localizedStringFromNumber:@(population)
                                                            numberStyle:NSNumberFormatterDecimalStyle]];
        [self.yearLabel setText:[NSString stringWithFormat:@"in %@", [[self.entries objectAtIndex:[self.entries count]-1] valueForKey:@"date"]]];
    }
    else{
        self.popLabel.text = @"No info";
        self.yearLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return [self.entries count]; // Number of points in the graph.
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 5;
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    // Here you could change the text of a UILabel with the value of the closest index for example.
    
    NSInteger population = [[[self.entries objectAtIndex:index] valueForKey:@"value"] integerValue];
    
    [self.popLabel setText:[NSNumberFormatter localizedStringFromNumber:@(population)
                                     numberStyle:NSNumberFormatterDecimalStyle]];
    
    [self.yearLabel setText:[NSString stringWithFormat:@"in %@", [[self.entries objectAtIndex:index] valueForKey:@"date"]]];
}
- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    // Set the UIlabel alpha to 0 for example.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[[self.entries objectAtIndex:index] valueForKey:@"value"] integerValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    return [[self.entries objectAtIndex:index] valueForKey:@"date"];
}

-(void)getPopulationStats{
    NSString *requestString = [NSString stringWithFormat:@"http://api.worldbank.org/countries/%@/indicators/SP.POP.TOTL?format=json",self.countryCode];
    NSData *requestData =[NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
    NSError *e = nil;
    NSArray *countryArray = [NSJSONSerialization JSONObjectWithData:requestData options: NSJSONReadingMutableContainers error: &e];
    if([countryArray count] > 1){
    self.entries = [[countryArray[1] reverseObjectEnumerator] allObjects];
    }
    else
        self.entries = [[NSArray alloc]init];
}

@end
