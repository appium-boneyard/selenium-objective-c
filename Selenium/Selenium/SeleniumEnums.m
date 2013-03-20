//
//  Enums.m
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SeleniumEnums.h"

@implementation SeleniumEnums

+(NSString*) stringForTimeoutType:(SeleniumTimeoutType)type
{
    switch (type)
    {
        case SELENIUM_TIMEOUT_IMPLICIT:
            return @"implicit";
        case SELENIUM_TIMEOUT_SCRIPT:
            return @"script";
        case SELENIUM_TIMEOUT_PAGELOAD:
            return @"page load";
        default:
            return nil;
    }
}

@end
