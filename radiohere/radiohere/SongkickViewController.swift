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
        var request = NSURLRequest(URL: NSURL(string:url!)!)
        webView?.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
