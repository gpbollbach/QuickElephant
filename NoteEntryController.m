//
//  NoteEntryController.m
//  QuickElephant
//
//  Created by Guy Philipp Bollbach on 06.05.10.
//  Copyright 2010 itemis GmbH. All rights reserved.
//

#import "NoteEntryController.h"
#import "EvernoteBackup.h"
#import "QuickElephantAppDelegate.h"
#import "SettingsNavigationController.h"
#import "SettingsController.h"

#import <QuartzCore/QuartzCore.h>

@interface NoteEntryController (private) 
- (void) clearNote;
- (void) saveNote;
- (void) insertNew;
- (void) showStatusChangeBegin:(NSString*)status forTimeInterval:(NSTimeInterval) ti;
- (void) startAsyncEvernoteCall;
- (void) saveToEvernote:(NSArray *) noteEntries;

@end


@implementation NoteEntryController
@synthesize textContent, rootViewController, statusLabel, noteCreated, noteUploaded, loginSuccessful,fadeLogin, savedNoteEntry, saveTarget,imageViewMoved, imageBar;



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
-(void) fadeOut {
	CGRect startFrame = self.statusLabel.frame;  
	
	[UIView beginAnimations:@"fadeOut" context:nil];
	//[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(priceButtonAnimationFirstSegmentEnd)];
	[UIView setAnimationDuration:1.0];
	//	[statusLabel setFrame:CGRectMake(startFrame.origin.x, startFrame.origin.y+10, startFrame.size.width, startFrame.size.height+0.0)];
	[statusLabel setAlpha:0.0];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView commitAnimations];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[textContent becomeFirstResponder];
	
//	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNew)];
	//UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(saveNoteAndClear)];
	if (!noteUploaded){
		UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithTitle:@"save&new" style:UIBarButtonItemStyleBordered target:self action:@selector(saveNoteAndClear)];
		//	composeButton.title = @"tit";
		self.navigationItem.rightBarButtonItem = composeButton;
		[composeButton release];
	}
	if (savedNoteEntry != nil) {
		textContent.text = savedNoteEntry.textContent;
		DebugLog(@"setting text from prev instance");
	}
	
	//NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	//[nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
	
	//the app shows some hints at startup that should not be presented when th view is loaded otherwise
	QuickElephantAppDelegate *appDelegate = (QuickElephantAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (appDelegate.returnFromCache == NO){
		DebugLog(@"returnFromCache");
		[UIView beginAnimations:@"fadeOut" context:nil];
		[UIView setAnimationDuration:0.5];
		[statusLabel setAlpha:1.0];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		[UIView commitAnimations];
	
		NSTimer *fadeTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fadeOut) userInfo:nil repeats:NO]; 	
		fadeLogin = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(setUsernameLabel) userInfo:nil repeats:NO]; 	
		//NSTimer *syncIt = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(startAsyncEvernoteCall) userInfo:nil repeats:NO]; 	
		appDelegate.returnFromCache = YES;
	}

}
/*
-(void) keyboardWillShow:(NSNotification *) note {
	if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) {
		logLine();
		CGRect r  = self.imageBar.frame, t;
		[[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &t];
		r.origin.y -=  20.0;//t.size.height;
		self.imageBar.frame = r;
		//[self.textContent resignFirstResponder];
	}
}*/

-(void) setUsernameLabel {
	logLine();
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	NSString *unameTemp = [userDefaults valueForKey:@"uname"];
	if (unameTemp == nil || [unameTemp length]== 0) {
		loginSuccessful = NO;
		[UIView beginAnimations:@"loginReminder" context:nil];
		//[UIView setAnimationDelegate:self];
		//[UIView setAnimationDidStopSelector:@selector(priceButtonAnimationFirstSegmentEnd)];
		[UIView setAnimationDuration:0.5];
		//	[statusLabel setFrame:CGRectMake(startFrame.origin.x, startFrame.origin.y+10, startFrame.size.width, startFrame.size.height+0.0)];
		[statusLabel setAlpha:1.0];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		[UIView commitAnimations];
		statusLabel.text = @"<-- set Evernote login here";
		NSTimer *fadeTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fadeOut) userInfo:nil repeats:NO]; 	
	}
	else {
		loginSuccessful = YES;
		[self showStatusChangeBegin:[@"welcome back " stringByAppendingString:unameTemp] forTimeInterval:3.5]; //TODO: Greet the user instead of "welcome to fastphant"
	}
}

