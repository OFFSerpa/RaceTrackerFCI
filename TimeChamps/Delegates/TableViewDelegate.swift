//
//  TabelViewDelegate.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 27/04/25.
//

import Foundation
import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    var routes: RouteRepository
    weak var navigationController: UINavigationController?
    
    init(routes: RouteRepository, navigationController: UINavigationController?) {
        self.routes = routes
        self.navigationController = navigationController
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = routes.allRoutes[indexPath.row]
        let routeDetailVC = RouteDetailViewController(route: route)
        navigationController?.pushViewController(routeDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
