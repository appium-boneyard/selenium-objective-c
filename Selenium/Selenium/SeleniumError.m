//
//  SeleniumError.m
//  Selenium
//
//  Created by Dan Cuellar on 3/16/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "SeleniumError.h"

@implementation SeleniumError

+(SeleniumError*) errorWithCode:(NSInteger)code Message:(NSString*)message
{
    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    return (SeleniumError*)[SeleniumError errorWithDomain:@"com.appium.selenium" code:code userInfo:details];
}

+(SeleniumError*) errorWithCode:(NSInteger)code
{
    switch (code)
    {
        case 0: return [self success];
        case 6: return [self noSuchDriver];
        case 7: return [self noSuchElement];
        case 8: return [self noSuchFrame];
        case 9: return [self unknownCommand];
        case 10: return [self staleElementReference];
        case 11: return [self elementNotVisible];
        case 12: return [self invalidElementState];
        case 13: return [self unknownError];
        case 15: return [self elementIsNotSelectable];
        case 17: return [self javaScriptError];
        case 19: return [self xpathLookupError];
        case 21: return [self timeout];
        case 23: return [self noSuchWindow];
        case 24: return [self invalidCookieDomain];
        case 25: return [self unableToSetCookie];
        case 26: return [self unexpectedAlertOpen];
        case 27: return [self noAlertOpenError];
        case 28: return [self scriptTimeout];
        case 29: return [self invalidElementCoordinates];
        case 30: return [self imeNotAvailable];
        case 31: return [self imeEngineActivationFailed];
        case 32: return [self invalidSelector];
        case 33: return [self sessionNotCreatedException];
        case 34: return [self moveTargetOutOfBounds];
        default: return [self unknownError];
    }
}

+(SeleniumError*) errorWithResponseDict:(NSDictionary*)dict
{
    return [SeleniumError errorWithCode:[[dict objectForKey:@"status"] integerValue]];
}

+(SeleniumError*) success { return [self errorWithCode:0 Message:@"Success: The command executed successfully."]; }

+(SeleniumError*) noSuchDriver { return [self errorWithCode:6 Message:@"NoSuchDriver: A session is either terminated or not started."]; }

+(SeleniumError*) noSuchElement { return [self errorWithCode:7 Message:@"NoSuchElement: An element could not be located on the page using the given search parameters."]; }

+(SeleniumError*) noSuchFrame { return [self errorWithCode:8 Message:@"NoSuchFrame: A request to switch to a frame could not be satisfied because the frame could not be found."]; }

+(SeleniumError*) unknownCommand { return [self errorWithCode:9 Message:@"UnknownCommand: The requested resource could not be found, or a request was received using an HTTP method that is not supported by the mapped resource."]; }

+(SeleniumError*) staleElementReference { return [self errorWithCode:10 Message:@"StaleElementReference: An element command failed because the referenced element is no longer attached to the DOM."]; }

+(SeleniumError*) elementNotVisible { return [self errorWithCode:11 Message:@"ElementNotVisible: An element command could not be completed because the element is not visible on the page."]; }

+(SeleniumError*) invalidElementState { return [self errorWithCode:12 Message:@"InvalidElementState: An element command could not be completed because the element is in an invalid state (e.g. attempting to click a disabled element)."]; }

+(SeleniumError*) unknownError { return [self errorWithCode:13 Message:@"UnknownError: An unknown server-side error occurred while processing the command."]; }

+(SeleniumError*) elementIsNotSelectable { return [self errorWithCode:15 Message:@"ElementIsNotSelectable: An attempt was made to select an element that cannot be selected."]; }

+(SeleniumError*) javaScriptError { return [self errorWithCode:17 Message:@"JavaScriptError: An error occurred while executing user supplied JavaScript."]; }

+(SeleniumError*) xpathLookupError { return [self errorWithCode:19 Message:@"XPathLookupError: An error occurred while searching for an element by XPath."]; }

+(SeleniumError*) timeout { return [self errorWithCode:21 Message:@"Timeout: An operation did not complete before its timeout expired."]; }

+(SeleniumError*) noSuchWindow { return [self errorWithCode:23 Message:@"NoSuchWindow: A request to switch to a different window could not be satisfied because the window could not be found."]; }

+(SeleniumError*) invalidCookieDomain { return [self errorWithCode:24 Message:@"InvalidCookieDomain: An illegal attempt was made to set a cookie under a different domain than the current page."]; }

+(SeleniumError*) unableToSetCookie { return [self errorWithCode:25 Message:@"UnableToSetCookie: A request to set a cookie's value could not be satisfied."]; }

+(SeleniumError*) unexpectedAlertOpen { return [self errorWithCode:26 Message:@"UnexpectedAlertOpen: A modal dialog was open, blocking this operation"]; }

+(SeleniumError*) noAlertOpenError { return [self errorWithCode:27 Message:@"NoAlertOpenError: An attempt was made to operate on a modal dialog when one was not open."]; }

+(SeleniumError*) scriptTimeout { return [self errorWithCode:28 Message:@"ScriptTimeout: A script did not complete before its timeout expired."]; }

+(SeleniumError*) invalidElementCoordinates { return [self errorWithCode:29 Message:@"InvalidElementCoordinates: The coordinates provided to an interactions operation are invalid."]; }

+(SeleniumError*) imeNotAvailable { return [self errorWithCode:30 Message:@"IMENotAvailable: IME was not available."]; }

+(SeleniumError*) imeEngineActivationFailed { return [self errorWithCode:31 Message:@"IMEEngineActivationFailed: An IME engine could not be started."]; }

+(SeleniumError*) invalidSelector { return [self errorWithCode:32 Message:@"InvalidSelector: Argument was an invalid selector (e.g. XPath/CSS)."]; }

+(SeleniumError*) sessionNotCreatedException { return [self errorWithCode:33 Message:@"SessionNotCreatedException: A new session could not be created."]; }

+(SeleniumError*) moveTargetOutOfBounds { return [self errorWithCode:34 Message:@"MoveTargetOutOfBounds: Target provided for a move action is out of bounds."]; }

@end
