//
//  LS_LOG.m
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-12.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "LC_Log.h"
#import "LC_Precompile.h"


extern "C" NSString * NSStringFormatted( NSString * format, va_list argList )
{
	return [[[NSString alloc] initWithFormat:format arguments:argList] autorelease];
}

extern "C" void LCLog( NSObject * format, ... )
{
#if defined(LC_LOG_ENABLE) && LC_LOG_ENABLE
    
	if ( nil == format )
		return;
    
	va_list args;
	va_start( args, format );
	
	NSString * text = nil;
	
	if ( [format isKindOfClass:[NSString class]] ){
		text = [NSString stringWithFormat:@"LC 🔧 [LOG] ⥤ %@", NSStringFormatted((NSString *)format, args)];
	}
	else{
		text = [NSString stringWithFormat:@"LC ⥤ %@", [format description]];
	}
    
    va_end( args );
    
	if ( [text rangeOfString:@"\n"].length ){
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
	}
    
#if defined(LC_DEBUG_ENABLE) && LC_DEBUG_ENABLE
    
    [[LC_DebugInformationView LCInstance] appendLogString:text];
    
#endif
    
	printf("%s",[text UTF8String]);
	printf("\n");
    
#endif
}


extern "C" void LCInfo( NSObject * format, ... )
{
#if defined(LC_LOG_ENABLE) && LC_LOG_ENABLE
    
	if (nil == format )
		return;
    
    va_list args;
	va_start( args, format );
	
	NSString * text = nil;
	
	if ( [format isKindOfClass:[NSString class]] ){
		text = [NSString stringWithFormat:@"LC ✨ [INFO] ⥤ %@", NSStringFormatted((NSString *)format, args)];
	}
	else{
		text = [NSString stringWithFormat:@"LC ✨ [INFO] ⥤ %@", [format description]];
	}
    
    va_end( args );
    
	if ( [text rangeOfString:@"\n"].length ){
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
	}
    
#if defined(LC_DEBUG_ENABLE) && LC_DEBUG_ENABLE
    
    [[LC_DebugInformationView LCInstance] appendLogString:text];
    
#endif
    
	printf("%s",[text UTF8String]);
	printf("\n");
    
#endif
    
}

extern "C" void LCError( NSString * file, const char * function , int line, NSObject * format, ... )
{
    va_list args;
	va_start( args, format );
	
	NSString * text = nil;
	
	if ( [format isKindOfClass:[NSString class]] ){
		text = [NSString stringWithFormat:@"LC 💀 [ERROR] ⥤ %@", NSStringFormatted((NSString *)format, args)];
	}
	else{
		text = [NSString stringWithFormat:@"LC 💀 [ERROR] ⥤ %@", [format description]];
	}
    
    va_end( args );
    
	if ( [text rangeOfString:@"\n"].length ){
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
	}
    
#if defined(LC_DEBUG_ENABLE) && LC_DEBUG_ENABLE
    
    [[LC_DebugInformationView LCInstance] appendLogString:text];
    [[LC_DebugInformationView LCInstance] appendLogString:[NSString stringWithFormat:@"\n\n[\n    File : %@",file]];
    [[LC_DebugInformationView LCInstance] appendLogString:[NSString stringWithFormat:@"\n    Line : %d",line]];
    [[LC_DebugInformationView LCInstance] appendLogString:[NSString stringWithFormat:@"\n    Function : %s\n]\n",function]];

    
#endif
    
    printf("%s",[text UTF8String]);
    printf("\n\n[\n    File : %s",[file UTF8String]);
    printf("\n    Line : %d",line);
    printf("\n    Function : %s\n]\n\n",function);
    
#if defined(LC_ERROR_LOCAL_FILE_LOG) && LC_ERROR_LOCAL_FILE_LOG

    // Write to file...
    
#endif

}

extern "C" void LCCMDInfo( NSObject * format, ... )
{
#if defined(LC_DEBUG_ENABLE) && LC_DEBUG_ENABLE
    
    va_list args;
	va_start( args, format );
	
	NSString * text = nil;
	
	if ( [format isKindOfClass:[NSString class]] ){
		text = [NSString stringWithFormat:@"LC ➕ [CMD] ⥤ %@", NSStringFormatted((NSString *)format, args)];
	}
	else{
		text = [NSString stringWithFormat:@"LC ➕ [CMD] ⥤ %@", [format description]];
	}
    
    va_end( args );
    
	if ( [text rangeOfString:@"\n"].length ){
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
	}
    
    [[LC_DebugInformationView LCInstance] appendLogString:text];
    printf("%s",[text UTF8String]);
	printf("\n");
    
#endif
}


NSString * extractFileNameWithoutExtension(const char * filePath, BOOL copy)
{
	if (filePath == NULL) return nil;
	
	char *lastSlash = NULL;
	char *lastDot = NULL;
	
	char *p = (char *)filePath;
	
	while (*p != '\0')
	{
		if (*p == '/')
			lastSlash = p;
		else if (*p == '.')
			lastDot = p;
		
		p++;
	}
	
	char *subStr;
	NSUInteger subLen;
	
	if (lastSlash)
	{
		if (lastDot)
		{
			// lastSlash -> lastDot
			subStr = lastSlash + 1;
			subLen = lastDot - subStr;
		}
		else
		{
			// lastSlash -> endOfString
			subStr = lastSlash + 1;
			subLen = p - subStr;
		}
	}
	else
	{
		if (lastDot)
		{
			// startOfString -> lastDot
			subStr = (char *)filePath;
			subLen = lastDot - subStr;
		}
		else
		{
			// startOfString -> endOfString
			subStr = (char *)filePath;
			subLen = p - subStr;
		}
	}
	
	if (copy)
	{
		return [[[NSString alloc] initWithBytes:subStr
		                                length:subLen
		                              encoding:NSUTF8StringEncoding] autorelease];
	}
	else
	{
		// We can take advantage of the fact that __FILE__ is a string literal.
		// Specifically, we don't need to waste time copying the string.
		// We can just tell NSString to point to a range within the string literal.
		
		return [[[NSString alloc] initWithBytesNoCopy:subStr
		                                      length:subLen
		                                    encoding:NSUTF8StringEncoding
		                                freeWhenDone:NO] autorelease];
	}
}


