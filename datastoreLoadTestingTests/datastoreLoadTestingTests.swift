//
//  datastoreLoadTestingTests.swift
//  datastoreLoadTestingTests
//
//  Created by Law, Michael on 3/24/21.
//

import XCTest
@testable import datastoreLoadTesting
import Amplify
import AmplifyPlugins
class datastoreLoadTestingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let clearCompleted = expectation(description: "clear completed")

        Amplify.DataStore.clear { (result) in
            switch result {
            case .success:
                clearCompleted.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("Failed")
            }
        }
        wait(for: [clearCompleted], timeout: 60)

        let startTime = CFAbsoluteTimeGetCurrent()
        let startCompleted = expectation(description: "start completed")
        let blogSynced = expectation(description: "blogSynced")
        let postSynced = expectation(description: "postSynced")
        let commentSynced = expectation(description: "commentSynced")
        
        // Put the code you want to measure the time of here.
        Amplify.DataStore.start { (result) in
            switch result {
            case .success:
                print("Completed")
                startCompleted.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("Failed")
            }
        }
        wait(for: [startCompleted], timeout: 60)
        let subscriber = Amplify.Hub.publisher(for: .dataStore).sink { (payload) in
            switch payload.eventName {
            case HubPayload.EventName.DataStore.modelSynced:
                guard let modelSyncedEvent = payload.data as? ModelSyncedEvent else {
                    Amplify.log.error(
                        """
                                    Failed to case payload of type '\(type(of: payload.data))' \
                                    to ModelSyncedEvent. This should not happen!
                                    """
                    )
                    return
                }
                
                switch modelSyncedEvent.modelName {
                case Blog6.modelName:
                    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                    print("Time elapsed Blog: \(timeElapsed) s.")
                    blogSynced.fulfill()
                case Post6.modelName:
                    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                    print("Time elapsed Post: \(timeElapsed) s.")
                    postSynced.fulfill()
                case Comment6.modelName:
                    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                    print("Time elapsed Comments: \(timeElapsed) s.")
                    commentSynced.fulfill()
                default:
                    return
                }
            
            default:
                return
            }
        }
        wait(for: [blogSynced, postSynced, commentSynced], timeout: 120)
    }

}
