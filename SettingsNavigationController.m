//
//  SettingsNavigationController.m
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 31.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import "SettingsNavigationController.h"


@implementation SettingsNavigationController
@synthesize delegate, doneButton, navigationController;


#pragma mark -
#pragma mark View Initialization

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		//self.view = navigationController.view;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.view = navigationController.view;

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark User Interaction

-(IBAction) done {
	[self.delegate flipsideViewControllerDidFinish:self];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.delegate = nil;
	self.doneButton = nil;
}


- (void)dealloc {
	//[delegate release];
	[doneButton release];
    [super dealloc];
}


@end
