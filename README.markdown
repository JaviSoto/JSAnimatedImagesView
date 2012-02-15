#Description:
Easy to use UIView subclass to quickly add a cool animated carrusel of pictures to your app.

#Sample:

![Video](http://cl.ly/1x0P2o2I053L1W2B2h3J/Screen%20Shot%202012-02-15%20at%202.33.09%20PM.png)

http://jsoto.es/xmKcLb

#Usage:
(refer to the sample project)

```objectivec
/* .h file: */
#import "JSAnimatedImagesView.h"
@interface MyViewController <JSAnimatedImagesViewDelegate> // Conform to the protocol
.....

/* .m file: */
...

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.animatedImagesView startAnimating];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

	[self.animatedImagesView stopAnimating];
}

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
{
	return self.myImageNames.count;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
	return [UIImage imageNamed:[self.myImageNames objectAtIndex:index]];
}
...
```

#Attributions (Creative Commons Images)
+ http://www.flickr.com/photos/blmiers2/
+ http://www.flickr.com/photos/niamor/
+ http://www.flickr.com/photos/macieklew/
+ 

#License
Copyright 2012 Javier Soto (ios@javisoto.es)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.