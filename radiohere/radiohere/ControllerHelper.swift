//
//  ControllerHelper.swift
//  radiohere
//
//  Created by Spencer Ward on 25/12/2014.
//  Copyright (c) 2014 Spencer Ward. All rights reserved.
//

import Foundation

class ControllerHelper {
    var controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func showTopBar(viewName: String, owner: UIViewController) {
        var view = NSBundle.mainBundle().loadNibNamed(viewName, owner: owner, options: nil)[0] as UIView
        view.frame = CGRectMake(0, 0, 380, 40)
        controller.navigationItem.titleView = view
        controller.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.innocence()]
        controller.navigationController?.navigationBar.barTintColor = UIColor.pachyderm()
        controller.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func showBottomBar(viewName: String, owner: UIViewController) {
        var view = NSBundle.mainBundle().loadNibNamed(viewName, owner: owner, options: nil)[0] as UIView
        controller.navigationController?.toolbar.barStyle = UIBarStyle.BlackTranslucent
        controller.navigationController?.toolbar.barTintColor = UIColor.pachyderm()
        controller.navigationController?.setToolbarHidden(false, animated: true)
        var myItems = NSMutableArray()
        view.frame = CGRectMake(0, 0, 320, 40)
        var item = UIBarButtonItem(customView: view)
        myItems.addObject(item)
        controller.toolbarItems = myItems
    }
    

}