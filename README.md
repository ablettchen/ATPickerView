# ATPickerView

[![CI Status](https://img.shields.io/travis/ablettchen@gmail.com/ATPickerView.svg?style=flat)](https://travis-ci.org/ablettchen@gmail.com/ATPickerView)
[![Version](https://img.shields.io/cocoapods/v/ATPickerView.svg?style=flat)](https://cocoapods.org/pods/ATPickerView)
[![License](https://img.shields.io/cocoapods/l/ATPickerView.svg?style=flat)](https://cocoapods.org/pods/ATPickerView)
[![Platform](https://img.shields.io/cocoapods/p/ATPickerView.svg?style=flat)](https://cocoapods.org/pods/ATPickerView)

## Example

![](https://github.com/ablettchen/ATPickerView/blob/master/Example/images/picker.gif)
To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objectiveC
#import <ATPickerView/ATPickerView.h>
```

* Picker - Default

```objectiveC
NSArray *items = @[@"语法课", @"自然拼读", @"阅读练习"];
ATPickerView *view = \
ATPickerView.build.withTitle(title).withItems(items).showInWindow();
view.confirmBlock = ^(NSInteger index) {
    NSLog(@"selected:%@", items[index]);
};
```

## Requirements

## Installation

ATPickerView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATPickerView'
```

## Author

ablettchen@gmail.com, ablett.chen@gmail.com

## License

ATPickerView is available under the MIT license. See the LICENSE file for more info.
