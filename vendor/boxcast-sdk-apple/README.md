# BoxCast SDK for Apple Platforms

![Travis Status Image](https://travis-ci.org/boxcast/boxcast-sdk-apple.svg?branch=master)

The official BoxCast SDK for integrating with the BoxCast API on Apple platforms.

## Features

- List Live and Archived Broadcasts
- Detail A Broadcast
- Watch Broadcasts
- Documentation

## Requirements

- iOS 9.0+ | macOS 10.12+ | tvOS 9.0+
- Xcode 11.0+
- Swift 5.0+

## Installation

### Cocoapods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate BoxCast SDK into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
platform :ios, '13.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BoxCast', '~> 0.5'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

1. Install Carthage with [Homebrew](http://brew.sh/) using the following command:

	```bash
	$ brew update
	$ brew install carthage
	```

2. Edit your `Cartfile` to integrate BoxCast into your Xcode project:

	```ogdl
	github "boxcast/boxcast-sdk-apple" ~> 0.5
	```

3. Run `carthage update`. This will fetch BoxCast into a `Carthage/Checkouts` folder and build the framework.

4. On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop `BoxCast.framework` from the `Carthage/Build` folder.

5. On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script in which you specify your shell (ex: /bin/sh), add the following contents to the script area below the shell:

	```
	/usr/local/bin/carthage copy-frameworks
	```

	and add the paths to the frameworks you want to use under “Input Files”, e.g.:

	```
	$(SRCROOT)/Carthage/Build/iOS/BoxCast.framework
	```

## Usage

Before you get started make sure to grab the id of the channel you want to get broadcasts from. This can be found on your [BoxCast Dashboard](https://dashboard.boxcast.com/#/channels).

### Set Up

In your AppDelegate you will want to make sure you call the `setUp` function on the `BoxCastClient`. This will in turn create the `sharedClient` for you to use.

```swift
import BoxCast

application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    BoxCastClient.setUp()

    return true
}
```

### Accessing Resources

#### Get Live Broadcasts

```swift
import BoxCast

BoxCastClient.sharedClient?.getLiveBroadcasts(channelId: "YOUR_CHANNEL_ID") { broadcasts, error in
    if let broadcasts = broadcasts {
        // Do something special with the live broadcasts.
    } else {
        // Handle the error.
    }
}
```

#### Get Archived Broadcasts

```swift
import BoxCast

BoxCastClient.sharedClient?.getArchivedBroadcasts(channelId: "YOUR_CHANNEL_ID") { broadcasts, error in
    if let broadcasts = broadcasts {
        // Do something special with the archived broadcasts.
    } else {
        // Handle the error.
    }
}
```

#### Get Broadcast

```swift
import BoxCast

BoxCastClient.sharedClient?.getBroadcast(broadcastId: "BROADCAST_ID") { broadcast, error in
    if let broadcast = broadcast {
        // Do something special with the broadcast.
    } else {
        // Handle the error.
    }
}
```

#### Get Broadcast View

```swift
import BoxCast

BoxCastClient.sharedClient?.getBroadcastView(broadcastId: "BROADCAST_ID") { broadcastView, error in
    if let broadcastView = broadcastView {
        // Do something special with the broadcast view.
    } else {
        // Handle error.
    }
}
```

### Playback

After getting a detailed broadcast and broadcast view you can use the two resources to create an `BoxCastPlayer` object. This object is a simple sublcass of `AVPlayer` and can be used in a similar fashion.

Below is an example of creating the player and then presenting a `AVPlayerViewController` instance with the player.

```swift
import BoxCast

let player = BoxCastPlayer(broadcast: broadcast, broadcastView: broadcastView)
let controller = AVPlayerViewController()
controller.player = player
present(controller, animated: true) {
    player?.play()
}
```

## Demo

There is a demo app included with this project to help you get a feel for how this SDK can be used. Just open up the `BoxCast.xcodeproj` select the `Demo` scheme and run it.

> Carthage must be installed on your machine or the project won't build.

## Documentation

Documentation can be found [here](https://boxcast.github.io/boxcast-sdk-apple/).

## License

BoxCast SDK is released under the MIT license. [See LICENSE](https://github.com/boxcast/boxcast-sdk-apple/blob/master/LICENSE) for details.
