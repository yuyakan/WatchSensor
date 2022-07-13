//
//  ExportFile.swift
//  WatchSensor
//
//  Created by 上別縄祐也 on 2022/07/05.
//

import Foundation
import UIKit

class ExportFile {
    
    func exportFile(fileInfo: FileInfo) -> Bool {
        let fileManager = FileManager.default
        let directory = NSHomeDirectory() + "/Documents/" + fileInfo.directoryInfo
        
        do {
            try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true)
        } catch {
            print("failed make directory")
        }
                
        do {
            let path = directory + "/" + fileInfo.sensorInfo[0]
            try fileInfo.sensorInfo[1].write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            print("seccess")
        } catch {
            print("failed make file")
        }
        
        do {
            let path = directory + "/" + fileInfo.gpsInfo[0]
            try fileInfo.gpsInfo[1].write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            print("seccess")
        } catch {
            print("failed make file")
        }
        
        do {
            let path = directory + "/" + fileInfo.gravityAndAttitudeInfo[0]
            try fileInfo.gravityAndAttitudeInfo[1].write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            print("seccess")
        } catch {
            print("failed make file")
            return false
        }
        
        return true
    }
    
}
