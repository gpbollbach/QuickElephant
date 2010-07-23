//
//  QuickElephantAppDelegate.m
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 13.04.10.
//  Copyright itemis GmbH 2010. All rights reserved.
//

#import "QuickElephantAppDelegate.h"
//#import "RootViewController.h"
#import "NoteEntryController.h"
#import "HistoryController.h"
#import "EvernoteBackup.h"
#import "MixpanelAPI.h"

@implementation QuickElephantAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize returnFromCache;
@synthesize aQueue;
@synthesize scrollPosition;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	en = nil;
    // Override point for customization after app launch    
	self.aQueue = [[NSOperationQueue alloc] init];

	RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
	rootViewController.managedObjectContext = self.managedObjectContext;

	self.scrollPosition = CGPointZero;
	//HistoryController *historyController = (HistoryController *)[navigationController topViewController];
	
	[self pushNewNoteEntryController: rootViewController];
	
	[MixpanelAPI sharedAPIWithToken:@"065ead633e6b1ceb9017b90aa17dc1f2"];
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];

}
/*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	logLine();
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	logLine();
}*/

- (void)pushNewNoteEntryController:(RootViewController*) rootViewController  {
	NoteEntryController *aController = [[NoteEntryController alloc] initWithNibName:@"NoteEntryController" bundle:nil];
	aController.rootViewController = rootViewController;
	aController.title = @"new Note";
	navigationController.delegate = self;
	aController.noteUploaded = NO;
	navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[navigationController pushViewController:aController animated:YES];
	[aController release];
}

- (void)pushNewNoteEntryController:(RootViewController*) rootViewController with:(NoteEntry *) noteEntry uploaded:(BOOL)uploaded  {
	NoteEntryController *aController = [[NoteEntryController alloc] initWithNibName:@"NoteEntryController" bundle:nil];
	aController.rootViewController = rootViewController;
	aController.title = @"new Note";
	//aController.textToEdit = textToInsert;
	aController.savedNoteEntry = noteEntry;
	aController.noteUploaded = uploaded;
	[navigationController pushViewController:aController animated:YES];
	[aController release];
}

- (EvernoteBackup *) getEvernoteBackup {
	logLine();
	if (en == nil){
		en = [[[EvernoteBackup alloc] init] retain];
	}
	return en;
}
/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[en release];
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
		DebugLog(@"Setting Badge");
		NSFetchRequest *req = [[NSFetchRequest alloc] init];
		//NSEntityDescription *eDesc = [[[rootViewController fetchedResultsController] fetchRequest] entity];
		NSEntityDescription *eDesc = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
		[req setEntity:eDesc];
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"uploaded == %@ AND systemValue == %@",[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
		[req setPredicate:pred];
		NSError *err;
		NSArray *objects = [managedObjectContext executeFetchRequest:req error:err];
		[req release];
		if (objects != nil){
			[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[objects count]];
		}
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"QuickElephant.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[aQueue release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

