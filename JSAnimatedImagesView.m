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
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-kJSAnimatedImagesViewImageViewsBorderOffset,
                                                                               -kJSAnimatedImagesViewImageViewsBorderOffset,
                                                                               self.bounds.size.width + (kJSAnimatedImagesViewImageViewsBorderOffset * 2),
                                                                               self.bounds.size.height + (kJSAnimatedImagesViewImageViewsBorderOffset * 2))];

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
        [_imageSwappingTimer invalidate];
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

#pragma mark - Aux

+ (NSUInteger)randomIntBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber
{
    if (minNumber > maxNumber) {
        return [self randomIntBetweenNumber:maxNumber andNumber:minNumber];
    }
    
    NSUInteger i = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
    
    return i;
}

@end
