#import "TGHacks.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <objc/runtime.h>
#import <objc/message.h>

#import "TGViewController.h"
#import "TGNavigationBar.h"

#import "TGRTL.h"

#import "TGAnimationBlockDelegate.h"
#import "TGCommon.h"

static float animationDurationFactor = 1.0f;
static float secondaryAnimationDurationFactor = 1.0f;

static bool forceMovieAnimatedScaleMode = false;

static bool forcePerformWithAnimationFlag = false;

void SwizzleClassMethod(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    
    c = object_getClass((id)c);
    
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

void SwizzleInstanceMethod(Class c, SEL orig, SEL new)
{
    Method origMethod = nil, newMethod = nil;
    
    origMethod = class_getInstanceMethod(c, orig);
    newMethod = class_getInstanceMethod(c, new);
    if ((origMethod != nil) && (newMethod != nil))
    {
        if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
            class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        else
            method_exchangeImplementations(origMethod, newMethod);
    }
    else
        NSLog(@"Attempt to swizzle nonexistent methods!");
}

void SwizzleInstanceMethodWithAnotherClass(Class c1, SEL orig, Class c2, SEL new)
{
    Method origMethod = nil, newMethod = nil;
    
    origMethod = class_getInstanceMethod(c1, orig);
    newMethod = class_getInstanceMethod(c2, new);
    if ((origMethod != nil) && (newMethod != nil))
    {
        if(class_addMethod(c1, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
            class_replaceMethod(c1, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        else
            method_exchangeImplementations(origMethod, newMethod);
    }
    else
        NSLog(@"Attempt to swizzle nonexistent methods!");
}

void InjectClassMethodFromAnotherClass(Class toClass, Class fromClass, SEL fromSelector, SEL toSeletor)
{
    Method method = class_getClassMethod(fromClass, fromSelector);
    if (method != nil)
    {
        if (!class_addMethod(toClass, toSeletor, method_getImplementation(method), method_getTypeEncoding(method)))
            NSLog(@"Attempt to add method failed");
    }
    else
        NSLog(@"Attempt to add nonexistent method");
}

void InjectInstanceMethodFromAnotherClass(Class toClass, Class fromClass, SEL fromSelector, SEL toSeletor)
{
    Method method = class_getInstanceMethod(fromClass, fromSelector);
    if (method != nil)
    {
        if (!class_addMethod(toClass, toSeletor, method_getImplementation(method), method_getTypeEncoding(method)))
            NSLog(@"Attempt to add method failed");
    }
    else
        NSLog(@"Attempt to add nonexistent method");
}

@interface UIView (TGHacks)

+ (void)telegraph_setAnimationDuration:(NSTimeInterval)duration;
+ (void)TG_performWithoutAnimation:(void (^)(void))actionsWithoutAnimation;

- (UIView *)TG_snapshotViewAfterScreenUpdates:(BOOL)afterUpdates;

@end

@implementation UIView (TGHacks)

+ (void)telegraph_setAnimationDuration:(NSTimeInterval)duration
{
    [self telegraph_setAnimationDuration:(duration * animationDurationFactor)];
}

+ (void)telegraph_animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    [self telegraph_animateWithDuration:duration * secondaryAnimationDurationFactor delay:delay options:options animations:animations completion:completion];
}

+ (void)TG_performWithoutAnimation:(void (^)(void))actionsWithoutAnimation
{
    float lastDurationFactor = animationDurationFactor;
    animationDurationFactor = 0.0f;
    
    bool animationsWereEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:false];
    
    if (actionsWithoutAnimation)
        actionsWithoutAnimation();
    
    [UIView setAnimationsEnabled:animationsWereEnabled];
    animationDurationFactor = lastDurationFactor;
}

+ (void)TG_performWithoutAnimation_maybeNot:(void (^)(void))actionsWithoutAnimation
{
    if (actionsWithoutAnimation)
    {
        if (forcePerformWithAnimationFlag)
            actionsWithoutAnimation();
        else
            [self TG_performWithoutAnimation_maybeNot:actionsWithoutAnimation];
    }
}

- (UIView *)TG_snapshotViewAfterScreenUpdates:(BOOL)__unused afterUpdates
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0f);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (image != nil)
        return [[UIImageView alloc] initWithImage:image];
    
    return nil;
}

@end

#pragma mark -

@implementation TGHacks

