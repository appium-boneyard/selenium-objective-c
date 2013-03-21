//
//  SESession.m
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SESession.h"

@implementation SESession

-(id) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
		[self setCapabilities:[[SECapabilities alloc] initWithDictionary:[dict objectForKey:@"value"]]];
		[self setSessionId:[dict objectForKey:@"sessionId"]];
    }
    return self;
}

@end
