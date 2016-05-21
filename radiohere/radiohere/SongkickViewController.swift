//
//  SongkickViewController.swift
//  radiohere
//
//  Created by Spencer Ward on 19/07/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import UIKit

class SongkickViewController: UIViewController {
    var url : String?
    
    @IBOutlet var webView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.backgroundColor = UIColor(patternImage: UIImage(named:"songkick6.jpg")!)
        self.automaticallyAdjustsScrollViewInsets = false
        let request = NSURLRequest(URL: NSURL(string:url!)!)
        webView?.loadRequest(request)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidAppear(animated: Bool) {
        navigationController?.toolbarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
