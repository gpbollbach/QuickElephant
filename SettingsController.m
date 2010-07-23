//
//  SettingsController.m
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 31.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import "SettingsController.h"
#import "QuickElephantAppDelegate.h"
#import "SettingsEntry.h";
#import "EvernoteBackup.h";
#import "SpinnerCell.h";

@interface SettingsController (privat)
- (UITableViewCell *) loginViewCell;
- (void) logIn;
- (EvernoteBackup *) evernoteBackup;

@end


@implementation SettingsController
@synthesize spinner, cellUsername, cellPassword, cellTag, cellPrefix;
@synthesize managedObjectContext, fetchedResultsController;
@synthesize currentTextfield;

NSUInteger sectionCount;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	sectionCount = 1;
	//Set up new cells
	//[self setTitleCell:    [self newDetailCellWithTag:BookTitle]];
	self.cellUsername = [self newDetailCellWithTag:rowUsername];
	self.cellPassword = [self newDetailCellWithTag:rowPassword];
	
	
 	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	/*
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	NSEntityDescription *eDesc = [NSEntityDescription entityForName:@"SettingsEntry" inManagedObjectContext:[fetchedResultsController managedObjectContext]];
	[req setEntity:eDesc];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"name like[cd] %@",@"testname"];
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
		for (int i=0; i < [objects count]; i++) {
			[context deleteObject:[objects objectAtIndex:i]];

		}
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		
	}*/
/*	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	

	SettingsEntry *entr = (SettingsEntry*) newManagedObject;
	entr.name = @"Username";
	entr.rowId =[NSNumber numberWithInt:0];
	entr.sectionId = [NSNumber numberWithInt:0];
	entr.editable = [NSNumber numberWithBool:YES];
	
	NSManagedObject *newManagedObject2 = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	SettingsEntry *entrPw = (SettingsEntry*) newManagedObject2;
	entrPw.name = @"Password";
	entrPw.rowId =[NSNumber numberWithInt:1];
	entrPw.sectionId = [NSNumber numberWithInt:0];
	entrPw.editable = [NSNumber numberWithBool:YES];
	
	NSManagedObject *newManagedObject3 = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	SettingsEntry *entrLogin = (SettingsEntry*) newManagedObject3;
	entrLogin.name = @"Login";
	entrLogin.rowId =[NSNumber numberWithInt:2];
	entrLogin.sectionId = [NSNumber numberWithInt:0];
	entrLogin.editable = [NSNumber numberWithBool:NO];
	entrLogin.detailAvailable = [NSNumber numberWithBool:YES];
	//	[newManagedObject setValue:[NSNumber numberWithInt:0] forKey:@"rowId"];
	//[newManagedObject setValue:[NSNumber numberWithBool:YES] forKey:@"systemValue"];
	
	// Save the context.
    if (![context save:&error]) {

		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
 */

	[self setTitle:@"Settings"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSUInteger indexes [] = {0, 0};
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
	EditableDetailCell *cell = (EditableDetailCell *) [self.tableView cellForRowAtIndexPath:indexPath];
	UITextField *tx = [cell textField];
	[tx becomeFirstResponder];
	
}
 
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark UITextFieldDelegate Protocol

//  Sets the label of the keyboard's return key to 'Done' when the insertion
//  point moves to the table view's last field.
//
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	logLine();
    if ([textField tag] == rowPassword)
    {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    self.currentTextfield = textField;
    return YES;
}

//  UITextField sends this message to its delegate after resigning
//  firstResponder status. Use this as a hook to save the text field's
//  value to the corresponding property of the model object.
//
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	logLine();

    NSString *text = [textField text];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	

    switch ([textField tag])
    {
        case rowUsername:    
			[userDefaults setObject:text forKey:@"uname"];        
			break;
		case rowPassword:     
			[userDefaults setObject:text forKey:@"pword"];        
			break;
    }
}

//  UITextField sends this message to its delegate when the return key
//  is pressed. Use this as a hook to navigate back to the list view 
//  (by 'popping' the current view controller, or dismissing a modal nav
//  controller, as the case may be).
//
//  If the user is adding a new item rather than editing an existing one,
//  respond to the return key by moving the insertion point to the next cell's
//  textField, unless we're already at the last cell.
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField returnKeyType] != UIReturnKeyDone)
    {
        //  If this is not the last field (in which case the keyboard's
        //  return key label will currently be 'Next' rather than 'Done'), 
        //  just move the insertion point to the next field.
        //
        //  (See the implementation of -textFieldShouldBeginEditing: above.)
        //
        NSInteger nextTag = [textField tag] + 1;
        UIView *nextTextField = [[self tableView] viewWithTag:nextTag];
        
        [nextTextField becomeFirstResponder];
    }
    
