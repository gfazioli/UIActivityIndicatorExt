//
//  UIActivityIndicatorExt.m
//
//  Created by Giovambattista Fazioli on 31/05/11.
//  Copyright 2011 Saidmade Srl. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIActivityIndicatorExt.h"

#define kUIActivityIndicatorDefaultString       @"Wait..."
#define kUIActivityIndicatorDefaultSize         CGSizeMake(300., 300.)
#define kUIActivityIndicatorOrientationSpeed    0.3
#define kUIActivityIndicatorCornerRadius        12.

static UIActivityIndicatorExt *sharedInstance = nil; 

/// @cond private
@interface UIActivityIndicatorExt(/* Private */)
- (void)centerToView:(UIView *)aView;
- (void)alignToCenter;
@end
/// @endcond

@implementation UIActivityIndicatorExt

@synthesize activityView = _activityView;
@synthesize activityLabel = _activityLabel;

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    
    // Rimuove le notifiche relative all'orientamento    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [_activityIndicator release];
    _activityIndicator = nil;
    [_activityLabel release];
    _activityLabel = nil;
    [_activityView release];
    _activityView = nil;
    
    [super dealloc];
}

- (void)commonInit 
{
    _orientationSpeed = kUIActivityIndicatorOrientationSpeed;
    
    // Orientation Notification
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationDidChangeNotification:) 
                                                 name:UIDeviceOrientationDidChangeNotification 
                                               object:nil]; 
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    // Round View
    _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
    _activityView.autoresizingMask = UIViewAutoresizingNone;
    _activityView.layer.cornerRadius = kUIActivityIndicatorCornerRadius;
    _activityView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _activityView.center = CGPointMake(_frame.size.width/2, _frame.size.height/2);
    
    // Label indicativa
    _activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _activityView.bounds.size.height - 60., _activityView.bounds.size.width - 10, 60.)];
    _activityLabel.textColor = [UIColor whiteColor];
    _activityLabel.numberOfLines = 2;
    _activityLabel.backgroundColor = [UIColor clearColor];
    _activityLabel.text = _text;
    _activityLabel.textAlignment = UITextAlignmentCenter;
    [_activityView addSubview:_activityLabel];
    
    // Activity indicator animator
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator startAnimating];
    _activityIndicator.center = CGPointMake(_activityView.bounds.size.width/2, _activityView.bounds.size.height/2);
    
    [_activityView addSubview:_activityIndicator];
    [self addSubview:_activityView];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _frame = frame;
        _size = kUIActivityIndicatorDefaultSize;
        _text = kUIActivityIndicatorDefaultString;
        [self commonInit];
    }
    return self;
}

- (id)initWithSize:(CGSize)aSize
{
    _superview = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    _frame = _superview.bounds;
    
    self = [super initWithFrame:_frame];
    if (self) {
        // Initialization code
        _size = aSize;
        _text = kUIActivityIndicatorDefaultString;
        [self commonInit];
    }
    return self;
}

- (id)initWithSize:(CGSize)aSize andText:(NSString *)aText
{
    _superview = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    _frame = _superview.bounds;
    
    self = [super initWithFrame:_frame];
    if (self) {
        // Initialization code
        _size = aSize;
        _text = aText;
        [self commonInit];
    }
    return self;
}

+ (id)activityWithSize:(CGSize)aSize andText:(NSString *)aText
{
    if (sharedInstance == nil) {
        sharedInstance = [[[self class] alloc] initWithSize:aSize andText:aText];
    } 
    
    [sharedInstance showWithSize:aSize andText:aText animated:YES];
    return sharedInstance;
}

+ (void)dismiss:(BOOL)animated
{
    if (sharedInstance != nil) {
        if (animated) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(dismiss:)];
            
            [sharedInstance setAlpha:0.];   
            
            [UIView commitAnimations];
        } else {
            [sharedInstance setAlpha:1.];
            [sharedInstance setHidden:YES];
        }        
    }
}

- (void)show:(BOOL)animated 
{
    if(self.superview == nil) {
        [_superview addSubview:self];        
    }
    _activityLabel.text = _text;
        
    if (animated) {
        if (self.hidden) {
            [self setAlpha:0.]; 
            [self setHidden:NO];
        }

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismiss:)];
        
        [self centerToView:_superview];
        [self alignToCenter];
        [self setAlpha:1.];   
        
        [UIView commitAnimations];
    } else {
        [self centerToView:_superview];
        [self alignToCenter];
        [self setHidden:NO];
    }
    [[self superview] bringSubviewToFront:self];    
}

- (void)showWithSize:(CGSize)aSize andText:(NSString *)aText animated:(BOOL)animated
{
    _size = aSize;
    _text = aText;
    CGRect activityFrame = _activityView.frame;
    activityFrame.size = aSize;
    _activityView.frame = activityFrame;

    [self show:animated];
}


#pragma mark - Private

- (void)centerToView:(UIView *)aView {
    CGPoint centerPoint = CGPointMake(aView.bounds.size.width/2, aView.bounds.size.height/2);
    _activityView.center = centerPoint;
}

- (void)alignToCenter
{
    _activityLabel.frame = CGRectMake(10, _activityView.bounds.size.height - 60., _activityView.bounds.size.width - 10, 60.);
    _activityIndicator.center = CGPointMake(_activityView.bounds.size.width/2, _activityView.bounds.size.height/2);
}


#pragma mark - Orietation Notification

- (void)updateForOrientation {
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    NSLog(@"%s: %d", __FUNCTION__, deviceOrientation);
    
    self.frame = [[self superview] bounds];
    
    
	if (UIInterfaceOrientationIsLandscape(deviceOrientation)) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:_orientationSpeed];
        if (deviceOrientation == UIInterfaceOrientationLandscapeLeft) {
            [_activityView setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        } else {
            [_activityView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        }
        [UIView commitAnimations];
    } else if (UIInterfaceOrientationIsPortrait(deviceOrientation)) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:_orientationSpeed];
        if (deviceOrientation == UIInterfaceOrientationPortrait) {
            [_activityView setTransform:CGAffineTransformIdentity];
        } else {
            [_activityView setTransform:CGAffineTransformMakeRotation(M_PI)];
        }
        [UIView commitAnimations];
	}        
}

- (void)layoutSubviews
{
    NSLog(@"%s", __FUNCTION__);
    
    //[self performSelector:@selector(updateForOrientation) withObject:nil afterDelay:0];    
}

#pragma mark - Orientation

- (void)orientationDidChangeNotification:(NSNotification *)aNotification {	
	//NSLog(@"%s: %d", __FUNCTION__, [UIDevice currentDevice].orientation);
    [self performSelector:@selector(updateForOrientation) withObject:nil afterDelay:0];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end