+ (void)hackSetAnimationDuration
{
    SwizzleClassMethod([UIView class], @selector(setAnimationDuration:), @selector(telegraph_setAnimationDuration:));
    SwizzleClassMethod([UIView class], @selector(animateWithDuration:delay:options:animations:completion:), @selector(telegraph_animateWithDuration:delay:options:animations:completion:));
    
    if (iosMajorVersion() >= 7)
    {
        if (iosMajorVersion() >= 8)
        {
            SwizzleClassMethod([UIView class], @selector(performWithoutAnimation:), @selector(TG_performWithoutAnimation_maybeNot:));
        }
    }
    else
    {
        InjectClassMethodFromAnotherClass(object_getClass([UIView class]), object_getClass([UIView class]), @selector(TG_performWithoutAnimation:), @selector(performWithoutAnimation:));
        InjectInstanceMethodFromAnotherClass([UIView class], [UIView class], @selector(TG_snapshotViewAfterScreenUpdates:), @selector(snapshotViewAfterScreenUpdates:));
    }
    
    [TGRTL doMagic];
}

+ (void)setAnimationDurationFactor:(float)factor
{
    animationDurationFactor = factor;
}

+ (void)setSecondaryAnimationDurationFactor:(float)factor
{
    secondaryAnimationDurationFactor = factor;
}

+ (void)setApplicationStatusBarAlpha:(float)alpha
{
    static SEL selector = NULL;
    if (selector == NULL)
    {
        NSString *str1 = @"rs`str";
        NSString *str2 = @"A`qVhmcnv";
        
        selector = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@%@", TGEncodeText(str1, 1), TGEncodeText(str2, 1)]);
    }
    
    if ([[UIApplication sharedApplication] respondsToSelector:selector])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIWindow *window = [[UIApplication sharedApplication] performSelector:selector];
#pragma clang diagnostic pop
        
        window.alpha = alpha;
    }
}

static UIView *findStatusBarView()
{
    static Class viewClass = nil;
    static SEL selector = NULL;
    if (selector == NULL)
    {
        NSString *str1 = @"rs`str";
        NSString *str2 = @"A`qVhmcnv";
        
        selector = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@%@", TGEncodeText(str1, 1), TGEncodeText(str2, 1)]);
        
        viewClass = NSClassFromString(TGEncodeText(@"VJTubuvtCbs", -1));
    }
    
    if ([[UIApplication sharedApplication] respondsToSelector:selector])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIWindow *window = [[UIApplication sharedApplication] performSelector:selector];
#pragma clang diagnostic pop
        
        for (UIView *subview in window.subviews)
        {
            if ([subview isKindOfClass:viewClass])
            {
                return subview;
            }
        }
    }
    
    return nil;
}

+ (void)animateApplicationStatusBarAppearance:(int)statusBarAnimation duration:(NSTimeInterval)duration completion:(void (^)())completion
{
    [self animateApplicationStatusBarAppearance:statusBarAnimation delay:0.0 duration:duration completion:completion];
}

+ (void)animateApplicationStatusBarAppearance:(int)statusBarAnimation delay:(NSTimeInterval)delay duration:(NSTimeInterval)duration completion:(void (^)())completion
{
    UIView *view = findStatusBarView();
        
    if (view != nil)
    {
        if ((statusBarAnimation & TGStatusBarAppearanceAnimationSlideDown) || (statusBarAnimation & TGStatusBarAppearanceAnimationSlideUp))
        {
            CGPoint startPosition = view.layer.position;
            CGPoint position = view.layer.position;
            
            CGPoint normalPosition = CGPointMake(floorf(view.frame.size.width / 2), floorf(view.frame.size.height / 2));
            
            float viewHeight = view.frame.size.height;
            
            if (statusBarAnimation & TGStatusBarAppearanceAnimationSlideDown)
            {
                startPosition = CGPointMake(floorf(view.frame.size.width / 2), floorf(view.frame.size.height / 2) - viewHeight);
                position = CGPointMake(floorf(view.frame.size.width / 2), floorf(view.frame.size.height / 2));
            }
            else if (statusBarAnimation & TGStatusBarAppearanceAnimationSlideUp)
            {
                startPosition = CGPointMake(floorf(view.frame.size.width / 2), floorf(view.frame.size.height / 2));
                position = CGPointMake(floorf(view.frame.size.width / 2), floorf(view.frame.size.height / 2) - viewHeight);
            }
            
            CABasicAnimation *animation = [[CABasicAnimation alloc] init];
            animation.duration = duration;
            animation.fromValue = [NSValue valueWithCGPoint:startPosition];
            animation.toValue = [NSValue valueWithCGPoint:position];
            animation.removedOnCompletion = true;
            animation.fillMode = kCAFillModeForwards;
            animation.beginTime = delay;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            TGAnimationBlockDelegate *delegate = [[TGAnimationBlockDelegate alloc] initWithLayer:view.layer];
            delegate.completion = ^(BOOL finished)
            {
                if (finished)
                    view.layer.position = normalPosition;
                if (completion)
                    completion();
            };
            animation.delegate = delegate;
            [view.layer addAnimation:animation forKey:@"position"];
            
            view.layer.position = position;
        }
        else if ((statusBarAnimation & TGStatusBarAppearanceAnimationFadeIn) || (statusBarAnimation & TGStatusBarAppearanceAnimationFadeOut))
        {
            float startOpacity = view.layer.opacity;
            float opacity = view.layer.opacity;
            
            if (statusBarAnimation & TGStatusBarAppearanceAnimationFadeIn)
            {
                startOpacity = 0.0f;
                opacity = 1.0f;
            }
            else if (statusBarAnimation & TGStatusBarAppearanceAnimationFadeOut)
            {
                startOpacity = 1.0f;
                opacity = 0.0f;
            }
            
            CABasicAnimation *animation = [[CABasicAnimation alloc] init];
            animation.duration = duration;
            animation.fromValue = @(startOpacity);
            animation.toValue = @(opacity);
            animation.removedOnCompletion = true;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            TGAnimationBlockDelegate *delegate = [[TGAnimationBlockDelegate alloc] initWithLayer:view.layer];
            delegate.completion = ^(__unused BOOL finished)
            {
                if (completion)
                    completion();
            };
            animation.delegate = delegate;
            
            [view.layer addAnimation:animation forKey:@"opacity"];
        }
    }
    else
    {
        if (completion)
            completion();
    }
}

