//
//  Promise+CIFilter.swift
//  HamburgerToday
//
//  Created by Ben Gottlieb on 11/6/16.
//  Copyright © 2016 Stand Alone, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	enum FilterError: Error { case unableToGetCGImage, unableToCreateFilter, unableToRunFilter, unableToBuildResultantCGImage }
	
	func applyFilter(_ filterName: String = "CISepiaTone", parameters: [String: Any] = [:]) -> Promise<UIImage> {
		let promise = Promise<UIImage>()
		
		DispatchQueue(label: "filter", qos: .userInitiated).async {
			guard let cgImage = self.cgImage else {
				promise.reject(FilterError.unableToGetCGImage)
				return
			}
			let beginImage = CIImage(cgImage: cgImage)
			
			guard let filter = CIFilter(name: filterName) else {
				promise.reject(FilterError.unableToCreateFilter)
				return
			}
			filter.setValue(beginImage, forKey: kCIInputImageKey)
			
			for (key, value) in parameters {
				filter.setValue(value, forKey: key)
			}
		
			guard let outputImage = filter.outputImage else {
				promise.reject(FilterError.unableToRunFilter)
				return
			}
		
			let context = CIContext(options:nil)
			guard let result = context.createCGImage(outputImage, from: outputImage.extent) else {
				promise.reject(FilterError.unableToBuildResultantCGImage)
				return
			}
			
			let uiImage = UIImage(cgImage: result)
			promise.fulfill(uiImage)
		}
		
		return promise
	}
}
