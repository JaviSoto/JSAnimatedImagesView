/* 
 
 Copyright 2012 Javier Soto (ios@javisoto.es)
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. 
 */

#import "JSAnimatedImagesView.h"

#define kJSAnimatedImagesViewNoImageDisplayingIndex -1
#define kJSAnimatedImagesViewImageSwappingAnimationDuration 1.0f

#define kJSAnimatedImagesViewImageViewsBorderOffset 10

#ifndef _JSARCEnabled

#define _JSARCEnabled __has_feature(objc_arc)

#if _JSARCEnabled
    #define _JSARCSafeRelease(object)
#else
    #define _JSARCSafeRelease(object) [object release]
#endif

#endif

@interface JSAnimatedImagesView()
{
    BOOL animating;
    NSUInteger totalImages;
    NSUInteger currentlyDisplayingImageViewIndex;
    NSInteger currentlyDisplayingImageIndex;
}

@property (nonatomic, strong) NSArray *imageViews;
@property (unsafe_unretained, nonatomic, readonly) NSTimer *imageSwappingTimer;

- (void)_init;

+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber;
@end

@implementation JSAnimatedImagesView

@synthesize imageViews = _imageViews;
@synthesize imageSwappingTimer = _imageSwappingTimer;

@synthesize delegate = _delegate,
            timePerImage = _timePerImage;

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
    
    const int numberOfImageViews = 2;
    
    for (int i = 0; i < numberOfImageViews; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-kJSAnimatedImagesViewImageViewsBorderOffset, -kJSAnimatedImagesViewImageViewsBorderOffset, self.bounds.size.width + (kJSAnimatedImagesViewImageViewsBorderOffset * 2), self.bounds.size.height + (kJSAnimatedImagesViewImageViewsBorderOffset * 2))];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];

        [imageViews addObject:imageView];
        _JSARCSafeRelease(imageView);
    }
         
    self.imageViews = imageViews;
    
    currentlyDisplayingImageIndex = kJSAnimatedImagesViewNoImageDisplayingIndex;
}

#pragma mark - Animations

- (void)startAnimating
{
    NSAssert(self.delegate != nil, @"You need to set the delegate property");
    
    if (!animating)
    {
        animating = YES;
        [self.imageSwappingTimer fire];
    }
}

- (void)bringNextImage
{
    NSAssert(totalImages > 1, @"There should be more than 1 image to swap");
    
    UIImageView *imageViewToHide = [self.imageViews objectAtIndex:currentlyDisplayingImageViewIndex];
    
    currentlyDisplayingImageViewIndex = currentlyDisplayingImageViewIndex == 0 ? 1 : 0;
    
    UIImageView *imageViewToShow = [self.imageViews objectAtIndex:currentlyDisplayingImageViewIndex];

    NSUInteger nextImageToShowIndex = currentlyDisplayingImageIndex;
    
    do
    {
        nextImageToShowIndex = [[self class] randomIntBetweenNumber:0 andNumber:totalImages - 1];
    }
    while (nextImageToShowIndex == currentlyDisplayingImageIndex);
    
    currentlyDisplayingImageIndex = nextImageToShowIndex;

    imageViewToShow.image = [self.delegate animatedImagesView:self imageAtIndex:nextImageToShowIndex];
    
    static const CGFloat kMovementAndTransitionTimeOffset = 0.1;
    
    /* Move image animation */
    [UIView animateWithDuration:self.timePerImage + kJSAnimatedImagesViewImageSwappingAnimationDuration + kMovementAndTransitionTimeOffset delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn animations:^{
        NSInteger randomTranslationValueX = [[self class] randomIntBetweenNumber:0 andNumber:kJSAnimatedImagesViewImageViewsBorderOffset] - kJSAnimatedImagesViewImageViewsBorderOffset;
        NSInteger randomTranslationValueY = [[self class] randomIntBetweenNumber:0 andNumber:kJSAnimatedImagesViewImageViewsBorderOffset] - kJSAnimatedImagesViewImageViewsBorderOffset;
        
        CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(randomTranslationValueX, randomTranslationValueY);
        
        CGFloat randomScaleTransformValue = [[self class] randomIntBetweenNumber:115 andNumber:120]/100;
        
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(randomScaleTransformValue, randomScaleTransformValue);

        imageViewToShow.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
    } completion:NULL];
    
    /* Fade animation */
    [UIView animateWithDuration:kJSAnimatedImagesViewImageSwappingAnimationDuration delay:kMovementAndTransitionTimeOffset options:UIViewAnimationOptionBeginFromCurrentState 
     | UIViewAnimationCurveEaseIn animations:^{
        imageViewToShow.alpha = 1.0;        
        imageViewToHide.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            imageViewToHide.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)reloadData
{
    totalImages = [self.delegate animatedImagesNumberOfImages:self];
    
    [self.imageSwappingTimer fire];
}

- (void)stopAnimating
{
    if (animating)
    {       
        [_imageSwappingTimer invalidate];
        _imageSwappingTimer = nil;
        
        // Fade all image views out
        [UIView animateWithDuration:kJSAnimatedImagesViewImageSwappingAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            for (UIImageView *imageView in self.imageViews)
            {
                imageView.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            currentlyDisplayingImageIndex = kJSAnimatedImagesViewNoImageDisplayingIndex;
            animating = NO;
        }];
    }
}

#pragma mark - Parameters

- (NSTimeInterval)timePerImage
{
    if (_timePerImage == 0)
    {
        return kJSAnimatedImagesViewDefaultTimePerImage;
    }
    
    return _timePerImage;
}

- (void)setDelegate:(id<JSAnimatedImagesViewDelegate>)delegate
{
    if (delegate != _delegate)
    {
        _delegate = delegate;
        totalImages = [_delegate animatedImagesNumberOfImages:self];
    }
}

#pragma mark - Getters

- (NSTimer *)imageSwappingTimer
{
    if (!_imageSwappingTimer)
    {
        _imageSwappingTimer = [NSTimer scheduledTimerWithTimeInterval:self.timePerImage target:self selector:@selector(bringNextImage) userInfo:nil repeats:YES];
    }
    
    return _imageSwappingTimer;
}

#pragma mark - Aux

+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber
{
    if (minNumber > maxNumber) {
        return [self randomIntBetweenNumber:maxNumber andNumber:minNumber];
    }
    
    NSUInteger i = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
    
    return i;
}

#pragma mark - Memory Management

- (void)dealloc
{
    #if !_JSARCEnabled
    [_imageViews release];
    #endif
    [_imageSwappingTimer invalidate];
    
    #if !_JSARCEnabled
    [super dealloc];
    #endif
}

@end
