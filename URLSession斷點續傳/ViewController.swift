//
//  ViewController.swift
//  URLSession斷點續傳
//
//  Created by EthanLin on 2018/4/1.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    
    
    //delegate一定要實作的方法
    //下載完後執行
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let data = try? Data(contentsOf: location)
        if let data = data{
//            DispatchQueue.main.async {
//                self.photoImageView.image = UIImage(data: data)
//            }
            
        }
        print("donwload finished successfully")
    }
    
    
    var downloadTask:URLSessionDownloadTask?
    var backgroundSession:URLSession?
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func playAction(_ sender: UIButton) {
        let url = URL(string: "http://video.cvr720.com/a74ecf04f6fa442abb4a1f33f5a38298/a02b13e35de142e6bceff59dcfd1cbba-5456d705cfd07e668f702e78be66cb6f.mp4")
        if let url = url{
            downloadTask = backgroundSession?.downloadTask(with: url)
            downloadTask?.resume()
        }
        
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        if downloadTask != nil{
            downloadTask?.cancel()
        }
    }
    
    @IBAction func pauseAction(_ sender: UIButton) {
        if downloadTask != nil{
            downloadTask?.suspend()
        }
    }
    
    @IBAction func resumeAction(_ sender: UIButton) {
        if downloadTask != nil{
            downloadTask?.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //支援背景下載
        let backgroundConfig = URLSessionConfiguration.background(withIdentifier: "background")
        backgroundSession = URLSession(configuration: backgroundConfig, delegate: self, delegateQueue: OperationQueue())
        
        //一開始進度條為0
        progressBar.setProgress(0.0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //delegate不一定要實作的方法，但因為我們想要顯示進度條
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
             self.progressBar.setProgress(progress, animated: true)
        }
        
        
        
    }
    
    //下載完如果有錯誤的話執行的方法
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadTask = nil
        
        if error != nil{
            print(error?.localizedDescription)
        }else{
            print("the task was completed successfully")
        }
    }


}