-(void) showStatusChangeBegin:(NSString*)status forTimeInterval:(NSTimeInterval) ti {
	logLine();
	[UIView beginAnimations:@"fadeOut" context:nil];
	//[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(priceButtonAnimationFirstSegmentEnd)];
	[UIView setAnimationDuration:0.5];
	//	[statusLabel setFrame:CGRectMake(startFrame.origin.x, startFrame.origin.y+10, startFrame.size.width, startFrame.size.height+0.0)];
	[statusLabel setAlpha:1.0];
	statusLabel.text = status;

	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView commitAnimations];
	NSTimer *fadeTimer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(showStatusChangeEnd) userInfo:nil repeats:NO]; 	

}
-(void) showStatusChangeEnd {
	logLine();
	[UIView beginAnimations:@"fadeOut" context:nil];
	//[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(priceButtonAnimationFirstSegmentEnd)];
	[UIView setAnimationDuration:0.5];
	//	[statusLabel setFrame:CGRectMake(startFrame.origin.x, startFrame.origin.y+10, startFrame.size.width, startFrame.size.height+0.0)];
	[statusLabel setAlpha:0.0];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView commitAnimations];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	logLine();
	self.textContent = nil;
	self.rootViewController = nil;
	self.fadeLogin = nil;
	self.statusLabel = nil;
	self.saveTarget = nil;
//	self.imageBar = nil;
//	self.imageViewMoved = nil;
}


- (void)dealloc {
	logLine();
	[textContent release];
	[rootViewController release];
	[statusLabel release];
	[saveTarget release];
	//[imageBar release];
	//[imageViewMoved release];
    [super dealloc];
}

#pragma mark -
#pragma mark FlipsideViewSettings

- (IBAction)showInfo {  
	//TODO: Wie kann man an nicht mehr allokierte Instanzen was schicken ohne dass es knallt: a la "lebst du noch?"	
	//if (fadeLogin !=nil && [fadeLogin isValid]) {
	//	[fadeLogin invalidate];
	//	}
	//FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	//SettingsNavigationController *controller = [[SettingsNavigationController alloc] initWithNibName:@"SettingsNavigationController" bundle:nil];
	SettingsController *controller = [[SettingsController alloc] initWithNibName:@"SettingsController" bundle:nil];

	//controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//	[self presentModalViewController:controller animated:YES];
	//[[self navigationController] presentModalViewController:controller animated:YES];
	//[[self navigationController] pushViewController:controller animated:YES];
	QuickElephantAppDelegate *appDelegate = (QuickElephantAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[appDelegate navigationController] pushViewController:controller animated:YES];
//	[[appDelegate navigationController] presentModalViewController:controller animated:YES];
	[controller release];
	
}
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
	[self showStatusChangeBegin:@"start typing and press 'save&new'" forTimeInterval:6.0];
}

- (void) insertNew {
	[rootViewController fetchedResultsController];
	[rootViewController insertNewObject:textContent.text];
}



- (IBAction)saveNoteAndClear {
	//TODO: user feedback: gespeichert, async beachten: Note muss direkt nach dem 
	//Speichern übertragen werden, da die app bald zugehen wird (4.0 update von async tasks
	if ([textContent.text length] > 0)
	{
		DebugLog(@"saving note");
		DebugLog(textContent.text);
		[self saveNote];
		[self startAsyncEvernoteCall];
		[self showLetterAnimation];
		[self clearNote];
	}
	else {
		DebugLog(@"no note to save");
	}

}
- (void) showLetterAnimation {
	logLine();
//	self.textContent.backgroundColor = [UIColor redColor];
	UIGraphicsBeginImageContext(self.textContent.bounds.size);
    [self.textContent.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIImageView *iv = [[UIImageView alloc] initWithImage:image];
//	[iv addSubview:iv2];
	CALayer                                                 *layer = [CALayer layer];
	CGRect                                                  bounds = iv.bounds;
	
	layer.bounds = bounds;
	layer.position = CGPointMake(bounds.size.width / 2 + 0, bounds.size.height / 2 + 0);
	layer.backgroundColor = [UIColor colorWithWhite: 0.70 alpha: 1.0].CGColor;
	layer.zPosition = -5;
	iv.clipsToBounds = NO;
	[iv.layer addSublayer: layer];
	//[iv.layer insertSublayer:layer below: iv.layer];
	
	[self.view.superview addSubview:iv];
    UIGraphicsEndImageContext();
	self.textContent.backgroundColor = [UIColor whiteColor];

	[UIView beginAnimations:@"shrink" context:iv];
	[UIView setAnimationDuration:0.5];
    CGAffineTransform transform = CGAffineTransformMakeScale(0.1, 0.1);
	iv.transform = transform;
	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(showLetterAnimation3:finished:context:)];
	[UIView commitAnimations];

	//instead of retaining iv we set the ivar
	self.imageViewMoved = iv;
}
- (void) showLetterAnimation3:(NSString *)animationID finished:(BOOL)finished context:(void *)cntxt {

	UIImageView *iv = (UIImageView *) cntxt; 

	CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	pathAnimation.calculationMode = kCAAnimationPaced;
	pathAnimation.fillMode = kCAFillModeForwards;
	pathAnimation.removedOnCompletion = NO;
	pathAnimation.duration = 0.5;
	[pathAnimation setDelegate:self];
	CGPoint endPoint =  CGPointMake(self.saveTarget.center.x + 7.0, self.saveTarget.center.y -20.0) ;
	CGMutablePathRef curvedPath = CGPathCreateMutable();
	CGPathMoveToPoint(curvedPath, NULL, iv.frame.origin.x+iv.frame.size.width/2, iv.frame.origin.y+iv.frame.size.height/2);
	CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, iv.frame.origin.y, endPoint.x, iv.frame.origin.y, endPoint.x, endPoint.y);
	pathAnimation.path = curvedPath;
	CGPathRelease(curvedPath);
	
	[iv.layer addAnimation:pathAnimation forKey:@"animateShrinkedImageView"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	[self.imageViewMoved removeFromSuperview];
	self.imageViewMoved = nil;
}

