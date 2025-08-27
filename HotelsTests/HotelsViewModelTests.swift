import XCTest
import RxSwift
import RxCocoa
import RealmSwift

@testable import Hotels

final class HotelsViewModelTests: XCTestCase {
    private var disposeBag: DisposeBag!
    private var database: MockDatabase!
    private var networking: MockNetworking!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        database = MockDatabase()
        networking = MockNetworking()
    }

    override func tearDown() {
        disposeBag = nil
        database = nil
        networking = nil
        super.tearDown()
    }

    func testSelectingDistanceSortReordersHotels() {
        let viewModel = HotelsViewModel(database: database, networkingService: networking)
        let expectation = self.expectation(description: "Sorted by distance")

        var received: [HotelTableViewCellModeling] = []
        viewModel.hotels.drive(onNext: { hotels in
            received = hotels
            if hotels.count == 2 {
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)

        let far = Hotel(id: 1, name: "Far", address: "", stars: 0, distance: 10, image: "", lat: 0, lon: 0)
        far.suitesAvailability.append(101)
        let near = Hotel(id: 2, name: "Near", address: "", stars: 0, distance: 5, image: "", lat: 0, lon: 0)
        near.suitesAvailability.append(201)

        database.hotelsSubject.onNext([far, near])
        viewModel.selectedSort.onNext(.distance)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(received.first?.hotelName, "Near")
    }

    func testSelectingRoomsSortReordersHotels() {
        let viewModel = HotelsViewModel(database: database, networkingService: networking)
        let expectation = self.expectation(description: "Sorted by rooms")

        var received: [HotelTableViewCellModeling] = []
        viewModel.hotels.drive(onNext: { hotels in
            received = hotels
            if hotels.count == 2 {
                expectation.fulfill()
            }
        }).disposed(by: disposeBag)

        let low = Hotel(id: 1, name: "Low", address: "", stars: 0, distance: 10, image: "", lat: 0, lon: 0)
        low.suitesAvailability.append(101)
        let high = Hotel(id: 2, name: "High", address: "", stars: 0, distance: 5, image: "", lat: 0, lon: 0)
        high.suitesAvailability.append(objectsIn: [201,202,203])

        database.hotelsSubject.onNext([low, high])
        viewModel.selectedSort.onNext(.rooms)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(received.first?.hotelName, "High")
    }

    func testHotelsEmitWhenDetailsChangeEvenIfCountSame() {
        let viewModel = HotelsViewModel(database: database, networkingService: networking)
        let expectation = self.expectation(description: "Emits on change")
        expectation.expectedFulfillmentCount = 2

        var emissions: [[HotelTableViewCellModeling]] = []
        viewModel.hotels.drive(onNext: { hotels in
            emissions.append(hotels)
            expectation.fulfill()
        }).disposed(by: disposeBag)

        let original = Hotel(id: 1, name: "Original", address: "", stars: 0, distance: 10, image: "", lat: 0, lon: 0)
        original.suitesAvailability.append(101)
        database.hotelsSubject.onNext([original])

        let updated = Hotel(id: 1, name: "Updated", address: "", stars: 0, distance: 12, image: "", lat: 0, lon: 0)
        updated.suitesAvailability.append(101)
        database.hotelsSubject.onNext([updated])

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(emissions.count, 2)
        XCTAssertEqual(emissions[1].first?.hotelName, "Updated")
    }
}

private final class MockDatabase: Database {
    let hotelsSubject = PublishSubject<[Hotel]>()

    func saveHotels(_ hotels: [Hotel]) { hotelsSubject.onNext(hotels) }
    func updateHotel(_ hotel: Hotel) { hotelsSubject.onNext([hotel]) }
    func getHotels() -> Observable<[Hotel]> { hotelsSubject.asObservable() }
    func getHotel(withId id: Int) -> Observable<Hotel> {
        return hotelsSubject.compactMap { hotels in
            hotels.first { $0.id == id }
        }
    }
}

private final class MockNetworking: NetworkingService {
    func getHotels() -> Observable<[Hotel]> { .just([]) }
    func getHotelInfo(hotelId: Int) -> Observable<Hotel?> { .just(nil) }
    func getHotelImage(imageId: Int) -> Observable<Data> { .just(Data()) }
}
