//
//  SettingsController.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 31.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditableDetailCell;


enum tableRowTags {
	rowUsername,
	rowPassword,
	rowLogin
};

enum tableRowTagsNotes {
	rowNotebook
};

enum tableSectionTags {
	sectionUserdata,
	sectionNotes
};

@interface SettingsController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate> {
	IBOutlet UIActivityIndicatorView *spinner;
	EditableDetailCell *cellUsername;
	EditableDetailCell *cellPassword;
	EditableDetailCell *cellTag;
	EditableDetailCell *cellPrefix;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	UITextField *currentTextfield;

}

@property (nonatomic,retain) UIActivityIndicatorView *spinner;
@property (nonatomic,retain) EditableDetailCell *cellUsername;
@property (nonatomic,retain) EditableDetailCell *cellPassword;
@property (nonatomic,retain) EditableDetailCell *cellTag;
@property (nonatomic,retain) EditableDetailCell *cellPrefix;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) UITextField *currentTextfield;


- (EditableDetailCell *)newDetailCellWithTag:(NSInteger)tag;

//  Action Methods
//
- (void)save;
- (void)cancel;

@end
