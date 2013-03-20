//
//  RemoteWebDriverSession.m
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "RemoteWebDriverSession.h"

@implementation RemoteWebDriverSession

-(id) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
		[self setCapabilities:[[Capabilities alloc] initWithDictionary:[dict objectForKey:@"value"]]];
		[self setSessionId:[dict objectForKey:@"sessionId"]];
    }
    return self;
}

@end
