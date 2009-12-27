//
//  Echowaves.m
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/26/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import "Echowaves.h"
#import "JSON.h"


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
//	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://echowaves.com/conversations/new_messages.json?user_credentials=fR2Pf-OUah5Ec9QVVKp7"]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:echowavesURI]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSLog(@"exiting Echowaves#getUpdates");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"GOT HERE: connectionDidFinishLoading");
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	if ( [responseString isEqualToString:@"\"Unable to find specified resource.\""] ) {
		NSLog(@"Unable to find specified resource.\n");
	} else {
		NSDictionary *dictionary = [responseString JSONValue];
		NSLog(@"returned dictionary data: %@", dictionary);
		
		// for now, just store the blank message
		[updatedConvos addObject:@"No new convo messages"];
		
		
		//self.someVariable = [dictionary valueForKey:@"somekey"];
		/*
		 We will be looking for 
		 ['subscription']['new_messages_count'] and
		 ['subscription']['convo_name']
		 
		 This is how Ruby's HTTParty references them.  Not sure our Obj-C's
		 dictionary will reference them as object keys
		 */
	}
	
	NSLog(@"UpdatedConvos: %@", updatedConvos);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed: %@", [error description]);
	//label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)dealloc {
	[echowavesURI release];
	[updatedConvos release];
	[responseData release];
	[super dealloc];
}

@end