/*	else if ([self isModal])
    {
        //  We're in a modal navigation controller, which means the user is
        //  adding a new book rather than editing an existing one.
        //
        [self save];
    }
	*/
	if ([textField returnKeyType] == UIReturnKeyDone)
    {
		self.currentTextfield = nil;

		[textField resignFirstResponder];
        [self logIn];
    }
    
    return YES;
}



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	DebugLog(@"%d",[[fetchedResultsController sections] count]);
    return sectionCount; //[[fetchedResultsController sections] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	DebugLog(@"section: %d",section);
	//DebugLog(@"sec count %d",[[fetchedResultsController sections] count]);
	
	//id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	if (section == sectionUserdata) {
		return 3;
	}
	else if (section == sectionNotes) {
		return 1;
	}
	return 0;//[sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 /*   
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSManagedObject *	managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
	SettingsEntry *entry = (SettingsEntry*) managedObject;
	cell.textLabel.text = entry.name;//[[managedObject valueForKey:@"name"] description];
	cell.detailTextLabel.text = entry.name;
	if ([entry.detailAvailable boolValue]) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
*/
	EditableDetailCell *cell = nil;
    NSInteger tag = INT_MIN;
    NSString *text = nil;
    NSString *placeholder = nil;
    
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	NSString *uname = [userDefaults valueForKey:@"uname"];
	NSString *pword = [userDefaults valueForKey:@"pword"];
	
	static NSString *cellIdentifier = @"Cell";
	
    //  Pick the editable cell and the values for its textField
    //
    NSUInteger section = [indexPath section];

    switch (section) 
    {
        case sectionUserdata:
        {
			if ([indexPath row] == rowUsername){
				cell = self.cellUsername;
				text = uname;
				placeholder = @"your evernote username";
				tag = rowUsername;
				((UITableViewCell*) cell).textLabel.text = @"Username";
			}
			else if ([indexPath row] == rowPassword) {
				cell = self.cellPassword;
				text = pword;
				placeholder = @"your password";
				tag = rowPassword;
				((UITableViewCell*) cell).textLabel.text = @"Password";
			}
			if (cell != nil) {
				UITextField *textfield = [cell textField];
				[textfield setTag:tag];
				[textfield setText:text];
				[textfield setPlaceholder:placeholder];
				if ([indexPath row] == rowPassword) {
					[textfield setSecureTextEntry:YES];
				}
			}
			else {
				
				//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				SpinnerCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];//(UITableViewCell*) cell;
				if (cell2 == nil) {
					//cell2 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
					cell2 = [[[SpinnerCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
				}
				//NSManagedObject *	managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
				//SettingsEntry *entry = (SettingsEntry*) managedObject;
				//entry.name;//[[managedObject valueForKey:@"name"] description];
				//		cell2.detailTextLabel.text = entry.name;
				if ([indexPath row] == rowLogin) {//([entry.detailAvailable boolValue]) {
					cell2.textLabel.text = @"Login";
					cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
				else {
					cell2.accessoryType = UITableViewCellAccessoryNone;
				}
				cell2.selectionStyle = UITableViewCellSelectionStyleGray;
				cell = cell2;
			}
			break;
		}
		case sectionNotes:
		{
			if ([indexPath row]==rowNotebook){
				NSString *cellIdentifierDefault = @"CellDefault";

				UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifierDefault];//(UITableViewCell*) cell;
				if (cell2 == nil) {
					cell2 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
					//cell2 = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
				}
				NSString * nname = [self evernoteBackup].notebookUsed.name;
				cell2.textLabel.text = @"selected notebook";
				cell2.detailTextLabel.text = nname;
				cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell = cell2;
			}
			break;
		}
	}
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
	NSString *result = nil;
	if (section == sectionUserdata) {
		result = @"Evernote userdata";
	}
	else if (section == sectionNotes) {
		result = @"Evernote settings";
	}
	else {
		result = [NSString stringWithFormat:@"tempTitle%d",section];
	}
	
	return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	NSUInteger section = [indexPath section];
	switch (section) {
		case sectionUserdata:
		{
			if ([indexPath row] == rowLogin) {		
				//save the value
				[self.currentTextfield resignFirstResponder];
				self.currentTextfield = nil;

				SpinnerCell *cell = [self loginViewCell];
				[cell.spinner startAnimating];

				[self logIn];
				[cell.spinner stopAnimating];
			}
			break;
		}
		default:
			break;
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"SettingsEntry" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptorSection = [[NSSortDescriptor alloc] initWithKey:@"sectionId" ascending:YES];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowId" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorSection,sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"sectionId" cacheName:@"Settings"];
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
#pragma mark EditableDetailCell methods

//  Convenience method that returns a fully configured new instance of 
//  EditableDetailCell. Note that methods whose names begin with 'alloc' or
//  'new', or whose names contain 'copy', should return a non-autoreleased
//  instance with a retain count of one, as we do here.
//
- (EditableDetailCell *)newDetailCellWithTag:(NSInteger)tag
{
    EditableDetailCell *cell = [[EditableDetailCell alloc] initWithFrame:CGRectZero 
                                                         reuseIdentifier:nil];
    [[cell textField] setDelegate:self];
    [[cell textField] setTag:tag];
    
    return cell;
}

#pragma mark -
#pragma mark Action Methods

- (void)save
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) logIn {
	SpinnerCell *cell = 		[self loginViewCell];
	//cell.selected = NO;
	[cell.spinner startAnimating];
	/*
	
	CGRect bounds = [[cell contentView] bounds];
	CGRect rectTmp = CGRectInset(bounds, 0.0, 0.0);
	
	CGFloat textPosition = 70.0;
	CGRect rect = CGRectMake(CGRectGetMinX(rectTmp)+textPosition, CGRectGetMinY(rectTmp),CGRectGetWidth(rectTmp)-textPosition, CGRectGetHeight(rectTmp));
	
	UIActivityIndicatorView *spinnerTmp = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	//		spinnerTmp.bounds.origin.x = CGRectGetMinX(rectTmp)+textPosition;
	//		spinnerTmp.bounds.origin.y = CGRectGetMinY(rectTmp);
	//spinnerTmp.bounds = CGRectMake(CGRectGetMinX(rectTmp)+textPosition, CGRectGetMinY(rectTmp), CGRectGetWidth(spinnerTmp.bounds), CGRectGetHeight(spinnerTmp.bounds));
	CGRect newFrame = spinnerTmp.frame;
	//newFrame.origin.x = CGRectGetMinX(newFrame)+textPosition;
	//newFrame.origin.y = CGRectGetMinY(newFrame)+(CGRectGetHeight(cell.bounds)/4.0);
	spinnerTmp.frame = newFrame;
	//[cell addSubview:spinnerTmp];
	cell.accessoryView = spinnerTmp;
	cell.spinner = spinnerTmp;
	cell.spinner.hidden = NO;
	[spinnerTmp startAnimating];
	[spinnerTmp release];*/

	
	QuickElephantAppDelegate *appDelegate = (QuickElephantAppDelegate *)[[UIApplication sharedApplication] delegate];
	EvernoteBackup *en = [appDelegate getEvernoteBackup]; //[[[EvernoteBackup alloc] init] autorelease];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	NSString *uname = [userDefaults valueForKey:@"uname"];
	NSString *pword = [userDefaults valueForKey:@"pword"];
	
	BOOL loggedIn = [en login:uname with:pword];
	if (loggedIn==YES) {
	/*	[loginButton setTitle: @"login successful" forState:UIControlStateNormal];
		[loginButton setTitle: @"login successful" forState:UIControlStateSelected];
		[loginButton setTitle: @"login successful" forState:UIControlStateHighlighted];
	*/	
		//	loginButton.color = [UIColor greenColor];
		//wait 2 sec
	/*	[self saveUserCredentials];
		NSTimer *closeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(closeLoginScreen) userInfo:nil repeats:NO]; 			
	*/
		cell.textLabel.text = @"Login successful";
		[en initNotebook];
		if ([en.notebooks count] > 0 ){
			sectionCount += 1;
			[self.tableView reloadData];
		}
	}
	else {
		/*
		[loginButton setTitle:@"login failed. Try again" forState:UIControlStateNormal];
		[loginButton setTitle:@"login failed. Try again" forState:UIControlStateSelected];
		[loginButton setTitle:@"login failed. Try again" forState:UIControlStateHighlighted];
		loginButton.enabled = YES;
		[cancelButton setEnabled:YES];
		 */
		cell.textLabel.text = @"Login failed";
	}		
	cell.selected = NO;
	[cell.spinner stopAnimating];
	
	//[spinner stopAnimating];
}

-(EvernoteBackup *) evernoteBackup {
	QuickElephantAppDelegate *appDelegate = (QuickElephantAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [appDelegate getEvernoteBackup];
}

-(SpinnerCell *) loginViewCell {
	NSUInteger indexes [] = {0, rowLogin};
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
	SpinnerCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	return cell;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;

	self.spinner = nil;
	self.cellUsername = nil;
	self.cellPassword = nil;
	self.cellTag = nil;
	self.cellPrefix = nil;
	self.currentTextfield = nil;

}


- (void)dealloc {
	[spinner release];
	[cellUsername release];
	[cellPassword release];
	[cellTag release];
	[cellPrefix release];
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end

