//
//  LC_UIKeyBoardManager.m
//  LCFramework
//
//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-10-17.
//  Copyright (c) 2013年 LS Developer ( http://www.likesay.com ). All rights reserved.
//

#import "LC_UIKeyBoard.h"

#define	DEFAULT_KEYBOARD_HEIGHT	(216.0f)

@interface LC_UIKeyBoard ()
{
	CGRect		_accessorFrame;
	UIView *	_accessor;
}

@end

@implementation LC_UIKeyBoard


-(void) dealloc
{
    [self unobserveAllNotifications];
    LC_SUPER_DEALLOC();
}

+(void) load
{
    [LC_UIKeyBoard LCInstance];
}

-(id) init
{
    LC_SUPER_INIT({
    
        _isShowing = NO;
        _animationDuration = 0.25;
        _height = DEFAULT_KEYBOARD_HEIGHT;
        
        [self observeNotification:UIKeyboardDidShowNotification];
		[self observeNotification:UIKeyboardDidHideNotification];
		[self observeNotification:UIKeyboardWillChangeFrameNotification];
    });
}


-(void) handleNotification:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    
	if ( userInfo )
	{
		_animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	}
    
    if ([notification is:UIKeyboardDidShowNotification]) {
        
        if (NO == _isShowing){
			_isShowing = YES;
            // Is showing.
		}
		
		NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
		if (value)
		{
			CGRect keyboardEndFrame = [value CGRectValue];
			CGFloat	keyboardHeight = keyboardEndFrame.size.height;
			
			if ( keyboardHeight != _height )
			{
				_height = keyboardHeight;
                // Height changed.
			}
		}


    }else if ([notification is:UIKeyboardWillChangeFrameNotification]){
        
        NSValue * value1 = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
		NSValue * value2 = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
		if (value1 && value2)
		{
			CGRect rect1 = [value1 CGRectValue];
			CGRect rect2 = [value2 CGRectValue];
            
			if (rect1.origin.y >= [UIScreen mainScreen].bounds.size.height){
				if (NO == _isShowing){
					_isShowing = YES;
					// Is showing.
				}
                
				if ( rect2.size.height != _height ){
					_height = rect2.size.height;
					// Height changed.
				}
			}
			else if (rect2.origin.y >= [UIScreen mainScreen].bounds.size.height){
				if (rect2.size.height != _height){
					_height = rect2.size.height;
					// Height changed.
				}
                
				if (_isShowing){
					_isShowing = NO;
					// Is hidden.
				}
			}
		}
    }else if ([notification is:UIKeyboardDidHideNotification]){
    
        NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
		if (value)
		{
			CGRect	keyboardEndFrame = [value CGRectValue];

			CGFloat	keyboardHeight = keyboardEndFrame.size.height;
			
			if (keyboardHeight != _height){
				_height = keyboardHeight;
			}
		}
        
		if (_isShowing){
			_isShowing = NO;
			// Height changed.
		}
    }

    [self updateAccessorFrame];
}

- (void)setAccessor:(UIView *)view
{
	_accessor = view;
	_accessorFrame = view.frame;
}

-(void) updateAccessorFrame
{
    if ( nil == _accessor )
		return;
    
    LC_FAST_ANIMATIONS(self.animationDuration, ^{
    
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        if (_isShowing){
            CGFloat containerHeight = _accessor.superview.bounds.size.height;
            CGRect newFrame = _accessorFrame;
            newFrame.origin.y = containerHeight - (_accessorFrame.size.height + _height);
            _accessor.frame = newFrame;
        }
        else{
            _accessor.frame = _accessorFrame;
        }
    
    });
}


@end
