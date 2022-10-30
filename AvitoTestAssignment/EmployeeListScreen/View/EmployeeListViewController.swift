//
//  ViewController.swift
//  AvitoTestAssignment
//
//  Created by Yan Sakhnevich on 28.10.2022.
//

import UIKit

final class EmployeesListViewController: UIViewController {
    
    // MARK: - Sections for collectionView
    enum Section {
        case main
    }
    
    // MARK: - EmployeesListViewController variables and constants
    var presenter: EmployeeListPresenterProtocol!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Employee>?
    private var employeeListCollection: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Avito employees list"
        setupCollectionView()
        setupDataSource()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkMonitor.shared.startMonitoring()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showOfflineDeviceUI),
                                               name: NSNotification.Name.connectivityStatus,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NetworkMonitor.shared.stopMonitoring()
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.connectivityStatus,
                                                  object: nil)
    }
    
    // MARK: - NotificationCenter selector method
    @objc func showOfflineDeviceUI(_ notification: Notification) {
        DispatchQueue.main.async {
            if !NetworkMonitor.shared.isConnected {
                let alert = UIAlertController(title: nil, message: "No internet connection", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Layout details
    private func layoutDetails(for: Section) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - Setup CollectionView
    private func setupCollectionView() {
        employeeListCollection = UICollectionView(frame: view.bounds, collectionViewLayout: layoutDetails(for: .main))
        employeeListCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        employeeListCollection.backgroundColor = .systemBackground
        employeeListCollection.register(EmployeeTableViewCell.self, forCellWithReuseIdentifier: EmployeeTableViewCell.cellIdentifier)
        view.addSubview(employeeListCollection)
        reloadData()
    }
    
    
    // MARK: - Snapshot generating
    private func generateSnapshot() -> NSDiffableDataSourceSnapshot<Section, Employee> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Employee>()
        let employee = (presenter.employees)!
        snapshot.appendSections([.main])
        snapshot.appendItems(employee, toSection: Section.main)
        return snapshot
    }
    
    // MARK: - Reload data for employeeListCollection
    private func reloadData() {
        dataSource?.apply(generateSnapshot(), animatingDifferences: false)
    }
}

// MARK: - EmployeeListProtocol methods
extension EmployeesListViewController: EmployeeListProtocol {
    
    func succes() {
        reloadData()
    }
    func failure(error: ErrorTypes) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Manage the data in employeeListCollection
extension EmployeesListViewController {
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Employee>(collectionView: employeeListCollection, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            
            let employee = self.presenter.employees?[indexPath.row]
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmployeeTableViewCell.cellIdentifier, for: indexPath) as? EmployeeTableViewCell else { fatalError("Cannot create the cell") }
            cell.configureCellWith(name: employee?.name ?? "",
                                   phoneNumber: employee?.phoneNumber ?? "",
                                   skills: employee?.skills?.joined(separator: ", ") ?? "")
            return cell
        })
    }
}
