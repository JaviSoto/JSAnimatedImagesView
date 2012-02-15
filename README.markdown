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