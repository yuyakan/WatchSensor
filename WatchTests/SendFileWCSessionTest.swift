//
//  SendFileWCSessionTest.swift
//  WatchTests
//
//  Created by 上別縄祐也 on 2022/07/12.
//

import XCTest
@testable import Watch_WatchKit_Extension

class SendFileWCSessionTest: XCTestCase {
    
    let sendFileWCSession = SendFileWCSession()

    func testMakeDirName(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "[MM_dd]HH-mm-ss"
        XCTAssertEqual(sendFileWCSession.makeDirName(), dateFormatter.string(from: Date()))
    }

}
