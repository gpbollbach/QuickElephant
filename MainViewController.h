//
//  MainViewController.h
//  EverPost
//
//  Created by Guy Philipp Bollbach on 13.04.10.
//  Copyright itemis GmbH 2010. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UINavigationControllerDelegate> {
	IBOutlet UITextView *textContent;
}
@property (nonatomic, retain) UITextView *textContent;

- (IBAction)showInfo;

- (IBAction)saveNoteAndClear;


@end
