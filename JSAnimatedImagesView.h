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

#import <UIKit/UIKit.h>

#define kJSAnimatedImagesViewDefaultTimePerImage 5.0f
#define kJSAnimatedImagesViewDefaultImageSwappingAnimationDuration 1.0f

@protocol JSAnimatedImagesViewDataSource;

@interface JSAnimatedImagesView : UIView

@property (nonatomic, weak) id<JSAnimatedImagesViewDataSource> dataSource;

/**
 * @default kJSAnimatedImagesViewDefaultTimePerImage
 */
@property (nonatomic, assign) NSTimeInterval timePerImage;

/**
 * @default kJSAnimatedImagesViewDefaultImageSwappingAnimationDuration
 */
@property (nonatomic, assign) NSTimeInterval transitionDuration;

/**
 * @discussion the view starts animating automatically when it becomes visible, but you can use this method to start the animations again if you 
 * stop them using the `-stopAnimating`.
 */
- (void)startAnimating;

/**
 * @discussion the view automatically stops animating when it goes out of the screen, but you can choose to stop it manually using this method.
 */
- (void)stopAnimating;

/**
 * @discussion forces `JSAnimatedImagesView` to call the data source methods again.
 * Use if you change the number of images.
 */
- (void)reloadData;

@end

@protocol JSAnimatedImagesViewDataSource

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView;
- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index;

@end
