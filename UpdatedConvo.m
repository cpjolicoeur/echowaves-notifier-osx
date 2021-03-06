//
//  UpdatedConvo.m
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/27/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import "UpdatedConvo.h"


@implementation UpdatedConvo

@synthesize ewURI, ewName, newMessagesCount;

- (id)initWithConvoName:(NSString *)convoName convoURI:(NSString *)convoURI unreadCount:(int)updatesCount; {
	if ( self = [super init] ) {
		ewURI = [convoURI copy];
		ewName = [convoName copy];
		newMessagesCount = updatesCount;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Convo: %@, URL: %@, messages count: %d", ewName, ewURI, newMessagesCount];
}

- (NSString *)truncatedName:(int)size {
	// return the ewName field truncated to 'size'
	if ( [ewName length] > size ) {
		return [[ewName substringToIndex:size] stringByAppendingString:@"..."];
	} else {
		return [ewName autorelease];
	}

}

- (void)dealloc {
	[ewURI release];
	[ewName release];
	[super dealloc];
}

@end
