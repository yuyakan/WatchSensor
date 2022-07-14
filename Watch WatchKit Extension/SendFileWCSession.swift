//
//  WCSession.swift
//  Watch WatchKit Extension
//
//  Created by 上別縄祐也 on 2022/07/03.
//

import WatchKit
import WatchConnectivity

class SendFileWCSession: NSObject, WCSessionDelegate {
    var crateCsv = CreateCsv()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func wCSessionSetting() {
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sendFile() -> Bool {
        let directoryName = makeDirName()
        let isMotionFileSended = sendMotionFile(directoryName: directoryName)
        let isGpsFileSended = sendGpsFile(directoryName: directoryName)
        let isGravityAndAttitudeFileSended = sendGravityAndAttitudeFile(directoryName: directoryName)
        
        if isMotionFileSended && isGpsFileSended && isGravityAndAttitudeFileSended {
            return true
        }
        return false
    }
    
    func makeDirName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "[MM_dd]HH-mm-ss"
        let fileName = dateFormatter.string(from: Date())
        return fileName
    }
    
    func sendMotionFile(directoryName: String) -> Bool {
        let csv = crateCsv.createMotionCsv()
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = "Motion.csv"
        
        let url = tempDirectory.appendingPathComponent(fileName)
        let message = ["title": directoryName, "file": fileName, "tag": "motion"]
        
        do {
            try csv.write(to: url, atomically: true, encoding: String.Encoding.utf8)
            WCSession.default.transferFile(url, metadata: message)
            print(url)
        } catch {
            return false
        }
        return true
    }
    
    func sendGpsFile(directoryName: String) -> Bool {
        let csv = crateCsv.createGpsCsv()
        
        let tempDirectory = FileManager.default.temporaryDirectory
        
        let fileName = "GPS.csv"
        
        let url = tempDirectory.appendingPathComponent(fileName)
        let message = ["title": directoryName, "file": fileName, "tag": "gps"]
        
        do {
            try csv.write(to: url, atomically: true, encoding: String.Encoding.utf8)
            WCSession.default.transferFile(url, metadata: message)
        } catch {
            return false
        }
        return true
    }
    
    func sendGravityAndAttitudeFile(directoryName: String) -> Bool {
        let csv = crateCsv.crateGravityAndAttitudeCsv()
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = "GravityAndAttitude.csv"
        
        let url = tempDirectory.appendingPathComponent(fileName)
        let message = ["title": directoryName, "file": fileName, "tag": "g_and_a"]
        
        do {
            try csv.write(to: url, atomically: true, encoding: String.Encoding.utf8)
            WCSession.default.transferFile(url, metadata: message)
        } catch {
            return false
        }
        return true
    }
}
