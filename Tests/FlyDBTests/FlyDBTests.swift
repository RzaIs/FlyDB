import XCTest
@testable import FlyDB

final class FlyDBTests: XCTestCase {

    struct Mock: FlyingObject {
        typealias PrimaryKey = String
        static let collection: String = "mock"

        let primaryKey: String
        let info: String

        init(
            primaryKey: String = UUID().uuidString,
            info: String
        ) {
            self.primaryKey = primaryKey
            self.info = info
        }
    }

    func genMocks() -> [Mock] {
        [
            Mock(info: "mock-1"),
            Mock(info: "mock-2"),
            Mock(info: "mock-3"),
        ]
    }

    var mocks: [Mock] = []


    override func setUp() {
        super.setUp()

        mocks = genMocks()
    }

    override func tearDown() {
        super.tearDown()
        let path = FileManager.default.currentDirectoryPath + "/" + "fly_db"
        try? FileManager.default.removeItem(atPath: path)
    }

    func testWriteAndReadOne() throws {
        let fly = try Fly(name: "some_db")
        try fly.transaction {
            fly.white(objects: [mocks[0]])
        }.get()

        let obj = try XCTUnwrap(fly.read(Mock.self, pk: mocks[0].primaryKey))

        XCTAssertEqual(obj, mocks[0])
    }

    func testWriteWithoutLock() throws {
        let fly = try Fly(name: "some_db")

        switch fly.white(objects: mocks) {
        case .success:
            XCTFail("cannot write outside of transaction")
        case .failure(let error):
            if let error = error as? FlyingError {
                XCTAssertEqual(error, FlyingError.writeAttemptOutOfTransactionBlock)
            } else {
                XCTFail("wring type of error")
            }
        }

        // after an invalid attemp db should be ok to continue operations

        try fly.transaction {
            fly.white(objects: [mocks[0]])
        }.get()

        let obj = try XCTUnwrap(fly.read(Mock.self, pk: mocks[0].primaryKey))

        XCTAssertEqual(obj, mocks[0])
    }

    func testWriteAndReadMany() throws {
        let fly = try Fly(name: "some_db")

        try fly.transaction {
            fly.white(objects: mocks)
        }.get()

        let objs = fly.read(Mock.self)

        XCTAssertEqual(
            objs.sorted(by: { $0.primaryKey < $1.primaryKey }),
            mocks.sorted(by: { $0.primaryKey < $1.primaryKey })
        )
    }
}
