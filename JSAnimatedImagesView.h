//
//  JSAnimatedImagesView.h
//
//  Created by Javier Soto on 2/13/12.
//

#import <UIKit/UIKit.h>

#define kJSAnimatedImagesViewDefaultTimePerImage 5.0f

@protocol JSAnimatedImagesViewDelegate;

@interface JSAnimatedImagesView : UIView

@property (nonatomic, assign) id<JSAnimatedImagesViewDelegate> delegate;

/* Default if not set is kJSAnimatedImagesViewDefaultTimePerImage */
@property (nonatomic, assign) NSTimeInterval timePerImage;

- (void)startAnimating;
- (void)stopAnimating;

- (void)reloadData;

@end

@protocol JSAnimatedImagesViewDelegate
- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView;
- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index;
@end
