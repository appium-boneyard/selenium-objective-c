//
//  Status.m
//  Selenium
//
//  Created by Dan Cuellar on 3/13/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "Status.h"

@implementation Status

-(id)initWithJSON:(NSData*)jsonData
{
    self = [super init];
    if (self) {
        NSError *e = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &e];

        long status = [[json objectForKey:@"status"] longValue];
        if (status != 0)
            return nil;
        
        NSDictionary *value = [json objectForKey:@"value"];
        
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
