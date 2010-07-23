//
//  RootViewController.h
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 13.04.10.
//  Copyright itemis GmbH 2010. All rights reserved.
//

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	BOOL section0Empty;
	BOOL section1Empty;
	NSIndexPath *selectedRow;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL section0Empty;
@property (nonatomic) BOOL section1Empty;
@property (nonatomic, retain) NSIndexPath *selectedRow;

- (void)insertNewObject:(NSString*) textContent;
- (void) removeNoDataObject:(BOOL)uploadedState;

@end
