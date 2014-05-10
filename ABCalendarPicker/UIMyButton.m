//
//  UIMyButton.m
//  ABCalendarPicker
//
//  Created by Anton Bukov on 25.08.12.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIMyButton.h"

@interface UIMyButton ()
@property (nonatomic) NSMutableDictionary * titles;
@property (nonatomic) NSMutableDictionary * titleColors;
@property (nonatomic) NSMutableDictionary * titleShadowColors;
@property (nonatomic) NSMutableDictionary * titleShadowOffsets;
@property (nonatomic) NSMutableDictionary * backgroundImages;
@end

@implementation UIMyButton

@synthesize numberOfDots = _numberOfDots;

@synthesize titles = _titles;
@synthesize titleColors = _titleColors;
@synthesize titleShadowColors = _titleShadowColors;
@synthesize titleShadowOffsets = _titleShadowOffsets;
@synthesize backgroundImages = _backgroundImages;

#pragma mark -
#pragma mark Properties section

- (id)init
{
    self = [super init];
    if(self)
    {
        _tileTitleFont = [UIFont boldSystemFontOfSize:21.0];
        _tileDotFont = [UIFont boldSystemFontOfSize:17.0];
    }
    return self;
}


+ (NSMutableDictionary *)stateSizeImageDict
{
    static NSMutableDictionary * dict = nil;
    if (dict == nil)
        dict = [NSMutableDictionary dictionary];
    return dict;
}

- (NSMutableDictionary *)titles
{
    if (_titles == nil)
        _titles = [NSMutableDictionary dictionary];
    return _titles;
}

- (NSMutableDictionary *)titleColors
{
    if (_titleColors == nil)
        _titleColors = [NSMutableDictionary dictionary];
    return _titleColors;
}

- (NSMutableDictionary *)titleShadowColors
{
    if (_titleShadowColors == nil)
        _titleShadowColors = [NSMutableDictionary dictionary];
    return _titleShadowColors;
}

- (NSMutableDictionary *)titleShadowOffsets
{
    if (_titleShadowOffsets == nil)
        _titleShadowOffsets = [NSMutableDictionary dictionary];
    return _titleShadowOffsets;
}

- (NSMutableDictionary *)backgroundImages
{
    if (_backgroundImages == nil)
        _backgroundImages = [NSMutableDictionary dictionary];
    return _backgroundImages;
}

