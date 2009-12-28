//
//  ApiKeyController.m
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/28/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import "ApiKeyController.h"
#import "EchowavesController.h"


@implementation ApiKeyController

- (id)init {
	if ( ![super initWithWindowNibName:@"ApiKey"] ) return nil;
	return self;
}


- (void)awakeFromNib {
	if ( _userApiKey ) {
		[userApiKey setStringValue:_userApiKey];
	}
}


- (IBAction)updateApiKey:(id)sender {
	NSString *apiKey = [userApiKey stringValue];
	if ( [apiKey length] == 0 ) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userApiKey"];
		NSLog(@"User entered zero length API Key. Skipping update and removing userApiKey NSUserDefault");
		// TODO: disable manual update menu item
	} else {
		[[NSUserDefaults standardUserDefaults] setObject:apiKey forKey:@"userApiKey"];
		NSLog(@"Updated _userApiKey with: %@", apiKey);
	}
	[self close];
}

@end
