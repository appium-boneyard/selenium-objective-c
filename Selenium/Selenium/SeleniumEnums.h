//
//  Enums.h
//  Selenium
//
//  Created by Dan Cuellar on 3/19/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeleniumEnums : NSObject

typedef enum seleniumScreenOrientationTypes
{
	SELENIUM_SCREEN_ORIENTATION_PORTRAIT,
	SELENIUM_SCREEN_ORIENTATION_LANDSCAPE,
	SELENIUM_SCREEN_ORIENTATION_UNKOWN
} SeleniumScreenOrientation;

typedef enum seleniumTimeoutTypes
{
	SELENIUM_TIMEOUT_IMPLICIT,
	SELENIUM_TIMEOUT_SCRIPT,
	SELENIUM_TIMEOUT_PAGELOAD
} SeleniumTimeoutType;


typedef enum seleniumApplicationCacheStatusTypes
{
    SELENIUM_APPLICATION_CACHE_STATUS_UNCACHED,
    SELENIUM_APPLICATION_CACHE_STATUS_IDLE,
    SELENIUM_APPLICATION_CACHE_STATUS_CHECKING,
    SELENIUM_APPLICATION_CACHE_STATUS_DOWNLOADING,
    SELENIUM_APPLICATION_CACHE_STATUS_UPDATE_READY,
    SELENIUM_APPLICATION_CACHE_STATUS_OBSOLETE
} SeleniumApplicationCacheStatus;

+(NSString*) stringForTimeoutType:(SeleniumTimeoutType)type;
+(SeleniumApplicationCacheStatus) applicationCacheStatusWithInt:(NSInteger)applicationCacheStatusInt;

@end
