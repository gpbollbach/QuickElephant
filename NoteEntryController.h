//
//  NoteEntryController.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 06.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"
#import "RootViewController.h"
#import "NoteEntry.h"

@interface NoteEntryController : UIViewController <FlipsideViewControllerDelegate>{
	IBOutlet UITextView *textContent;
	RootViewController *rootViewController;
	//NSString *textToEdit;
	IBOutlet UILabel *statusLabel;
	BOOL noteCreated;
	BOOL noteUploaded;

	BOOL loginSuccessful; //TODO: Transfer this to AppDelegate because this object can be destroyed because it is a view
	NSTimer *fadeLogin;
	NoteEntry *savedNoteEntry;
	IBOutlet UILabel *saveTarget;
	UIImageView *imageViewMoved;
	IBOutlet UIImageView *imageBar;
}
@property (nonatomic, retain) UITextView *textContent;
@property (nonatomic, retain) RootViewController *rootViewController;
//@property (nonatomic, retain) NSString *textToEdit;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic) BOOL noteCreated;
@property (nonatomic) BOOL noteUploaded;
@property (nonatomic) BOOL loginSuccessful; //TODO: Transfer this to AppDelegate because this object can be destroyed because it is a view
@property (nonatomic, retain) NSTimer *fadeLogin;
@property (nonatomic, retain) NoteEntry *savedNoteEntry;
@property (nonatomic, retain) UILabel *saveTarget;
@property (nonatomic, retain) UIImageView *imageViewMoved;
@property (nonatomic, retain) UIImageView *imageBar;

- (IBAction)showInfo;
- (IBAction)saveNoteAndClear;

@end
