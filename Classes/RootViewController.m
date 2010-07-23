//
//  RootViewController.m
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 13.04.10.
//  Copyright itemis GmbH 2010. All rights reserved.
//

#import "RootViewController.h"
#import "FlipsideViewController.h"
#import "QuickElephantAppDelegate.h"
#import "NoteEntry.h"

@interface RootViewController (privat)

- (void)insertNewSystemObject:(BOOL)uploadedState;
- (BOOL)isUploadedInFirstSection;
- (void) addNoDataObjects ;


@end


@implementation RootViewController

@synthesize fetchedResultsController, managedObjectContext, section0Empty, section1Empty,selectedRow;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	logLine();
	// Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
   // UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
	UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pushNewNoteEntryController)];
	self.navigationItem.rightBarButtonItem = composeButton;
    [composeButton release];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	[self addNoDataObjects];
		logLine();
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(managedObjectContextDidSave:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:self.managedObjectContext];
}


- (void)viewWillAppear:(BOOL)animated {
	logLine();
	[self addNoDataObjects];
	[self.tableView reloadData];
//	[self.tableView setBackgroundColor:[UIColor clearColor]];

    [super viewWillAppear:animated];
}

- (void) addNoDataObjects {
	logLine();
	switch ([[fetchedResultsController sections] count]) {
		case 0:
			[self insertNewSystemObject:YES];
			[self insertNewSystemObject:NO];
			break;
		case 1:
			if ([self isUploadedInFirstSection]){
				[self insertNewSystemObject:NO];
			}
			else {
				[self insertNewSystemObject:YES];
			}
			
			break;
		default:
			break;
	}
	
}

- (void) managedObjectContextDidSave:(NSNotification *)notification {
	logLine();
	[self addNoDataObjects];
	[self.tableView reloadData];
}



- (void)viewDidAppear:(BOOL)animated {
	logLine();
	QuickElephantAppDelegate *appDelegate = (QuickElephantAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.tableView setContentOffset:appDelegate.scrollPosition animated:NO];
	
	if (self.selectedRow != nil){
		[self.tableView deselectRowAtIndexPath:self.selectedRow animated:NO];
	}
    [super viewDidAppear:animated];
}
 
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}

 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
 
- (void)pushNewNoteEntryController {
	logLine();
	QuickElephantAppDelegate *appDelegate = (QuickElephantAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate pushNewNoteEntryController:self];
}
 
#pragma mark -
#pragma mark Add a new object
- (void)insertNewSystemObject:(BOOL)uploadedState {
	logLine();
	// Create a new instance of the entity managed by the fetched results controller.
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	// If appropriate, configure the new managed object.
	//[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
	[newManagedObject setValue:@"no note available" forKey:@"textContent"];
	[newManagedObject setValue:[NSNumber numberWithBool:uploadedState] forKey:@"uploaded"];
	[newManagedObject setValue:[NSNumber numberWithBool:YES] forKey:@"systemValue"];

	// Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
}

- (void)insertNewSystemObjectSync{
	logLine();
	// Create a new instance of the entity managed by the fetched results controller.
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	// If appropriate, configure the new managed object.
	//[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
	[newManagedObject setValue:@"sync notes" forKey:@"textContent"];
	[newManagedObject setValue:[NSNumber numberWithBool:NO] forKey:@"uploaded"];
	[newManagedObject setValue:[NSNumber numberWithBool:YES] forKey:@"systemValue"];
	[newManagedObject setValue:[NSNumber numberWithBool:YES] forKey:@"menuItem"];

	NSManagedObject *newManagedObject2 = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	// If appropriate, configure the new managed object.
	//[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
	[newManagedObject2 setValue:@"clear notes" forKey:@"textContent"];
	[newManagedObject2 setValue:[NSNumber numberWithBool:YES] forKey:@"uploaded"];
	[newManagedObject2 setValue:[NSNumber numberWithBool:YES] forKey:@"systemValue"];
	[newManagedObject2 setValue:[NSNumber numberWithBool:YES] forKey:@"menuItem"];

	// Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
}


