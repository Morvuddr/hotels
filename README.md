# Hotels
> Project is an iOS app

The application downloads a JSON document with information about several hotels from the server, parses it and displays the data of these hotels.

Hotels can be sorted by one of two parameters: by the distance of the hotel from the city center or by the number of available rooms.

There is the separate screen for viewing detailed information about the hotel and the screen with the hotel location on the map.

| Main screen | Sorting control  | Info screen  | Map screen  |
| ------------ | ------------ | ------------ | ------------ |
|![main](/Screenshots/main.PNG)  | ![sorting](/Screenshots/sorting.PNG)  | ![info](/Screenshots/info.PNG)  | ![map](/Screenshots/map.PNG)   |


## Features
- Swift 5.2
- Designed with basic UI controls according to Apple Design Guidelines
- Support all iPhone screen sizes
- MVVM architecture pattern
- Reactive programming with RxSwift 
- Store local data with Realm 
- Swinject for dependency injection

### Pods used
- pod 'RxSwift'
- pod 'RxCocoa'
- pod 'RxRealm'
- pod 'Swinject'

Pods directory under source control

## Requirements
- iOS 11.0+
- Xcode 9.3+

