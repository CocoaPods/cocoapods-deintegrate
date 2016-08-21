NSAttributedString+CCLFormat
============================

[![Build Status](https://travis-ci.org/cocodelabs/NSAttributedString-CCLFormat.png?branch=master)](https://travis-ci.org/cocodelabs/NSAttributedString-CCLFormat)
[![Coverage Status](https://img.shields.io/coveralls/cocodelabs/NSAttributedString-CCLFormat.svg)](https://coveralls.io/r/cocodelabs/NSAttributedString-CCLFormat)

An extension to NSAttributedString for creating attributed strings by using a
given format string as a template into which the remaining argument values are
substituted. This is helpful for using in conjunction with internationalisation.

```objective-c
@interface NSAttributedString (CCLFormat)

+ (NSAttributedString *)attributedStringWithFormat:(NSString *)format, ...;

@end
```

## Usage

```objective-c
NSAttributedString *blue, *green, *never, *result;

blue = [[NSAttributedString alloc] initWithString:@"Blue" attributes:@{
    NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
    NSForegroundColorAttributeName: [UIColor blueColor],
}];

green = [[NSAttributedString alloc] initWithString:@"Green" attributes:@{
    NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
    NSForegroundColorAttributeName: [UIColor greenColor],
}];

never = [[NSAttributedString alloc] initWithString:@"never" attributes:@{
    NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
}];

result = [NSAttributedString attributedStringWithFormat:@"%@ and %@ must %@ be seen", blue, green, never];
```

## Installation

[CocoaPods](http://cocoapods.org) is the recommended way to add
NSAttributedString+CCLFormat to your project.

Here's an example podfile that installs NSAttributedString+CCLFormat.

### Podfile

```ruby
pod 'NSAttributedString+CCLFormat'
```

## License

NSAttributedString+CCLFormat is released under the BSD license. See [LICENSE](LICENSE).

