//
//  GetSensorModel.swift
//  Watch WatchKit Extension
//
//  Created by 上別縄祐也 on 2022/07/01.
//

import CoreMotion
import CoreLocation

final public class GetSenorModel {
    
    private init() {}
    public static let shared = GetSenorModel()
    
    @Published var displyTime = "0.00"
    var nowTime: Double = 0.0
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    var dataLog = allData(timeStamp: [], accelerationData: sensorData(name: "acceleration", X: [], Y: [], Z: []),
                          rotationData:sensorData(name: "rotation", X: [], Y: [], Z: []),
                          gpsData: gpsData(gpsTimeStamp: [], latitude: [], longitude: []),
                          gravityData: sensorData(name: "gravity", X: [], Y: [], Z: []),
                          atitudeData: sensorData(name: "attitude", X: [], Y: [], Z: []))
    
    func checkMotionActive(){
        if !motionManager.isDeviceMotionActive {
            print("Device Motion is not available.")
            return
        }
    }
    
    func initializeSensorData() {
        dataLog = allData(timeStamp: [], accelerationData: sensorData(name: "acceleration", X: [], Y: [], Z: []),
                          rotationData:sensorData(name: "rotation", X: [], Y: [], Z: []),
                          gpsData: gpsData(gpsTimeStamp: [], latitude: [], longitude: []),
                          gravityData: sensorData(name: "gravity", X: [], Y: [], Z: []),
                          atitudeData: sensorData(name: "attitude", X: [], Y: [], Z: []))
        
        nowTime = 0.0
    }
    
    func startGetMotionData() {
        motionManager.startDeviceMotionUpdates(to: queue) {[weak self] deviceMotion , error in
            if error != nil {
                print("Encountered error: \(error!)")
            }
            guard let motion = deviceMotion else { return }
            self?.getData(motion)
        }
    }
    
    func getData(_ data: CMDeviceMotion){
        let time: Double
        
        time = data.timestamp
        
        if (nowTime == 0.0){
            nowTime = time
        }
        
        print(data.userAcceleration.x)
        
        let elapsedTime = time - nowTime
        displyTime = String(format: "%.2f", elapsedTime)
        dataLog.timeStamp.append(elapsedTime)
        
        dataLog.accelerationData.X.append(data.userAcceleration.x)
        dataLog.accelerationData.Y.append(data.userAcceleration.y)
        dataLog.accelerationData.Z.append(data.userAcceleration.z)
        
        dataLog.rotationData.X.append(data.rotationRate.x)
        dataLog.rotationData.Y.append(data.rotationRate.y)
        dataLog.rotationData.Z.append(data.rotationRate.z)
        
        dataLog.gravityData.X.append(data.gravity.x)
        dataLog.gravityData.Y.append(data.gravity.y)
        dataLog.gravityData.Z.append(data.gravity.z)
        
        dataLog.atitudeData.X.append(data.attitude.pitch)
        dataLog.atitudeData.Y.append(data.attitude.roll)
        dataLog.atitudeData.Z.append(data.attitude.yaw)
    }
    
    func appendGpsData(latitude: Double, longitude: Double, time: String) {
        dataLog.gpsData.latitude.append(latitude)
        dataLog.gpsData.longitude.append(longitude)
        dataLog.gpsData.gpsTimeStamp.append(time)
    }
    
    func stopGetMotionData() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func getDataLog () -> allData {
        return dataLog
    }
}
