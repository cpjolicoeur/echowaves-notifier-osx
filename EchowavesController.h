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
#define _updateInterval 10

@class ApiKeyController;

@interface EchowavesController : NSObject {
	Echowaves *echowaves;
	ApiKeyController *apiWindow;
	id delegate;
	NSUserDefaults *userDefaults;
	NSTimer *updateTimer;
	
	IBOutlet NSMenu *statusMenu;
	
	NSStatusItem *statusItem;
	NSImage	*ewImage;
	NSImage *ewHighlightImage;
}

@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, retain) id delegate;

- (IBAction)queryEchowavesServer:(id)sender;
- (IBAction)updateApiKey:(id)sender;
- (void)convoSelected:(id)sender;
- (void)getUpdates;
- (void)openEchowavesURL:(NSURL *)urlToOpen;
- (void)reloadMenuItems;

@end
