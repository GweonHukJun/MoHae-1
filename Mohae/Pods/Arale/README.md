[![License](https://img.shields.io/cocoapods/l/Arale.svg?style=flat)](http://cocoapods.org/pods/Arale)
[![Platform](https://img.shields.io/cocoapods/p/Arale.svg?style=flat)](http://cocoapods.org/pods/Arale)
[![Version](https://img.shields.io/cocoapods/v/Arale.svg?style=flat)](http://cocoapods.org/pods/Arale)

# Arale
A custom stretchy big head for UITableView, UICollectionView, or any UIScrollView subclasses.

# Demo
![Example 1](https://media.giphy.com/media/1qbl6sAB2EJh0fi9p7/giphy.gif)

# Arale, by [ZulwiyozaPutra](https://twitter.com/ZulwiyozaPutra)

- Compatible with `UITableView`, `UICollectionView`, or any `UIScrollView` subclasses.
- Data source and delegate independency: can be added to an existing view controller without interfering with your existing `delegate` or `dataSource`.
- No need to subclass a custom view controller or to use a custom `UICollectionViewLayout`.


If you are using this library in your project, I would be more than glad to [know about it!](mailto:zulwiyozaputra@gmail.com)

## Usage

To add a stretchy header to your table or collection view, you just have to do this:

```swift

import Arale

var araleHeaderView: AraleHeaderView!

...

let araleHeaderView = AraleHeaderView(minHeight: 256.0, backgroundImage: myBackgroundImage)
araleHeaderView.delegate = self
self.tableView.addSubview(self.araleHeaderView)
...

// In case you want to add an UIActivityIndicatorView
// To handle action if the AraleHeaderView has resize to maxHeight you can implement a AraleHeaderViewDelegate conformed UIViewController

araleHeaderView.delegate = self

...

// And implement headerViewDidReachMaxHeight to get event when the araleHeaderView did reach the maximum height

func headerViewDidReachMaxHeight(headerView: AraleHeaderView) {
    NSLog("%@", "Start Refreshing")
    headerView.activityIndicatorView.stopAnimating()
}
...
// AraleHeaderViewDelegate comes with three optional delegate method
func headerViewWillResizeFrame(headerView: AraleHeaderView)
func headerViewDidResizeFrame(headerView: AraleHeaderView)
func headerViewDidReachMaxHeight(headerView: AraleHeaderView)
...
 

```

## Configuration

You can add an optional `UIViewActivityIndicatorView` in your stretchy header view:
```
let myActivityIndicatorview = UIActivityIndicatorView(style: .white)
self.araleHeadeView.activityIndicatorView = myActivityIndicatorView
```

the `activityIndicatorView` will not be rendered if remain `nil` in case you don't need an activityIndicator.



## Installation

Arale is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile, you can check the Example Podfile to see how it looks like:

```ruby
pod "Arale"
```

## Author

[Zulwiyoza Putra](https://twitter.com/zulwiyozaputra)

## Contributions

Contributions are more than welcome! If you find a solution for a bug or have an improvement, don't hesitate to [open a pull request](https://github.com/ZulwiyozaPutra/Arale/compare)!

## License

`Arale` is available under the MIT license. See the LICENSE file for more info.

If your app uses `Arale`, I'd be glad if you reach me via [Twitter](https://twitter.com/zulwiyozaputra) or via email.
