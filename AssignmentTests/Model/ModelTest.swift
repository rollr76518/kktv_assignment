import XCTest
@testable import Assignment1

/************
 Write down Model Tests as possible as you can.
 You can use `loadData` function to load local json data.
 ************/
class ModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    private func loadData(fileName:String,type:String) -> [String:Any]? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: type) else {
            XCTAssert(false, "can not find path")
            return nil
        }

        guard let loadData = NSData(contentsOfFile: path)  else {
            XCTAssert(false, "can not load")
            return nil
        }

        guard let dic = try? JSONSerialization.jsonObject(with: loadData as Data, options: []) as? [String: Any] else {
            XCTAssert(false, "unable convert to dictionary")
            return nil
        }

        return dic
    }

    func testExample() {
        XCTAssertNotNil(loadData(fileName: "success", type: "json"))
        XCTAssertNotNil(loadData(fileName: "fail", type: "json"))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
