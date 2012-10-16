## Description:
Easy to use UIView subclass to quickly add a cool animated carrusel of pictures to your app.

## Sample:

![Video](http://cl.ly/1x0P2o2I053L1W2B2h3J/Screen%20Shot%202012-02-15%20at%202.33.09%20PM.png)

http://jsoto.es/xmKcLb

## Usage

- Clone the repository:

```bash
$ git clone git@github.com:JaviSoto/JSAnimatedImagesView.git
```

- Check out the sample project.
- Drag the two files ```JSAnimatedImagesView.(h/m)``` onto your project.
- Include the header file ````JSAnimatedImagesView.h``` into the controller where you want to use it.
- Create a ```JSAnimatedImagesView``` instance either via code, or in interface builder (by creating a UIView and changing its class to ```JSAnimatedImagesView```).
- Set the data source property on the view (probably on the ```viewDidLoad``` method):

```objc
self.animatedImagesView.dataSource = self;
```

- Implement the data source methods:

```objectivec

@interface MyViewController () <JSAnimatedImagesViewDataSource> // Conform to the protocol

@end

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
Copyright 2012 Javier Soto (ios@javisoto.es)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

Attribution is not required but appreciated.