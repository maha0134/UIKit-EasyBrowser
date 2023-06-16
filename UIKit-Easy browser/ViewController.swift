//
//  ViewController.swift
//  UIKit-Easy browser
//
//  Created by AKSHAY MAHAJAN on 2023-05-25.
//

import UIKit

class ViewController: UITableViewController {
	var websites = ["portfolio-akshay-mahajan.netlify.app", "apple.com", "hackingwithswift.com"]
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return websites.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteCell", for: indexPath)
		cell.textLabel?.text = websites[indexPath.row]
		return cell
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Websites"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let wbc = storyboard?.instantiateViewController(withIdentifier: "Website") as? WebViewController {
			wbc.websites = self.websites
			navigationController?.pushViewController(wbc, animated: true)
		}
		
	}
}

