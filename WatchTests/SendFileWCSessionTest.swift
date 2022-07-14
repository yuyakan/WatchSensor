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
    
    func testSendFile(){
        XCTAssertTrue(sendFileWCSession.sendFile())
    }
    
    func testSendMotionFile(){
        XCTAssertTrue(sendFileWCSession.sendMotionFile(directoryName: "directoryName"))
    }
    
    func testSendGpsFile(){
        XCTAssertTrue(sendFileWCSession.sendGpsFile(directoryName: "directoryName"))
    }
    
    func testSendGravityAndAttitudeFile(){
        XCTAssertTrue(sendFileWCSession.sendGravityAndAttitudeFile(directoryName: "directory"))
    }
    

}