- (void)insertNewObject {
	logLine();
	NSLog(@"OLD METHOD: ");
	abort();
	// Create a new instance of the entity managed by the fetched results controller.
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	// If appropriate, configure the new managed object.
	[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
	
	// Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
}

- (void)insertNewObject:(NSString*) textContent {
	logLine();
	// Create a new instance of the entity managed by the fetched results controller.
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	// If appropriate, configure the new managed object.
	[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
	[newManagedObject setValue:textContent forKey:@"textContent"];
	[newManagedObject setValue:[NSNumber numberWithBool:NO] forKey:@"uploaded"];


	// Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	[self removeNoDataObject:NO];

}

- (void) removeNoDataObject:(BOOL)uploadedState {
	logLine();
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	NSEntityDescription *eDesc = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	[req setEntity:eDesc];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"uploaded == %@ AND textContent like[cd] %@",[NSNumber numberWithBool:uploadedState],@"no note available"];
	[req setPredicate:pred];
	NSError *err;
	NSArray *objects = [self.managedObjectContext executeFetchRequest:req error:err];
	[req release];
	if ([objects count] == 0){
		return;
	}
	else {
		// Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[objects objectAtIndex:0]];
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
	}
	
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	DebugLog(@"%d",[[fetchedResultsController sections] count]);
	logLine();
    return [[fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//DebugLog(@"section: %d",section);
	//DebugLog(@"sec count %d",[[fetchedResultsController sections] count]);

		//if ([[fetchedResultsController sections] count]!=0 && ([[fetchedResultsController sections] count]-1)>=section){
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	//	DebugLog(@"name %@",sectionInfo.name);
	/*	for (id mo in sectionInfo.objects){
			NSManagedObject *entry = (NSManagedObject*)mo;
			DebugLog(@"%@",[[entry valueForKey:@"textContent"] description]);
//			if ([[entry valueForKey:@"uploaded"] boolValue]
		}*/
	return [sectionInfo numberOfObjects];
	//}
	//return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    
    if (!(section == 0 && [self.tableView numberOfSections] == 1)) {
      //  id <NSFetchedResultsSectionInfo> sectionInfo = 
       // [[self.fetchedResultsController sections] objectAtIndex:section];
       // return [sectionInfo name];  
		return (section == 0)?@"pending notes":@"notes uploaded to Evernote";
    }
	/*else {
		id <NSFetchedResultsSectionInfo> sectionInfo = 
		 [[self.fetchedResultsController sections] objectAtIndex:section];
		if ([self isPending:sectionInfo]){
			logLine();
		}
	}*/

    return (section == 0)?@"pending notes":@"notes uploaded to Evernote";
}
				
- (BOOL)isUploadedInFirstSection {
	logLine();
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
	NSManagedObject *entry = (NSManagedObject*)[[sectionInfo objects] objectAtIndex:0];
	return [[entry valueForKey:@"uploaded"] boolValue];
}
				
/*
-(NSInteger) section1Count:(BOOL)uploaded {
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	NSEntityDescription *eDesc = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
	[req setEntity:eDesc];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"uploaded == %@",[NSNumber numberWithBool:uploaded]];
	NSError *err;
	NSArray *objects = [self.managedObjectContext executeFetchRequest:req error:err];
	[req release];
	if (objects == nil){
		return 0;
	}
	else {
		return [objects count];
	}

}*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    	// Configure the cell.
	/*@try {
		managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
	//	cell.textLabel.text = [[managedObject valueForKey:@"textContent"] description];

	}
	@catch (NSRangeException * e) {
		cell.textLabel.text = @"huhu";
	}*/
	//@try {
	NSManagedObject *	managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
		cell.textLabel.text = [[managedObject valueForKey:@"textContent"] description];
	BOOL isSystemValue = [[managedObject valueForKey:@"systemValue"] boolValue];
	BOOL isMenuItem = [[managedObject valueForKey:@"menuItem"] boolValue];

	//[cell setUserInteractionEnabled:!isSystemValue];
	if (isSystemValue && !isMenuItem) {
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		cell.textLabel.textColor = [UIColor blackColor];
	}

	
	cell.detailTextLabel.text = [ [managedObject valueForKey:@"timeStamp"] description ];
		
	if (![[managedObject valueForKey:@"uploaded"] boolValue] && 
		!isSystemValue){ //h.uploaded==4) { //4:NO 8:YES
		//	DebugLog(@"set indic for %@",cell.textLabel.text);
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.textColor = [UIColor lightGrayColor];
	} 
	else {
		//	DebugLog(@"set NO indic for %@",cell.textLabel.text);
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];
	}

/*	}
	@catch (NSException * e) {
		DebugLog(@"NSException thrown");
		if ([[e name] isEqualToString:NSRangeException]) {
			cell.textLabel.text = @"no note available";
			[cell setUserInteractionEnabled:NO];
		}
	}*/

	
	//NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
/*	if (managedObject == nil)
		DebugLog(@"isnil");
	else {
		DebugLog(@"notnil");
	}*/

	//cell.textLabel.text = @"huhu";//[[managedObject valueForKey:@"textContent"] description];
//	cell.detailTextLabel.text = [ [managedObject valueForKey:@"timeStamp"] description ];

/*	if (![[managedObject valueForKey:@"uploaded"] boolValue]){ //h.uploaded==4) { //4:NO 8:YES
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//beide sollen detail haben, beim zweiten muss aber der save knopf deaktiviert werden.
	} */
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here -- for example, create and push another view controller.
	/*
	 DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	logLine();
	NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	if (![[selectedObject valueForKey:@"systemValue"] boolValue]){
		QuickElephantAppDelegate *appDelegate = (QuickElephantAppDelegate *)[[UIApplication sharedApplication] delegate];
		BOOL alreadyUploaded = [[selectedObject valueForKey:@"uploaded"] boolValue];
		appDelegate.scrollPosition = [tableView contentOffset];
		self.selectedRow = indexPath;
		[appDelegate pushNewNoteEntryController:self  with: selectedObject uploaded: alreadyUploaded];
	}
	/*
	FlipsideViewController *detailViewController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	 */
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSManagedObject *managedObject =[fetchedResultsController objectAtIndexPath:indexPath];
    return ![[managedObject valueForKey:@"systemValue"] boolValue];
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    logLine();
	DebugLog(@"%d",[indexPath indexAtPosition:0]);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:[indexPath indexAtPosition:0]];
		NSInteger remainingObjectCount = [[sectionInfo objects] count];

        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	/*	if ([indexPath indexAtPosition:0]==0 && remainingObjectCount == 1){
			[self insertNewSystemObject:NO];
		}
		else if ([indexPath indexAtPosition:0]==0 && remainingObjectCount == 1){
			[self insertNewSystemObject:YES];
		}*/
	}   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
	
	QuickElephantAppDelegate *appDelegate = (QuickElephantAppDelegate *)[[UIApplication sharedApplication] delegate];
	//if (self.managedObjectContext = nil) {
	self.managedObjectContext = appDelegate.managedObjectContext;
	//}
	
    
    /*
	 Set up the fetched results controller.
	*/
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptorSection = [[NSSortDescriptor alloc] initWithKey:@"uploaded" ascending:YES];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorSection,sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"uploaded" cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptorSection release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// In the simplest, most efficient, case, reload the table view.
	[self.tableView reloadData];
}

/*
 Instead of using controllerDidChangeContent: to respond to all changes, you can implement all the delegate methods to update the table view in response to individual changes.  This may have performance implications if a large number of changes are made simultaneously.

// Notifies the delegate that section and object changes are about to be processed and notifications will be sent. 
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	// Update the table view appropriately.
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	// Update the table view appropriately.
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
} 
 */


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Relinquish ownership of any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end