- (void) clearNote {
	logLine();
	textContent.text = @"";
}
- (void) saveNote {
	logLine();
	if (self.savedNoteEntry == nil){
		[self insertNew];
	}
	else {
		self.savedNoteEntry.textContent = textContent.text;
		NSError *error = nil;
		if (![rootViewController.managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

-(void) startAsyncEvernoteCall {
	NSInvocationOperation *theOp = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(savePendingNotes) object:nil] autorelease];
	
	[self addObserver:self
		   forKeyPath:@"noteCreated"
			  options:(NSKeyValueObservingOptionNew |
					   NSKeyValueObservingOptionOld)
			  context:NULL];
	QuickElephantAppDelegate *appDelegate = (QuickElephantAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[appDelegate.aQueue addOperation:theOp];
	
}


-(void) savePendingNotes {
	logLine();
	[self performSelectorOnMainThread:@selector(syncStatusBegin) withObject:nil waitUntilDone:NO];
//	[self showStatusChangeBegin: @"note creation failed" forTimeInterval:2.0];

	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	NSManagedObjectContext *context = [[rootViewController fetchedResultsController] managedObjectContext];
	NSEntityDescription *eDesc = [[[rootViewController fetchedResultsController] fetchRequest] entity];
	//NSEntityDescription *eDesc = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
	[req setEntity:eDesc];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"uploaded == %@ AND systemValue == %@",[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
	[req setPredicate:pred];
	NSError *err;
	NSArray *objects = [context executeFetchRequest:req error:err];
	[req release];
	if (objects != nil){
		[self saveToEvernote:objects];
		DebugLog(@"saved notes");
	}
	else {
		[self performSelectorOnMainThread:@selector(syncStatusEnd) withObject:nil waitUntilDone:NO];
	}

}

-(void) syncStatusBegin {
	//[self showStatusChangeBegin: @"note creation started" forTimeInterval:2.0];
	[UIView beginAnimations:@"fadeOut" context:nil];
	//[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(priceButtonAnimationFirstSegmentEnd)];
	[UIView setAnimationDuration:0.5];
	//	[statusLabel setFrame:CGRectMake(startFrame.origin.x, startFrame.origin.y+10, startFrame.size.width, startFrame.size.height+0.0)];
	[statusLabel setAlpha:1.0];
	statusLabel.text = @"syncing pending notes...";
	
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView commitAnimations];
}
-(void) syncStatusEnd {
	DebugLog(@"Hello hier");
	logLine();
	//	statusLabel.text = @"syncing notes finished";
	//	NSTimer *fadeTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(fadeOut) userInfo:nil repeats:NO]; 	
	[self showStatusChangeBegin:@"syncing notes finished" forTimeInterval:3.0];
	
}

/*
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"noteCreated"]) {
		DebugLog(@"noteCreated-juchuuu");
		if (self.noteCreated)
		{
			[self showStatusChangeBegin: @"note created" forTimeInterval:2.0];
		}
		else {
			[self showStatusChangeBegin: @"note creation failed" forTimeInterval:2.0];
		}
    }
}*/
/*
- (void) saveToEvernote {
	EvernoteBackup *en = [[[EvernoteBackup alloc] init] autorelease];
	self.noteCreated = [en addEverNote:textToEdit at:[NSDate date]];
	if (noteCreated)
	{
		[self showStatusChangeBegin: @"note created" forTimeInterval:2.0];
	}
	else {
		[self showStatusChangeBegin: @"note creation failed" forTimeInterval:2.0];
	}
	

}*/
- (void) saveToEvernote:(NSArray *) noteEntries {
	EvernoteBackup *en = [[[EvernoteBackup alloc] init] autorelease];
	if ([en login]){
		[en initNotebook];
		for (NoteEntry *noteEntry in noteEntries) {
			if ([en addNote:noteEntry]){
				[noteEntry setValue:[NSNumber numberWithBool:YES] forKey:@"uploaded"];
				NSError *error = nil;
				if (![rootViewController.managedObjectContext save:&error]) {
					/*
					 Replace this implementation with code to handle the error appropriately.
					 
					 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
					 */
					NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
					abort();
				}
				if (noteEntry == [noteEntries objectAtIndex:0]){
					DebugLog(@"removing no data uploaded yes");
					[rootViewController removeNoDataObject:YES];
				}
			}
		}
		[self performSelectorOnMainThread:@selector(syncStatusEnd) withObject:nil waitUntilDone:NO];
	}
	else {
		DebugLog(@"login failed");
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"login error" message: @"please check your login credentials" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: @"show me", nil];
		
		[someError show];
		[someError release];
	}

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	DebugLog(@"btnIndex: %d",buttonIndex);
	//[self showInfo];
}

@end
