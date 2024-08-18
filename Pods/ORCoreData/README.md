# ORCoreData

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ORCoreData is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ORCoreData"
```

## Example
##### FindEntityTraitProtocol

```swift
extension CDTrack {
    public enum FieldName: String {
        case musicServiceStr
        case idInMusicService
        case id
    }
}

extension CDTrack: FindEntityTraitProtocol {
    public typealias key = CDTrack.FieldName
}
```
## Author

Maxim Soloviev, maxim@omega-r.com

## License

ORCoreData is available under the MIT license. See the LICENSE file for more info.
