//
//  EchowavesController.h
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/26/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Echowaves.h"

#define _userApiKey [[NSUserDefaults standardUserDefaults] stringForKey:@"userApiKey"]
#define _convoBaseURI @"http://echowaves.com/conversations/"

@class ApiKeyController;

@interface EchowavesController : NSObject {
	Echowaves *echowaves;
	NSUserDefaults *userDefaults;
	
	ApiKeyController *apiWindow;
	
	IBOutlet NSMenu *statusMenu;
	
	NSStatusItem *statusItem;
	NSImage	*ewImage;
	NSImage *ewHighlightImage;
}

- (IBAction)queryEchowavesServer:(id)sender;
- (IBAction)updateApiKey:(id)sender;
- (void)convoSelected:(id)sender;
- (void)getUpdates;
- (void)openEchowavesURL:(NSURL *)urlToOpen;
- (void)reloadMenuItems;

@end
