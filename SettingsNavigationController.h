//
//  SettingsNavigationController.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 31.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsNavigationControllerDelegate;

@interface SettingsNavigationController : UIViewController {
	id <SettingsNavigationControllerDelegate> delegate;
	IBOutlet UIBarButtonItem *doneButton;
	IBOutlet UINavigationController *navigationController;
}

@property (nonatomic,retain) id <SettingsNavigationControllerDelegate> delegate;
@property (nonatomic,retain) UIBarButtonItem *doneButton;
@property (nonatomic,retain) UINavigationController *navigationController;

-(IBAction) done;

@end

@protocol SettingsNavigationControllerDelegate
- (void)flipsideViewControllerDidFinish:(SettingsNavigationController *)controller;
@end
