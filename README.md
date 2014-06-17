# Selenium.framework

Selenium WebDriver Bindings for Objective-C

To embed in your project take a look at [Appium.app](https://github.com/appium/appium-dot-app) or follow the instructions
[here](http://wiki.remobjects.com/wiki/Linking_Custom_Frameworks_from_your_Xcode_Projects_(Xcode_(Mac))).

## Building

To use this framework, you will need to compile it using Xcode:

1. Clone this repository or download it as a ZIP.
1. Open the `Selenium.xcodeproj` from the `Selenium` directory.
1. Ensure that the `Selenium` framework is chosen as the target (not `libSelenium`).
1. Go to Product > Build For > Running.
1. Retrive the `Selenium.framework` from the `publish` directory.
