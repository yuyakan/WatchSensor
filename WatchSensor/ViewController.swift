//
//  ViewController.swift
//  WatchSensor
//
//  Created by 上別縄祐也 on 2022/06/27.
//

import UIKit
import WatchConnectivity
import RealmSwift


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var TableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let directoryInfo = realm.objects(DirectoryInfo.self)
        let directoryInfo = [DirectoryInfoMock.mock1] //　テスト用
        return directoryInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath)
        
//        let directoryInfo = realm.objects(DirectoryInfo.self)
        let directoryInfo = [DirectoryInfoMock.mock1] // テスト用
        cell.textLabel?.text = "\(directoryInfo[indexPath.row].directoryName)"
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            
            let directoryInfo = self.realm.objects(DirectoryInfo.self)[indexPath.row]
            let sensorInfo = self.realm.objects(SensorInfo.self)[indexPath.row]
            let gpsInfo = self.realm.objects(GpsInfo.self)[indexPath.row]
            let gravityAndAttitudeInfo = self.realm.objects(GravityAndAttitudeInfo.self)[indexPath.row]
            
            do{
                try self.realm.write{
                    self.realm.delete(directoryInfo)
                    self.realm.delete(sensorInfo)
                    self.realm.delete(gpsInfo)
                    self.realm.delete(gravityAndAttitudeInfo)
                }
            } catch {
                print(error)
            }
            tableView.reloadData()
            completionHandler(true)
        }
        
        delete.backgroundColor = .systemPink
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let sensorFileName = realm.objects(SensorInfo.self)[indexPath.row].fileName
//        let sensorFileContents = realm.objects(SensorInfo.self)[indexPath.row].fileContents
//        let sensorInfo = [sensorFileName, sensorFileContents]
//
//        let gpsFileName = realm.objects(GpsInfo.self)[indexPath.row].fileName
//        let gpsFileContents = realm.objects(GpsInfo.self)[indexPath.row].fileContents
//        let gpsInfo = [gpsFileName, gpsFileContents]
//
//        let gravityAndAttitudeFileName = realm.objects(GravityAndAttitudeInfo.self)[indexPath.row].fileName
//        let gravityAndAttitudeFileContents = realm.objects(GravityAndAttitudeInfo.self)[indexPath.row].fileContents
//        let gravityAndAttitudeInfo = [gravityAndAttitudeFileName, gravityAndAttitudeFileContents]
        
//        performSegue(withIdentifier: "Detail", sender: FileInfo(sensorInfo: sensorInfo, gpsInfo: gpsInfo, directoryInfo: realm.objects(DirectoryInfo.self)[indexPath.row].directoryName, gravityAndAttitudeInfo: gravityAndAttitudeInfo))
        
        performSegue(withIdentifier: "Detail", sender: FileInfo.mock1)// テスト用
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Detail") {
            guard let detailViewController = segue.destination as? DetailViewController else { print("failed to prepare")
                return
            }
            detailViewController.fileInfo = sender as! FileInfo
        } else {
            print("segue identifier Failed")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        TableView.dataSource = self
        TableView.delegate = self
        TableView.separatorInset = .zero
        TableView.separatorColor = UIColor.white
        
    }
}



extension ViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let directoryName = file.metadata?["title"] as! String
        let fileName = file.metadata?["file"] as! String
        let fileContents = try? String(contentsOf: file.fileURL, encoding: .utf8)
        let tag = file.metadata?["tag"] as! String
        
        DispatchQueue.main.async {
            if let fileContents = fileContents {
                if tag == "gps" {
                    
                    let gpsInfo = GpsInfo()
                    gpsInfo.fileName = fileName
                    gpsInfo.fileContents = fileContents
                    
                    try! self.realm.write {
                        self.realm.add(gpsInfo)
                    }
                    
                } else if tag == "g_and_a" {
                    
                    let gravityAndAttitudeInfo = GravityAndAttitudeInfo()
                    gravityAndAttitudeInfo.fileName = fileName
                    gravityAndAttitudeInfo.fileContents = fileContents
                    
                    try! self.realm.write {
                        self.realm.add(gravityAndAttitudeInfo)
                    }
                    
                } else {
                    
                    let directoryInfo = DirectoryInfo()
                    directoryInfo.directoryName = directoryName
                    
                    let sensorInfo = SensorInfo()
                    sensorInfo.fileName = fileName
                    sensorInfo.fileContents = fileContents
                    
                    try! self.realm.write {
                        self.realm.add(directoryInfo)
                        self.realm.add(sensorInfo)
                    }
                }
            }
            self.TableView.reloadData()
        }
    }
}
