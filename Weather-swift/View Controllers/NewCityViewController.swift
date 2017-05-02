//
// Created by Kirill Pyulzyu on 02.05.17.
// Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit

let searchBarHeight = 50


class NewCityViewController: UIViewController, UISearchBarDelegate {

    lazy var searchBar: UISearchBar = self.lazySearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initUI()
    }


    func initUI(){
        self.view.addSubview(self.searchBar)
    }


    //MARK: Search bar

    func lazySearchBar() -> UISearchBar {

        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width), height: searchBarHeight))
        searchBar.delegate = self
        return searchBar
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchBar.text!)")
    }


}


