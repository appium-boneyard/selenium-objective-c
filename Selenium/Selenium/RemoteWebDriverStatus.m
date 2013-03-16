//
//  Status.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "RemoteWebDriverStatus.h"

@implementation RemoteWebDriverStatus

-(id)initWithDictionary:(NSDictionary*)dict
{
	self = [super init];
    if (self) {
		[self setStatus:[[dict objectForKey:@"status"] longValue]];
		
		NSDictionary *value = [dict objectForKey:@"value"];
		
		NSDictionary *build = [value objectForKey:@"build"];
		[self setBuildVersion:[build objectForKey:@"version"]];
		[self setBuildRevision:[build objectForKey:@"revision"]];
		[self setBuildTime:[build objectForKey:@"time"]];
		
		NSDictionary *os = [value objectForKey:@"os"];
		[self setOsArchitecture:[os objectForKey:@"arch"]];
		[self setOsName:[os objectForKey:@"name"]];
		[self setOsVersion:[os objectForKey:@"version"]];
    }
    return self;
}

@end