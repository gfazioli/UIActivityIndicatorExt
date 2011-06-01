//
//  UIActivityIndicatorExt.h
//
//  Created by Giovambattista Fazioli on 31/05/11.
//  Copyright 2011 Saidmade Srl. All rights reserved.
//

#import <UIKit/UIKit.h>

// -----------------------------------------------------------------------------
/// UIActivityIndicatorExt
/**
 @class UIActivityIndicatorExt
 
 Estensione della classe UIActivityIndicator. Questa non è un subclass della
 classe originale, ma si propone come estensione più completa e comoda da
 utilizzare.
 
 */
@interface UIActivityIndicatorExt : UIView {
@private
    
    CGRect _frame;
    CGSize _size;
    NSString *_text;
    UIView *_superview;
    NSTimeInterval _orientationSpeed;
    
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_activityLabel;
    UIView *_activityView;    
}

// -----------------------------------------------------------------------------
/// Puntatore alla view con i bordi arrotondati
@property(nonatomic, retain) UIView *activityView;

// -----------------------------------------------------------------------------
/// Puntatore alla label del testo
@property(nonatomic, retain) UILabel *activityLabel;


// -----------------------------------------------------------------------------
/// Inizializza 
- (id)initWithSize:(CGSize)aSize;

// -----------------------------------------------------------------------------
/// Inizializza 
- (id)initWithSize:(CGSize)aSize andText:(NSString *)aText;

// -----------------------------------------------------------------------------
/// Visualizza
+ (id)activityWithSize:(CGSize)aSize andText:(NSString *)aText;

// -----------------------------------------------------------------------------
/// Nasconde
+ (void)dismiss:(BOOL)animated;

// -----------------------------------------------------------------------------
/// Visualizza 
- (void)show:(BOOL)animated;

// -----------------------------------------------------------------------------
/// Visualizza 
- (void)showWithSize:(CGSize)aSize andText:(NSString *)aText animated:(BOOL)animated;

@end
