//
//  Echowaves.m
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/26/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import "Echowaves.h"
#import "JSON.h"
#import "UpdatedConvo.h"


@implementation Echowaves

@synthesize responseData, updatedConvos;
@synthesize echowavesURI;

- (id)init {
	if ( self = [super init] ) {
		// do custom stuff here
		
		updatedConvos = [[NSMutableArray array] retain];
		
		// https://echowaves.com/conversations/new_messages.json?user_credentials=fR2Pf-OUah5Ec9QVVKp7
		NSString *apiKey = @"fR2Pf-OUah5Ec9QVVKp7";
		NSString *baseURI = @"https://echowaves.com/conversations/new_messages.json?user_credentials=";
		echowavesURI = [[baseURI stringByAppendingString:apiKey] retain];
		NSLog(@"Allocating Echowaves object with URI: %@", echowavesURI);
	}
	return self;
}

- (void)getUpdates {
	// get updates from Echowaves.com here
	responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:echowavesURI]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	if ( [responseString isEqualToString:@"\"Unable to find specified resource.\""] ) {
		NSLog(@"Unable to find specified resource.\n");
	} else {
		[updatedConvos removeAllObjects];
		NSDictionary *dictionary = [responseString JSONValue];
		if ( [dictionary count] ) {
			NSLog(@"returned dictionary data: %@", dictionary);
			for (NSDictionary *subscription in dictionary ) {
				UpdatedConvo *convo = [[UpdatedConvo alloc] initWithConvoName:[[subscription objectForKey:@"subscription"] objectForKey:@"convo_name"]
																   convoURI:[[subscription objectForKey:@"subscription"] objectForKey:@"@conversation_id"]
																unreadCount:[[[subscription objectForKey:@"subscription"] objectForKey:@"new_messages_count"] integerValue]];
				
				
				[updatedConvos addObject:convo];
				[convo release];
			}
		} else {
			// * No new subscriptions
			// * for now, just store the blank message
			[updatedConvos addObject:@"No new convo messages"];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed: %@", [error description]);
	[updatedConvos removeAllObjects];
	[updatedConvos addObject:@"Connection failure"];
}

- (void)dealloc {
	[echowavesURI release];
	[updatedConvos release];
	[responseData release];
	[super dealloc];
}

@end
