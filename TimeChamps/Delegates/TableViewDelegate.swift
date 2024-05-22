//
//  TabelViewDelegate.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 22/05/24.
//

import Foundation
import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let routes: Routes
    
    init(routes: Routes) {
        self.routes = routes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.allRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteTableViewCell
        let route = routes.allRoutes[indexPath.row]
        cell.configure(with: route)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
