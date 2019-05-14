//
//  ViewController.swift
//  GetBitRate
//
//  Created by Ventuno Technologies on 13/05/19.
//  Copyright © 2019 Ventuno Technologies. All rights reserved.
//

import UIKit
import VentunoLib
class ViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        test()
    }
    
    @IBAction func onPopUpBtnClicked(_ sender: Any) {
        
    }
    func test()
    {
        VtnGetURLContents().onResult { (result) in
            VtnLog.d(result)
            if let mDataStr = String(data: result, encoding: .utf8) {
                self.getBitrateList(mDataStr)
            }
            }.fetch("https://s3-us-west-2.amazonaws.com/hls-playground/hls.m3u8")
    }
    
    
    private func getBitrateList(_ mData:String)
    {
        let mVtnURLRequest = VtnURLRequest("https://www.ventunotech.com/m3u8/getBWDetails.php", VtnURLRequest.METHOD.POST)
        
        var postString = ""
        
        var mParams:[URLQueryItem] = [URLQueryItem]()
        
        mParams.append(URLQueryItem(name: "data", value: mData))
        
        var mURLComponents = URLComponents()
        mURLComponents.queryItems = mParams
        
        if let queryStr = mURLComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B") {
            postString = queryStr
        }
        
        
        VtnLog.trace("postString: \(postString)")
        
        mVtnURLRequest.setParams(postString)
            .onResult { (result) in
                VtnLog.d(result)
                self.parseJSON(result)
                
            }.onError { (error) in
                print(error ?? "")
            }.execute()
    }
    
    public func parseJSON(_ data:Data){
        
        let jsonObj:VtnJson = VtnJson.init(data)
        if let bandwidthArr:[Any] = jsonObj.optJsonArray("bandwidth"){
            for item in bandwidthArr {
               print(item)
            }
        }
    }


}

