# Hotels
> Project is an iOS app

The application downloads a JSON document with information about several hotels from the server, parses it and displays the data of these hotels.
Hotels can be sorted by one of two parameters: by the distance of the hotel from the city center or by the number of available rooms.
There is a separate screen for viewing detailed information about the hotel and a screen with the location of the hotel on the map.

![main](/Screenshots/main.png)![sorting](/Screenshots/sorting.png)![info](/Screenshots/info.png)![map](/Screenshots/map.png)
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

