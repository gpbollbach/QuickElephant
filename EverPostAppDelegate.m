//
//  EverPostAppDelegate.m
//  EverPost
//
//  Created by Guy Philipp Bollbach on 13.04.10.
//  Copyright itemis GmbH 2010. All rights reserved.
//

#import "EverPostAppDelegate.h"
#import "MainViewController.h"

@implementation EverPostAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainWindow" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
