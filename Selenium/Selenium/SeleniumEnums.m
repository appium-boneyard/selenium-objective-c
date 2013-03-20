//
//  Enums.m
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SeleniumEnums.h"

@implementation SeleniumEnums

+(NSString*) stringForTimeoutType:(TimeoutType)type
{
    switch (type)
    {
        case TIMEOUT_IMPLICIT:
            return @"implicit";
        case TIMEOUT_SCRIPT:
            return @"script";
        case TIMEOUT_PAGELOAD:
            return @"page load";
        default:
            return nil;
    }
}

@end
