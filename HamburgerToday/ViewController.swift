//
//  ViewController.swift
//  HamburgerToday
//
//  Created by Ben Gottlieb on 11/4/16.
//  Copyright © 2016 Stand Alone, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reloadImage)))
		self.imageView.isUserInteractionEnabled = true
		
		self.reloadImage()
	}
	
	func reloadImage() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let startedAt = Date()
		
		let size = self.view.bounds.size
		let url = URL(string: "https://loremflickr.com/\(Int(size.width / 2))/\(Int(size.height / 2))")!
		
		URLSession.shared.get(url: url).then { data  in
			UIImage(data: data)
		}.then { image in
			image!.applyFilter("CICrystallize", parameters: ["inputRadius": 1])
		}.then { image in
			self.imageView.image = image
		}.catch { error in
			print("Failed to download: \(error)")
		}.finally {
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}.finally {
			let sec = abs(startedAt.timeIntervalSinceNow)
			print("Load complete (took \(sec) sec)")
		}
	}
}

