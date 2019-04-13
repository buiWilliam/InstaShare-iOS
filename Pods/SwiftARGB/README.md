# SwiftARGB

[![CI Status](http://img.shields.io/travis/DragonCherry/SwiftARGB.svg?style=flat)](https://travis-ci.org/DragonCherry/SwiftARGB)
[![Version](https://img.shields.io/cocoapods/v/SwiftARGB.svg?style=flat)](http://cocoapods.org/pods/SwiftARGB)
[![License](https://img.shields.io/cocoapods/l/SwiftARGB.svg?style=flat)](http://cocoapods.org/pods/SwiftARGB)
[![Platform](https://img.shields.io/cocoapods/p/SwiftARGB.svg?style=flat)](http://cocoapods.org/pods/SwiftARGB)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```

let whiteColor = UIColor(rgbHex: 0xFFFFFF)

let whiteColor = UIColor(argbHex: 0xFFFFFFFF)

let whiteColor = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)

let whiteColor = UIColor(alpha: 0xFF, red: 0xFF, green: 0xFF, blue: 0xFF)

let rgbString = whiteColor.RGBString    // "FFFFFF"

let argbString = whiteColor.ARGBString  // "FFFFFFFF"

```

## Requirements

## Installation

SwiftARGB is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftARGB"
```

## Author

DragonCherry, dragoncherry@naver.com

## License

SwiftARGB is available under the MIT license. See the LICENSE file for more info.
