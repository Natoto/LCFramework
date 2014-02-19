//
//  LC_UIApplicationSkeleton.m
//  LCFramework

//  Created by 郭历成 ( ADVICE & BUG : titm@tom.com ) on 13-10-11.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page  http://nsobject.me/copyright.rtf ).
//
//

#import "LC_UIApplicationSkeleton.h"

static LC_UIApplicationSkeleton * __skeleton = nil;

@implementation LC_UIApplicationSkeleton

+ (LC_UIApplicationSkeleton *)sharedInstance
{
	return __skeleton;
}

- (void)dealloc
{
	[_window release];
	_window = nil;
	
    [super dealloc];
}

- (void) load
{
    ;
}

#pragma mark -

- (void)initializeWindow
{
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor blackColor];
	[self.window makeKeyAndVisible];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	NSLog( @"applicationDidFinishLaunching" );
	
	[self application:application didFinishLaunchingWithOptions:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	__skeleton = self;
    
	[self initializeWindow];
	[self load];
	
	if ( self.window.rootViewController )
	{
		UIView * rootView = self.window.rootViewController.view;
        
		if ( rootView )
		{
			[self.window makeKeyAndVisible];
		}
	}
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

#pragma mark -

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSLog( @"applicationDidBecomeActive" );
    
	[self.window.rootViewController viewWillAppear:NO];
	[self.window.rootViewController viewDidAppear:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	NSLog( @"applicationWillResignActive" );
    
	[self.window.rootViewController viewWillDisappear:NO];
	[self.window.rootViewController viewDidDisappear:NO];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	NSLog( @"applicationDidReceiveMemoryWarning" );
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	NSLog( @"applicationWillTerminate" );
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	NSLog( @"applicationDidEnterBackground" );
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	NSLog( @"applicationWillEnterForeground" );
}

#pragma mark -

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
{
	
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
	
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
	
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
	
}

#pragma mark -


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString * token = [deviceToken description];
	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self postNotification:LC_UIApplicationDidRegisterRemoteNotification withObject:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [self postNotification:LC_UIApplicationDidRegisterRemoteFailNotification withObject:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	UIApplicationState state = [UIApplication sharedApplication].applicationState;
	if ( UIApplicationStateInactive == state || UIApplicationStateBackground == state )
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
        [self postNotification:LC_UIApplicationDidReceiveRemoteNotification withObject:dict];
	}
	else
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:YES], @"inApp", nil];
        [self postNotification:LC_UIApplicationDidReceiveRemoteNotification withObject:dict];
	}
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	UIApplicationState state = [UIApplication sharedApplication].applicationState;
	if ( UIApplicationStateInactive == state || UIApplicationStateBackground == state )
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:notification.userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
        [self postNotification:LC_UIApplicationDidReceiveLocalNotification withObject:dict];
	}
	else
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:notification.userInfo, @"userInfo", [NSNumber numberWithBool:YES], @"inApp", nil];
        [self postNotification:LC_UIApplicationDidReceiveLocalNotification withObject:dict];
	}
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application
{
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application
{
}



@end
