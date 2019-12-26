//
//  SearchHintList.swift
//  ObjectList
//
//  Created by Сергей Новиков on 25/12/2019.
//  Copyright © 2019 Сергей Новиков. All rights reserved.
//

import UIKit

class HintTableView: UITableView {
    var onCellSelected: ((String) -> Void)?
    var data: [String] = [] {
        didSet {
            reloadData()
        }
    }

    override func didMoveToSuperview() {
        setup()
    }
    
    private func setup() {
        register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        dataSource = self
        delegate = self
    }
}

extension HintTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

extension HintTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellSelected?(data[indexPath.row])
    }
}