+ (void)animateApplicationStatusBarStyleTransitionWithDuration:(NSTimeInterval)duration
{
    UIView *view = findStatusBarView();
    
    if (view != nil)
    {
        //UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0f);
        //[view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //UIImageView *snapshotView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
        //UIGraphicsEndImageContext();
        UIView *snapshotView = [view snapshotViewAfterScreenUpdates:false];
        [view addSubview:snapshotView];
        
        [UIView animateWithDuration:duration animations:^
        {
            snapshotView.alpha = 0.0f;
        } completion:^(__unused BOOL finished)
        {
            [snapshotView removeFromSuperview];
        }];
    }
}

+ (float)statusBarHeightForOrientation:(UIInterfaceOrientation)orientation
{
    static SEL selector = NULL;
    if (selector == NULL)
    {
        NSString *str1 = @"rs`str";
        NSString *str2 = @"A`qVhmcnv";
        
        selector = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@%@", TGEncodeText(str1, 1), TGEncodeText(str2, 1)]);
    }
    
    if ([[UIApplication sharedApplication] respondsToSelector:selector])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIWindow *window = [[UIApplication sharedApplication] performSelector:selector];
#pragma clang diagnostic pop
        
        Class statusBarClass = NSClassFromString(TGEncodeText(@"VJTubuvtCbs", -1));
        
        for (UIView *view in window.subviews)
        {
            if ([view isKindOfClass:statusBarClass])
            {
                SEL selector = NSSelectorFromString(TGEncodeText(@"dvssfouTuzmf", -1));
                NSMethodSignature *signature = [statusBarClass instanceMethodSignatureForSelector:selector];
                if (signature == nil)
                {
                    TGLog(@"***** Method not found");
                    return 20.0f;
                }
                
                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
                [inv setSelector:selector];
                [inv setTarget:view];
                [inv invoke];
                
                int result = 0;
                [inv getReturnValue:&result];
                
                SEL selector2 = NSSelectorFromString(TGEncodeText(@"ifjhiuGpsTuzmf;psjfoubujpo;", -1));
                NSMethodSignature *signature2 = [statusBarClass methodSignatureForSelector:selector2];
                if (signature2 == nil)
                {
                    TGLog(@"***** Method not found");
                    return 20.0f;
                }
                NSInvocation *inv2 = [NSInvocation invocationWithMethodSignature:signature2];
                [inv2 setSelector:selector2];
                [inv2 setTarget:[view class]];
                [inv2 setArgument:&result atIndex:2];
                [inv2 setArgument:&orientation atIndex:3];
                [inv2 invoke];
                
                float result2 = 0;
                [inv2 getReturnValue:&result2];
                
                return result2;
            }
        }
    }
    
    return 20.0f;
}

+ (bool)isKeyboardVisible
{
    return [self isKeyboardVisibleAlt];
}

static bool keyboardHidden = true;

+ (bool)isKeyboardVisibleAlt
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(__unused NSNotification *notification)
        {
                keyboardHidden = true;
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(__unused NSNotification *notification)
        {
            keyboardHidden = false;
        }];
    });
    
    return !keyboardHidden;
}