- (void)setNumberOfDots:(NSInteger)numberOfPoints
{
    if (_numberOfDots == numberOfPoints)
        return;
    _numberOfDots = numberOfPoints;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Attributes section

- (NSString *)titleForState:(UIControlState)state
{
    NSString * title = [self.titles objectForKey:[NSNumber numberWithInt:state]];
    if (title == nil)
        title = [self.titles objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
    return title;
}

- (UIColor *)titleColorForState:(UIControlState)state
{
    UIColor * titleColor = [self.titleColors objectForKey:[NSNumber numberWithInt:state]];
    if (titleColor == nil)
        titleColor = [self.titleColors objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
    return titleColor;
}

- (UIColor *)titleShadowColorForState:(UIControlState)state
{
    UIColor * titleShadowColor = [self.titleShadowColors objectForKey:[NSNumber numberWithInt:state]];
    if (titleShadowColor == nil)
        titleShadowColor = [self.titleShadowColors objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
    return titleShadowColor;
}

- (CGSize)titleShadowOffsetForState:(UIControlState)state
{
    NSValue * titleShadowOffset = [self.titleShadowOffsets objectForKey:[NSNumber numberWithInt:state]];
    if (titleShadowOffset == nil)
        titleShadowOffset = [self.titleShadowOffsets objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
    return [titleShadowOffset CGSizeValue];
}

- (UIImage *)backgroundImageForState:(UIControlState)state
{
    UIImage * backgroundImage = [self.backgroundImages objectForKey:[NSNumber numberWithInt:state]];
    if (backgroundImage == nil)
        backgroundImage = [self.backgroundImages objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
    return backgroundImage;
}

////////////////////////////////////////////////////////////////

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (!title) return;
    [self.titles setObject:title forKey:[NSNumber numberWithInt:state]];
    [self setNeedsDisplay];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    if (!color) return;
    [self.titleColors setObject:color forKey:[NSNumber numberWithInt:state]];
    if (self.state == state)
        [self setNeedsDisplay];
}

- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state
{
    if (!color) return;
    [self.titleShadowColors setObject:color forKey:[NSNumber numberWithInt:state]];
    if (self.state == state)
        [self setNeedsDisplay];
}

- (void)setTitleShadowOffset:(CGSize)size forState:(UIControlState)state
{
    [self.titleShadowOffsets setObject:[NSValue valueWithCGSize:size] forKey:[NSNumber numberWithInt:state]];
    if (self.state == state)
        [self setNeedsDisplay];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    if (!image) return;
    [self.backgroundImages setObject:image forKey:[NSNumber numberWithInt:state]];
    if (self.state == state)
        [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Inner implementation

- (void)drawRect:(CGRect)rect
{
    NSString * titleText = [self titleForState:self.state];
    UIColor * titleColor = [self titleColorForState:self.state];
    UIColor * titleShadowColor = [self titleShadowColorForState:self.state];
    CGSize titleShadowOffset = [self titleShadowOffsetForState:self.state];
    //UIImage * backgroundImage = [self backgroundImageForState:self.state];
    //UIEdgeInsets capInsects = [self backgroundImageCapInsetsForState:self.state];
    NSString * dotsText = [@"" stringByPaddingToLength:self.numberOfDots withString:@"•" startingAtIndex:0];
    
    
    UIFont * titleFont = self.tileTitleFont;
    UIFont * dotsFont = self.tileDotFont;
    
    CGSize titleSize = [titleText sizeWithFont:titleFont];
    CGSize dotsSize = [dotsText sizeWithFont:dotsFont];
    
    CGPoint titlePoint = CGPointMake((self.bounds.size.width - titleSize.width)/2,
                                     (self.bounds.size.height - titleSize.height)/2 -
                                     (self.bounds.size.height*1/8));
    CGPoint dotsPoint = CGPointMake((self.bounds.size.width - dotsSize.width)/2,
                                    self.bounds.size.height*3/5);
    
    CGSize maxTitleSize;
    float circleSize;

    
    NSRegularExpression *regexIsNumber = [NSRegularExpression regularExpressionWithPattern:@"^\\d" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange rangeIsNumber = [regexIsNumber rangeOfFirstMatchInString:titleText options:0 range:NSMakeRange(0, [titleText length])];
    NSRegularExpression *regexIsYear = [NSRegularExpression regularExpressionWithPattern:@"^\\d\\d\\d\\d" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange rangeIsYear = [regexIsYear rangeOfFirstMatchInString:titleText options:0 range:NSMakeRange(0, [titleText length])];
    if ( rangeIsNumber.location == NSNotFound || rangeIsYear.location != NSNotFound ) {
        // didn't find a digit, so this is a Month! OR found a year!
        maxTitleSize.height = titleSize.height + 2;
        maxTitleSize.width = titleSize.width + 2;
        
        // let's re-center the title if we are a year or month
        titlePoint = CGPointMake((self.bounds.size.width - titleSize.width)/2,
                                 (self.bounds.size.height - titleSize.height)/2);
    } else if ( rangeIsNumber.location != NSNotFound && rangeIsYear.location == NSNotFound ) {
        // Found a digit, but didn't match a year, must be a day
        maxTitleSize = [@"30" sizeWithFont:titleFont];
    }
    
    if (maxTitleSize.width >= maxTitleSize.height) {
        circleSize = maxTitleSize.width + 1;
    } else {
        circleSize = maxTitleSize.height + 1;
    }
    
    
    CGRect rectangle;
    
    if ( rangeIsNumber.location == NSNotFound || rangeIsYear.location != NSNotFound ) {
        // didn't find a digit, so this is a Month! OR found a year!
        rectangle = CGRectMake((self.bounds.size.width/2 - circleSize/2),
                               (self.bounds.size.height - titleSize.height - titleSize.height/2)/2,
                               circleSize,
                               circleSize);
    } else if ( rangeIsNumber.location != NSNotFound && rangeIsYear.location == NSNotFound ) {
        // Found a digit, but didn't match a year, must be a day
        rectangle = CGRectMake((self.bounds.size.width/2 - circleSize/2),
                                      (self.bounds.size.height - titleSize.height)/2 - (self.bounds.size.height*1/8),
                                      circleSize,
                                      circleSize);
    }
    

    
    
    if (self.highlighted) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddEllipseInRect(context, rectangle);
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextFillPath(context);

        /* TEST TO SHOW BOUNDS OF CIRCLE FRAME */
//        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//        CGContextAddRect(context, rectangle);
//        CGContextStrokePath(context);
    }

    


    [titleColor set];
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), titleShadowOffset, 0.0, titleShadowColor.CGColor);
    
    [titleText drawAtPoint:titlePoint withFont:titleFont];
    
    if (self.numberOfDots > 0)
        [dotsText drawAtPoint:dotsPoint withFont:dotsFont];
}

- (void)layoutSubviews
{
    NSMutableDictionary * stateSizeImageDict = [[self class] stateSizeImageDict];
    
    NSMutableDictionary * sizeImageDict = [stateSizeImageDict objectForKey:[NSNumber numberWithInt:self.state]];
    if (sizeImageDict == nil)
    {
        sizeImageDict = [NSMutableDictionary dictionary];
        [stateSizeImageDict setObject:sizeImageDict forKey:[NSNumber numberWithInt:self.state]];
    }
    
    UIImage * resizedImage = [sizeImageDict objectForKey:[NSValue valueWithCGSize:self.bounds.size]];
    if (resizedImage == nil)
    {
        UIImage * backgroundImage = [self backgroundImageForState:self.state];
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        [backgroundImage drawInRect:self.bounds];
        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [sizeImageDict setObject:resizedImage forKey:[NSValue valueWithCGSize:self.bounds.size]];
    }
    
//    self.backgroundColor = [UIColor colorWithPatternImage:resizedImage];
    self.backgroundColor = [UIColor clearColor];
    [super layoutSubviews];
}

#pragma mark -
#pragma mark Control properties overloading

- (void)setEnabled:(BOOL)enabled
{
    if (self.enabled == enabled)
        return;
    [super setEnabled:enabled];
    [self layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    if (self.selected == selected)
        return;
    [super setSelected:selected];
    [self layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (self.highlighted == highlighted)
        return;
    [super setHighlighted:highlighted];
//    self.highlighted = true;
    self.backgroundColor = [UIColor clearColor];
    
    [self layoutSubviews];
    [self setNeedsDisplay];
}

@end
