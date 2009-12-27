//
//  UpdatedConvo.h
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/27/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UpdatedConvo : NSObject {
	NSString *convoURI;
	NSString *name;
	int newMessagesCount;
}

@property int newMessagesCount;
@property (nonatomic, retain) NSString *URI;
@property (nonatomic, retain) NSString *name;

- (id)initWithConvoName:(NSString *)convoName convoURI:(NSString *)convoURI unreadCount:(int)updatesCount;

@end
