//
//  SignedInDataSource.swift
//  Movie Time
//
//  Created by Arpit Singh on 31/01/23.
//

import UIKit
class SignedInDataSource: NSObject , UITableViewDataSource {
    
    private var tableView: UITableView?
    private var moviesList = [Movie](){
        didSet {
            tableView?.reloadData()
        }
    }
    private let limit = 600
    
    convenience init(_ tableView: UITableView) {
        self.init()
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .none
        self.tableView?.register(MovieCardTableViewCell.self,
                                forCellReuseIdentifier: MovieCardTableViewCell.cellID)
    }
    
    override init() {
        super.init()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getSize() -> Int {
        return moviesList.count
    }
    
    func updata(_ list: [Movie]) {
        if moviesList.count < limit {
            moviesList.append(contentsOf: list)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCardTableViewCell.cellID) as? MovieCardTableViewCell
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setTo(movie: moviesList[indexPath.row])
        return cell
    }
    
}