+ (float)keyboardHeightForOrientation:(UIInterfaceOrientation)orientation
{
    static NSInvocation *invocation = nil;
    static Class keyboardClass = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        keyboardClass = NSClassFromString(TGEncodeText(@"VJLfzcpbse", -1));
        
        SEL selector = NSSelectorFromString(TGEncodeText(@"tj{fGpsJoufsgbdfPsjfoubujpo;", -1));
        NSMethodSignature *signature = [keyboardClass methodSignatureForSelector:selector];
        if (signature == nil)
            TGLog(@"***** Method not found");
        else
        {
            invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setSelector:selector];
        }
    });

    if (invocation != nil)
    {
        [invocation setTarget:[keyboardClass class]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
        
        CGSize result = CGSizeZero;
        [invocation getReturnValue:&result];
        
        return MIN(result.width, result.height);
    }
    
    return 0.0f;
}

+ (void)applyCurrentKeyboardAutocorrectionVariant
{
    static Class keyboardClass = NULL;
    static SEL currentInstanceSelector = NULL;
    static SEL applyVariantSelector = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        keyboardClass = NSClassFromString(TGEncodeText(@"VJLfzcpbse", -1));
        
        currentInstanceSelector = NSSelectorFromString(TGEncodeText(@"bdujwfLfzcpbse", -1));
        applyVariantSelector = NSSelectorFromString(TGEncodeText(@"bddfquBvupdpssfdujpo", -1));
    });
    
    if ([keyboardClass respondsToSelector:currentInstanceSelector])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id currentInstance = [keyboardClass performSelector:currentInstanceSelector];
        if ([currentInstance respondsToSelector:applyVariantSelector])
            [currentInstance performSelector:applyVariantSelector];
#pragma clang diagnostic pop
    }
}

+ (UIWindow *)applicationKeyboardWindow
{
    static NSString *str1 = nil;
    static NSString *str2 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        str1 = TGEncodeText(@"=VJQfsjqifsbmIptuWjfx", -1);
        str2 = TGEncodeText(@"=VJLfzcpbse", -1);
    });
    
    static int lastKeyboardIndex = -1;
    static int64_t lastWindowPtr = 0;
    static int64_t lastKeyboardPtr = 0;
    Class UIWindowClass = [UIWindow class];
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (lastWindowPtr == (int64_t)window)
        {
            //TGLog(@"very optimized get");
            return window;
        }
        
        if (![[window class] isEqual:UIWindowClass])
        {
            NSArray *subviews = window.subviews;
            if (lastKeyboardIndex >= 0 && lastKeyboardIndex < subviews.count)
            {
                UIView *possibleKeyboard = [subviews objectAtIndex:lastKeyboardIndex];
                if (lastKeyboardPtr == (int64_t)possibleKeyboard)
                {
                    //TGLog(@"optimized get");
                    return window;
                }
                
                if ([[possibleKeyboard description] hasPrefix:str1])
                {
                    for (UIView *subview in possibleKeyboard.subviews)
                    {
                        if ([[subview description] hasPrefix:str2])
                        {
                            //TGLog(@"less optimized get");
                            lastKeyboardPtr = (int64_t)possibleKeyboard;
                            lastWindowPtr = (int64_t)window;
                            return window;
                        }
                    }
                }
            }
            
            int index = -1;
            for (UIView *view in subviews)
            {
                index++;
                UIView *possibleKeyboard = view;
                
                if ([[possibleKeyboard description] hasPrefix:str1])
                {
                    for (UIView *subview in possibleKeyboard.subviews)
                    {
                        if ([[subview description] hasPrefix:str2])
                        {
                            lastKeyboardIndex = index;
                            lastKeyboardPtr = (int64_t)possibleKeyboard;
                            lastWindowPtr = (int64_t)window;
                            return window;
                        }
                    }
                }
            }
        }
    }
    
    return nil;
}

+ (UIView *)applicationKeyboardView
{
    static Class keyboardViewClass = Nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        keyboardViewClass = NSClassFromString(TGEncodeText(@"VJQfsjqifsbmIptuWjfx", -1));
    });
    
    for (UIView *view in [self applicationKeyboardWindow].subviews)
    {
        if ([view isKindOfClass:keyboardViewClass])
            return view;
    }
    
    return nil;
}

+ (void)setForceMovieAnimatedScaleMode:(bool)force
{
    forceMovieAnimatedScaleMode = force;
}

+ (void)forcePerformWithAnimation:(dispatch_block_t)block
{
    if (block)
    {
        bool flag = forcePerformWithAnimationFlag;
        forcePerformWithAnimationFlag = true;
        block();
        forcePerformWithAnimationFlag = flag;
    }
}

@end

#if TARGET_IPHONE_SIMULATOR
extern CGFloat UIAnimationDragCoefficient(void);
#endif

float TGAnimationSpeedFactor()
{
#if TARGET_IPHONE_SIMULATOR
    return UIAnimationDragCoefficient();
#endif
    
    return 1.0f;
}
