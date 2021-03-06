//
//  ViewController.swift
//  SpaceX
//
//  Created by ovr on 19.05.2021.
//

import UIKit

class DragonsListViewContoller: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let networkManager = NetworkManager()
    private var dragons: [Dragon] = []
    private var selectedDragon: Dragon?
    private let pullToRefresh = UIRefreshControl()
    private let cellReuseIdentifier = "DragonCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pullToRefresh.addTarget(self, action: #selector(loadDragonList), for: .valueChanged)
        tableView.refreshControl = pullToRefresh
        pullToRefresh.tintColor = .white
        
        tableView.register(DragonCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        let nib = UINib.init(nibName: cellReuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.tableFooterView = UIView()
        
        loadDragonList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDragonDetails" {
            let vc = segue.destination as! DragonDetailsViewController
            vc.dragon = selectedDragon
        }
    }
    
    @objc func loadDragonList() {
        networkManager.getDragonList { dragonsResult in
            debugPrint(dragonsResult)
            self.dragons = dragonsResult
            self.tableView.reloadData()
            self.pullToRefresh.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

extension DragonsListViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! DragonCell
        cell.setup(dragon: dragons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        selectedDragon = dragons[indexPath.row]
        performSegue(withIdentifier: "toDragonDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dragons.count
    }
}

