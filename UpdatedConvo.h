//
//  UpdatedConvo.h
//  EchowavesNotifier
//
//  Created by Craig Jolicoeur on 12/27/09.
//  Copyright 2009 Dr J Enterprises, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UpdatedConvo : NSObject {
	NSString *ewURI;
	NSString *ewName;
	int newMessagesCount;
}

@property int newMessagesCount;
@property (nonatomic, copy) NSString *ewURI;
@property (nonatomic, copy) NSString *ewName;

- (id)initWithConvoName:(NSString *)convoName convoURI:(NSString *)convoURI unreadCount:(int)updatesCount;

@end
