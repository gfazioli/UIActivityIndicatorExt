//
//  DemoViewController.m
//  Demo
//
//  Created by Giovambattista Fazioli on 22/04/11.
//  Copyright 2011 Saidmade Srl. All rights reserved.
//

#import "DemoViewController.h"

@implementation DemoViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)activityIndicatorC
{
    [UIActivityIndicatorExt dismiss:YES];
}


- (void)activityIndicatorB
{
    [UIActivityIndicatorExt activityWithSize:CGSizeMake(100, 100) andText:@"Pluto..."]; 

    [self performSelector:@selector(activityIndicatorC) withObject:nil afterDelay:3.];
}

- (void)activityIndicator 
{
    [UIActivityIndicatorExt activityWithSize:CGSizeMake(200, 150) andText:@"Ciao..."];
    
    [self performSelector:@selector(activityIndicatorB) withObject:nil afterDelay:3.];
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self performSelector:@selector(activityIndicator) withObject:nil afterDelay:3.];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (IBAction)didOpenActivityTouch:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self activityIndicator];
}
@end
