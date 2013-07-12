/*
 Copyright (c) 2012 JaviSoto (http://www.javisoto.me)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "JSAnimatedImagesView.h"

#if !__has_feature(objc_arc)
    #error JSAnimatedImagesView requires ARC enabled. Mark the .m file with the `objc_arc` linker flag.
#endif

#define kJSAnimatedImagesViewNoImageDisplayingIndex -1

#define kJSAnimatedImagesViewImageViewsBorderOffset 10

@interface JSAnimatedImagesView()
{
    BOOL _animating;
    NSUInteger _totalImages;
    NSUInteger _currentlyDisplayingImageViewIndex;
    NSInteger _currentlyDisplayingImageIndex;
}

@property (nonatomic, strong) NSArray *imageViews;
@property (nonatomic, weak, readonly) NSTimer *imageSwappingTimer;

- (void)_init;

+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber;

@end

@implementation JSAnimatedImagesView

@synthesize imageSwappingTimer = _imageSwappingTimer;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self _init];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self _init];
    }
    
    return self;
}

- (void)_init
{
    NSMutableArray *imageViews = [NSMutableArray array];
    
    const NSUInteger numberOfImageViews = 2;
    
    for (int i = 0; i < numberOfImageViews; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, -kJSAnimatedImagesViewImageViewsBorderOffset, -kJSAnimatedImagesViewImageViewsBorderOffset)];

        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;

        [self addSubview:imageView];

        [imageViews addObject:imageView];
    }
         
    self.imageViews = imageViews;
    
    _currentlyDisplayingImageIndex = kJSAnimatedImagesViewNoImageDisplayingIndex;
    _timePerImage = kJSAnimatedImagesViewDefaultTimePerImage;
    _transitionDuration = kJSAnimatedImagesViewDefaultImageSwappingAnimationDuration;
}

#pragma mark - Animations

- (void)startAnimating
{
    NSAssert(self.dataSource != nil, @"You need to set the data source property");
    
    if (!_animating)
    {
        _animating = YES;
        [self.imageSwappingTimer fire];
    }
}

- (void)bringNextImage
{
    NSAssert(_totalImages > 1, @"There should be more than 1 image to swap");
    
    UIImageView *imageViewToHide = [self.imageViews objectAtIndex:_currentlyDisplayingImageViewIndex];
    
    _currentlyDisplayingImageViewIndex = _currentlyDisplayingImageViewIndex == 0 ? 1 : 0;
    
    UIImageView *imageViewToShow = [self.imageViews objectAtIndex:_currentlyDisplayingImageViewIndex];

    NSUInteger nextImageToShowIndex = _currentlyDisplayingImageIndex;
    
    do
    {
        nextImageToShowIndex = [[self class] randomIntBetweenNumber:0 andNumber:_totalImages - 1];
    }
    while (nextImageToShowIndex == _currentlyDisplayingImageIndex);
    
    _currentlyDisplayingImageIndex = nextImageToShowIndex;

    imageViewToShow.image = [self.dataSource animatedImagesView:self imageAtIndex:nextImageToShowIndex];
    
    static const CGFloat kMovementAndTransitionTimeOffset = 0.1;
    
    /* Move image animation */
    [UIView animateWithDuration:self.timePerImage + self.transitionDuration + kMovementAndTransitionTimeOffset
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn
                     animations:^
     {
         NSInteger randomTranslationValueX = [[self class] randomIntBetweenNumber:0 andNumber:kJSAnimatedImagesViewImageViewsBorderOffset] - kJSAnimatedImagesViewImageViewsBorderOffset;
         NSInteger randomTranslationValueY = [[self class] randomIntBetweenNumber:0 andNumber:kJSAnimatedImagesViewImageViewsBorderOffset] - kJSAnimatedImagesViewImageViewsBorderOffset;
         
         CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(randomTranslationValueX, randomTranslationValueY);
         
         CGFloat randomScaleTransformValue = [[self class] randomIntBetweenNumber:115 andNumber:120]/100;
         
         CGAffineTransform scaleTransform = CGAffineTransformMakeScale(randomScaleTransformValue, randomScaleTransformValue);
         
         imageViewToShow.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
     }
                     completion:NULL];
    
    /* Fade animation */
    [UIView animateWithDuration:self.transitionDuration
                          delay:kMovementAndTransitionTimeOffset
                        options:UIViewAnimationOptionBeginFromCurrentState
     | UIViewAnimationCurveEaseIn
                     animations:^
     {
         imageViewToShow.alpha = 1.0;
         imageViewToHide.alpha = 0.0;
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             imageViewToHide.transform = CGAffineTransformIdentity;
         }
     }];
}

- (void)reloadData
{
    _totalImages = [self.dataSource animatedImagesNumberOfImages:self];
    
    [self.imageSwappingTimer fire];
}

- (void)stopAnimating
{
    if (_animating)
    {
        _imageSwappingTimer = nil;
        
        // Fade all image views out
        [UIView animateWithDuration:self.transitionDuration
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^
         {
             for (UIImageView *imageView in self.imageViews)
             {
                 imageView.alpha = 0.0;
             }
         }
                         completion:^(BOOL finished)
         {
             _currentlyDisplayingImageIndex = kJSAnimatedImagesViewNoImageDisplayingIndex;
             _animating = NO;
         }];
    }
}

#pragma mark - Parameters

- (void)setDataSource:(id<JSAnimatedImagesViewDataSource>)dataSource
{
    if (dataSource != _dataSource)
    {
        _dataSource = dataSource;
        _totalImages = [_dataSource animatedImagesNumberOfImages:self];
    }
}

#pragma mark - Getters

- (NSTimer *)imageSwappingTimer
{
    if (!_imageSwappingTimer)
    {
        _imageSwappingTimer = [NSTimer scheduledTimerWithTimeInterval:self.timePerImage
                                                               target:self
                                                             selector:@selector(bringNextImage)
                                                             userInfo:nil
                                                              repeats:YES];
    }
    
    return _imageSwappingTimer;
}

- (void)setImageSwappingTimer:(NSTimer *)imageSwappingTimer
{
    if (imageSwappingTimer != _imageSwappingTimer)
    {
        [_imageSwappingTimer invalidate];

        _imageSwappingTimer = imageSwappingTimer;
    }
}

#pragma mark - View Life Cycle

- (void)didMoveToWindow
{
    const BOOL didAppear = (self.window != nil);

    if (didAppear)
    {
        [self startAnimating];
    }
    else
    {
        [self stopAnimating];
    }
}

#pragma mark - Random Numbers

+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber
{
    if (minNumber > maxNumber) {
        return [self randomIntBetweenNumber:maxNumber andNumber:minNumber];
    }
    
    NSUInteger i = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
    
    return i;
}

@end
