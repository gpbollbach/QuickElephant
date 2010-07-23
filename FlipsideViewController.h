//
//  FlipsideViewController.h
//  EverPost
//
//  Created by Guy Philipp Bollbach on 13.04.10.
//  Copyright itemis GmbH 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <UITextFieldDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UIButton *loginButton;
	IBOutlet UIBarButtonItem *cancelButton;
	IBOutlet UITextField *uname;
	IBOutlet UITextField *pword;
	IBOutlet UIActivityIndicatorView *spinner;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) UITextField *uname;
@property (nonatomic, retain) UITextField *pword;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;


- (IBAction)done;
- (IBAction)login;


@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

