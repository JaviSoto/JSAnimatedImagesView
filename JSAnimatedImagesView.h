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
