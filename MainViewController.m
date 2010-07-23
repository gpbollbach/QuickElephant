//
//  MainViewController.m
//  EverPost
//
//  Created by Guy Philipp Bollbach on 13.04.10.
//  Copyright itemis GmbH 2010. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "RootViewController.h"
#import "QuickElephantAppDelegate.h"


@implementation MainViewController
@synthesize textContent;
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/



 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 [textContent becomeFirstResponder];
	 NSLog("viewdidload");
 }


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
	[textContent becomeFirstResponder];

}


- (IBAction)showInfo {    
	//[textContent resignFirstResponder];
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)saveNoteAndClear {
	DebugLog(textContent.text);
	[self clearNote];
	[self saveNote];
}
- (void) clearNote {
	logLine();
	textContent.text = @"";
}
- (void) saveNote {
	logLine();
	//add to core data model
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.textContent = nil;
}


- (void)dealloc {
	[textContent release];
    [super dealloc];
}


@end
