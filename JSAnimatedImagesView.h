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

#import <UIKit/UIKit.h>

#define kJSAnimatedImagesViewDefaultTimePerImage 5.0f

@protocol JSAnimatedImagesViewDelegate;

@interface JSAnimatedImagesView : UIView

@property (nonatomic, unsafe_unretained) id<JSAnimatedImagesViewDelegate> delegate;

/**
 * @default kJSAnimatedImagesViewDefaultTimePerImage
 */
@property (nonatomic, unsafe_unretained) NSTimeInterval timePerImage;

/**
 * @discussion call this before the user can see the `JSAnimatedImagesView` (e.g. -viewWillAppear:) so that it's already animating when it starts being visible.
 */
- (void)startAnimating;

/**
 * @discussion You should call stopAnimating at least when the controller that creates the `JSAnimatedImagesView` ceases to exist to prevent it to animate forever.
 */
- (void)stopAnimating;

/**
 * @discussion forces `JSAnimatedImagesView` to call the delegate methods again.
 */
- (void)reloadData;

@end

@protocol JSAnimatedImagesViewDelegate

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView;
- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index;

@end
