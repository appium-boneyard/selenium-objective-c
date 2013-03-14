//
//  Capabilities.m
//  Selenium
//
//  Created by Dan Cuellar on 3/14/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#define BROWSER_NAME @"browserName"
#define VERSION @"version"
#define PLATFORM @"platform"
#define JAVASCRIPT_ENABLED @"javascriptEnabled"
#define TAKES_SCREENSHOT @"takesScreenshot"
#define HANDLES_ALERTS @"handlesAlerts"
#define DATABASE_ENABLED @"databaseEnabled"
#define LOCATION_CONTEXT_ENABLED @"locationContextEnabled"
#define APPLICATION_CACHE_ENABLED @"applicationCacheEnabled"
#define BROWSER_CONNECTION_ENABLED @"browserConnectionEnabled"
#define CSS_SELECTORS_ENABLED @"cssSelectorsEnabled"
#define WEB_STORAGE_ENABLED @"webStorageEnabled"
#define ROTATABLE @"rotatable"
#define ACCEPT_SSL_CERTS @"acceptSslCerts"
#define NATIVE_EVENTS @"nativeEvents"
#define PROXY @"proxy"

#import "Capabilities.h"

NSMutableDictionary* _dict;

@implementation Capabilities

- (id)init
{
    self = [super init];
    if (self) {
        _dict = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Built-in Capabilities

-(NSString*)browserName { return [_dict objectForKey:BROWSER_NAME];}
-(void) setBrowserName:(NSString *)browserName { [_dict setValue:browserName forKey:BROWSER_NAME]; }

-(NSString*)version { return [_dict objectForKey:VERSION];}
-(void) setVersion:(NSString *)version { [_dict setValue:version forKey:VERSION]; }

-(NSString*)platform { return [_dict objectForKey:PLATFORM];}
-(void) setPlatform:(NSString *)platform { [_dict setValue:platform forKey:PLATFORM]; }

-(BOOL) javascriptEnabled { return [[_dict objectForKey:JAVASCRIPT_ENABLED] boolValue]; }
-(void) setJavascriptEnabled:(BOOL)javascriptEnabled { [_dict setValue:[NSNumber numberWithBool:javascriptEnabled] forKey:JAVASCRIPT_ENABLED]; }

-(BOOL) takesScreenShot { return [[_dict objectForKey:TAKES_SCREENSHOT] boolValue]; }
-(void) setTakesScreenShot:(BOOL)takesScreenShot { [_dict setValue:[NSNumber numberWithBool:takesScreenShot] forKey:TAKES_SCREENSHOT]; }

-(BOOL) handlesAlerts { return [[_dict objectForKey:HANDLES_ALERTS] boolValue]; }
-(void) setHandlesAlerts:(BOOL)handlesAlerts { [_dict setValue:[NSNumber numberWithBool:handlesAlerts] forKey:HANDLES_ALERTS]; }

-(BOOL) databaseEnabled { return [[_dict objectForKey:DATABASE_ENABLED] boolValue]; }
-(void) setDatabaseEnabled:(BOOL)databaseEnabled { [_dict setValue:[NSNumber numberWithBool:databaseEnabled] forKey:DATABASE_ENABLED]; }

-(BOOL) locationContextEnabled { return [[_dict objectForKey:LOCATION_CONTEXT_ENABLED] boolValue]; }
-(void) setLocationContextEnabled:(BOOL)locationContextEnabled { [_dict setValue:[NSNumber numberWithBool:locationContextEnabled] forKey:LOCATION_CONTEXT_ENABLED];}

-(BOOL) applicationCacheEnabled { return [[_dict objectForKey:APPLICATION_CACHE_ENABLED] boolValue]; }
-(void) setApplicationCacheEnabled:(BOOL)applicationCacheEnabled { [_dict setValue:[NSNumber numberWithBool:applicationCacheEnabled] forKey:APPLICATION_CACHE_ENABLED]; }

-(BOOL) browserConnectionEnabled { return [[_dict objectForKey:BROWSER_CONNECTION_ENABLED] boolValue]; }
-(void) setBrowserConnectionEnabled:(BOOL)browserConnectionEnabled { [_dict setValue:[NSNumber numberWithBool:browserConnectionEnabled] forKey:BROWSER_CONNECTION_ENABLED]; }

-(BOOL) cssSelectorsEnabled { return [[_dict objectForKey:CSS_SELECTORS_ENABLED] boolValue]; }
-(void) setCssSelectorsEnabled:(BOOL)cssSelectorsEnabled { [_dict setValue:[NSNumber numberWithBool:cssSelectorsEnabled] forKey:CSS_SELECTORS_ENABLED]; }

-(BOOL) webStorageEnabled { return [[_dict objectForKey:WEB_STORAGE_ENABLED] boolValue]; }
-(void) setWebStorageEnabled:(BOOL)webStorageEnabled { [_dict setValue:[NSNumber numberWithBool:webStorageEnabled] forKey:WEB_STORAGE_ENABLED]; }

-(BOOL) rotatable { return [[_dict objectForKey:ROTATABLE] boolValue]; }
-(void) setRotatable:(BOOL)rotatable { [_dict setValue:[NSNumber numberWithBool:rotatable] forKey:ROTATABLE]; }

-(BOOL) acceptSslCerts { return [[_dict objectForKey:ACCEPT_SSL_CERTS] boolValue]; }
-(void) setAcceptSslCerts:(BOOL)acceptSslCerts { [_dict setValue:[NSNumber numberWithBool:acceptSslCerts] forKey:ACCEPT_SSL_CERTS]; }

-(BOOL) nativeEvents { return [[_dict objectForKey:NATIVE_EVENTS] boolValue]; }
-(void) setNativeEvents:(BOOL)nativeEvents { [_dict setValue:[NSNumber numberWithBool:nativeEvents] forKey:NATIVE_EVENTS]; }


#pragma mark - Custom Capabilities

-(id)getCapabilityForKey:(NSString*)key { return [_dict valueForKey:key]; }
-(void)addCapabilityForKey:(NSString*)key andValue:(id)value { [_dict setValue:value forKey:key]; }


#pragma mark - JSON Conversion

-(NSData*)jsonData
{
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_dict
													  options:0/*NSJSONWritingPrettyPrinted*/
														error:&error];
	return jsonData;
}

-(NSString*) jsonString
{
	NSData *jsonData = [self jsonData];
	NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return jsonString;
}

@end
