//
//  FlipsideViewController.m
//  EverPost
//
//  Created by Guy Philipp Bollbach on 13.04.10.
//  Copyright itemis GmbH 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "EvernoteBackup.h"


@implementation FlipsideViewController

@synthesize delegate, uname, pword, loginButton, spinner;


- (void)viewDidLoad {
    [super viewDidLoad];
   // self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	self.uname.text = [userDefaults valueForKey:@"uname"];
	self.pword.text = [userDefaults valueForKey:@"pword"];

	
}


- (IBAction)done {
	[self.delegate flipsideViewControllerDidFinish:self];	
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
	self.loginButton = nil;
	self.uname = nil;
	self.pword = nil;
	self.spinner = nil;
}


- (void)dealloc {
	[loginButton release];
	[uname release];
	[pword release];
	[spinner release];
    [super dealloc];
}
-(void) saveUserCredentials {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	[userDefaults setObject:self.uname.text forKey:@"uname"]; 
	[userDefaults setObject:self.pword.text forKey:@"pword"]; 
}

- (void) closeLoginScreen {
	[self.delegate flipsideViewControllerDidFinish:self];	
}

-(void) logginIn {
	EvernoteBackup *en = [[[EvernoteBackup alloc] init] autorelease];
	BOOL loggedIn = [en login:self.uname.text with:self.pword.text];
	if (loggedIn==YES) {
		[loginButton setTitle: @"login successful" forState:UIControlStateNormal];
		[loginButton setTitle: @"login successful" forState:UIControlStateSelected];
		[loginButton setTitle: @"login successful" forState:UIControlStateHighlighted];
		
	//	loginButton.color = [UIColor greenColor];
		//wait 2 sec
		[self saveUserCredentials];
		NSTimer *closeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(closeLoginScreen) userInfo:nil repeats:NO]; 			
	}
	else {
		[loginButton setTitle:@"login failed. Try again" forState:UIControlStateNormal];
		[loginButton setTitle:@"login failed. Try again" forState:UIControlStateSelected];
		[loginButton setTitle:@"login failed. Try again" forState:UIControlStateHighlighted];
		loginButton.enabled = YES;
		[cancelButton setEnabled:YES];
	}
	
	[spinner stopAnimating];
}

- (IBAction)login {
	[spinner startAnimating];
	loginButton.enabled = NO;
	[cancelButton setEnabled:NO];

	NSTimer *closeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(logginIn) userInfo:nil repeats:NO]; 	

}


//jump from textfield to the next
- (BOOL) textFieldShouldReturn:(UITextField *)theTextField	{
	if (theTextField == pword) {
		[pword resignFirstResponder];
		
	}
	if (theTextField == uname) {
		[pword becomeFirstResponder];
	}
	return YES;
}

@end
