//
//  ViewController.swift
//  Example
//
//  Created by Rudy Bermudez on 10/25/17.
//  Copyright © 2017 Houston. All rights reserved.
//

import UIKit
import Houston

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		Logger.verbose("View Did Load")
		Logger.debug("Some Debug Info")
		Logger.info([1,2, "Something Important"])
		Logger.warning("Yikes this is not good")
		Logger.error("Some Fatal Error has occurred")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

