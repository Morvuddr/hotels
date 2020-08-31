# Hotels
> Project is an iOS app

The application downloads a JSON document with information about several hotels from the server, parses it and displays the data of these hotels.

Hotels can be sorted by one of two parameters: by the distance of the hotel from the city center or by the number of available rooms.

There is the separate screen for viewing detailed information about the hotel and the screen with the hotel location on the map.

| Main screen | Sorting control  | Info screen  | Map screen  |
| ------------ | ------------ | ------------ | ------------ |
|![main](/Screenshots/main.PNG)  | ![sorting](/Screenshots/sorting.PNG)  | ![info](/Screenshots/info.PNG)  | ![map](/Screenshots/map.PNG)   |


## Features
- [x] Swift 5.2
- [x] Designed with basic UI controls according to Apple Design Guidelines
- [x] Support all iPhone screen sizes
- [x] MVVM architecture pattern
- [x] Reactive programming with RxSwift 
- [x] Store local data with Realm 
- [x] Swinject for dependency injection
- [ ] Unit-tests
- [ ] UI tests

### Pods used
- pod 'RxSwift'
- pod 'RxCocoa'
- pod 'RxRealm'
- pod 'Swinject'

Pods directory under source control

## Requirements
- iOS 11.0+
- Xcode 9.3+

