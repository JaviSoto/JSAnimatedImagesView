## Description:
Easy to use UIView subclass to quickly add a cool animated carrousel of pictures to your app.

Documentation: http://cocoadocs.org/docsets/JSAnimatedImagesView/

## Sample:

![Video](http://cl.ly/1x0P2o2I053L1W2B2h3J/Screen%20Shot%202012-02-15%20at%202.33.09%20PM.png)

http://jsoto.es/xmKcLb

## Usage

- Using [CocoaPods](http://cocoapods.org/):
- Add `pod 'JSAnimatedImagesView', '~> 1.0.'` to your `Podfile`.
- You're done!

-- or --

- Clone the repository:

```bash
$ git clone git@github.com:JaviSoto/JSAnimatedImagesView.git
```

- Update the submodules:

```bash
$ git submodule update --init
```

- Check out the sample project.
- Drag the two files ```JSAnimatedImagesView.(h/m)``` onto your project.
- Drag `Dependencies/MSWeakTimer/MSWeakTimer.(h/m)` onto your project.
- Include the header file ```JSAnimatedImagesView.h``` into the controller where you want to use it.
- Create a ```JSAnimatedImagesView``` instance either via code, or in interface builder (by creating a UIView and changing its class to ```JSAnimatedImagesView```).
- Set the data source property on the view (probably on the ```viewDidLoad``` method):

```objc
self.animatedImagesView.dataSource = self;
```

- Implement the data source methods:

```objectivec

@interface MyViewController () <JSAnimatedImagesViewDataSource> // Conform to the protocol

@end
```

```objc
@implementation MyViewController

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
{
	return self.myImageNames.count;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
	return [UIImage imageNamed:[self.myImageNames objectAtIndex:index]];
}

@end
```

## Configuration

```objc
@property (nonatomic, assign) NSTimeInterval timePerImage;
```

Specifies the time each image is viewed until the next image is faded in.

```objc
@property (nonatomic, assign) NSTimeInterval transitionDuration;
```

Specifies the duration of the transition (fade-out/fade-in) animation.


## Compatibility
- ```JSAnimatedImagesView``` is compatible with iOS5.0+
- ```JSAnimatedImagesView``` requires ARC.

## Attributions (Creative Commons Images)
+ http://www.flickr.com/photos/blmiers2/
+ http://www.flickr.com/photos/niamor/
+ http://www.flickr.com/photos/macieklew/

## License
`JSAnimatedImagesView` is available under the MIT license. See the LICENSE file for more info.
