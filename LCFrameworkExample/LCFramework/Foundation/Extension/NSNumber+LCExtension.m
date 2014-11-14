//
//  NSNumber+LCExtension.m
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-16.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "NSNumber+LCExtension.h"

@implementation NSNumber (LCExtension)

-(int) length
{
    ERROR(@"NSNumber can't call length!");
    
    NSString * tempString = LC_NSSTRING_FORMAT(@"%@",self);
    return tempString.length;
}

@end
