//
//  EchowavesController.m
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/26/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

/*
 *
 * http://www.sonsothunder.com/devres/revolution/tutorials/StatusMenu.html
 * http://www.musicalgeometry.com/archives/571
 *
 */

#import "EchowavesController.h"
#import "Echowaves.h"
#import "UpdatedConvo.h"

@implementation EchowavesController

- (id)init {
	if (self = [super init]) {
		// Create the echowaves objects
		echowaves = [[Echowaves alloc] init];
		userDefaults = [NSUserDefaults standardUserDefaults];
	}
	return self;
}

- (void)awakeFromNib {	
	// Create the NSStatusBar and set its length
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
	
	// Used to detect where our files are
	NSBundle *bundle = [NSBundle mainBundle];
	
	// Allocates and loads th eimages into the app to use with NSStatusItem
	ewImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ewBW" ofType:@"png"]];
	ewHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ewHL" ofType:@"png"]];
	
	// Sets the images in our NSStatusItem
	[statusItem setImage:ewImage];
	[statusItem setAlternateImage:ewHighlightImage];
	//[statusItem setTitle:@"Foobar"];
	
	[ewImage release];
	[ewHighlightImage release];
	
	// Tells the NSStatusItem what menu to load
	[statusItem setMenu:statusMenu];
	// Sets the tooltip for our item
	[statusItem setToolTip:@"Echowaves Notifier"];
	// Enables highlighting
	[statusItem setHighlightMode:YES];
}

- (IBAction)queryEchowavesServer:(id)sender {
	NSLog(@"Inside #queryEchowavesServer");
	
	[echowaves getUpdates];
	
	NSLog(@"Leaving #queryEchowavesServer: %@", echowaves.updatedConvos);
}

- (IBAction)updateApiKey:(id)sender {
	// 1. Pop window to enter API Key
	// 2. Store users API key into the defaults and Echowaves object
	NSLog(@"Inside #updateApiKey");
	[NSApp activateIgnoringOtherApps:YES];
}

- (void)convoSelected:(id)sender {
	// user clicked a convo from the menu
}

- (void)dealloc {
	// Release the echowaves object
	[echowaves release];
	
	// Release the 2 images we loaded into memory
	[ewImage release];
	[ewHighlightImage release];
	[super dealloc];
}

@end
