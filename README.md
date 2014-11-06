SwiftWeather
============

SwiftWeather is an iOS app developed in Swift language. The app can support iPhone 4(s), iPhone 5(s), iPhone 6 and iPhone 6 Plus.

## Screenshots
![Loading](https://github.com/drpanghaobin/project1/blob/master/screenshots/4s-fullsize.png)





#### iPhone 4s
#

#### iPhone 5s
![Swift Weather](https://github.com/drpanghaobin/project1/blob/master/screenshots/5s-fullsize.png)


#### iPhone 6
![Swift Weather](https://github.com/drpanghaobin/project1/blob/master/screenshots/6-fullsize.png)


#### iPhone 6 Plus
![Swift Weather](https://github.com/drpanghaobin/project1/blob/master/screenshots/6plus-fullsize.png)

## Notices
Because Apple keeps changing the Swift compiler, the current version can be compiled in Xcode 6 GM. I will update the code when Apple updates Xcode 6.
 
## Used features
* Swift Programming Language
* CocoaPods
* AFNetworking
* Core Location


## How to build
Because the app uses CocoaPods, we need to run `pod install` to install all the pods.

1. Open Terminal app.
2. Change directory to the project folder. `cd $project_dir`
3. Use `ls` to list all the file to check whether *Podfile* file is in the folder? 
4. If the *Podfile* has been found, then execute `pod install`
5. If the Mac OS doesn't have CocoaPods installed. Please follow [CocoaPods Getting Started](http://guides.cocoapods.org/using/getting-started.html) to install.
6. Once complete installation, open *Swift Weather.xcworkspace* file with Xcode 6.
7. Press *Cmd + B* to build the app.
8. Press *Cmd + R* to run the app on Simulator.

## Credits
* Thanks to [johnsonjake](https://github.com/johnsonjake) for adding iOS 8 support and improving the UI/UX.
