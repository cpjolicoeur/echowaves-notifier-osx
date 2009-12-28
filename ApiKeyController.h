//
//  ApiKeyController.h
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/28/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ApiKeyController : NSWindowController {
	IBOutlet NSTextField *userApiKey;
}

- (IBAction)updateApiKey:(id)sender;

@end
