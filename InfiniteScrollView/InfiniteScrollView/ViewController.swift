//
//  ViewController.swift
//  InfiniteScrollView
//
//  Created by Brian Doyle on 8/18/19.
//  Copyright © 2019 Balance Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let scrollView = InfiniteScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)

        scrollView.backgroundColor = .yellow

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
