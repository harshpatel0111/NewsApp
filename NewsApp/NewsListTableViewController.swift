//
//  Copyright © 2020 Harsh patel. All rights reserved.
//

import UIKit
import Network

class NewsListTableViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var articles = [Article]()
    var filteredAtricles = [Article]()
    @IBOutlet weak var newsListTableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
    let queue = DispatchQueue.global(qos: .background)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadArticles()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchBar()
        setupNewsTableView()
    }
    
    func loadArticles() {
        NewsApi.shared.fetchHeadlineArticles { articles in
            self.articles.append(contentsOf: articles)
            self.filteredAtricles = self.articles
            self.newsListTableView.reloadData()
        }
    }
}

extension NewsListTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredAtricles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.identifier, for: indexPath) as? NewsListTableViewCell {

            cell.configureCell(title: filteredAtricles[indexPath.row].title, source: filteredAtricles[indexPath.row].source?.name ?? "", description: filteredAtricles[indexPath.row].description ?? "")

            if let url = filteredAtricles[indexPath.row].urlToImage {
                cell.newsImageView.loadImage(urlString: url)
            }
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - TableView Delegate Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if filteredAtricles[indexPath.row].id == self.filteredAtricles.last?.id {
            loadArticles()
        }
    }
    
    // MARK: - Navigation
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.filteredAtricles[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.urlFromSegue = URL(string: article.url ?? "")
        vc.navigationTitle = article.source?.name
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Setup UI
    
    private func setupNewsTableView() {
        newsListTableView.dataSource = self
        newsListTableView.delegate = self
        newsListTableView?.estimatedRowHeight = 320
        newsListTableView?.rowHeight = UITableView.automaticDimension
        newsListTableView.register(NewsListTableViewCell.nib, forCellReuseIdentifier: NewsListTableViewCell.identifier)
        newsListTableView.tableFooterView = UIView()
    }

    private func setupNavigationBar() {
        let titleLabel = UILabel()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemPink
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.accessibilityTraits = .searchField;
    }
    
    // MARK: - SearchBar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateTableFromSearch(searchController.searchBar)
    }
    
    fileprivate func updateTableFromSearch(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredAtricles = self.articles.filter { article in
                return (article.description ?? "").lowercased().contains(searchText.lowercased()) || (article.title ).lowercased().contains(searchText.lowercased()) || (article.content ?? "").lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredAtricles = articles
        }
        newsListTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        updateTableFromSearch(searchController.searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredAtricles = articles
        newsListTableView.reloadData()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredAtricles = articles
            newsListTableView.reloadData()
        }
    }
    
    // MARK: - Handle internet conection
     private func checkForInternetConection()  {
         monitor.pathUpdateHandler = { path in
             if path.status == .satisfied {
                 print("Connected")
             } else if path.status == .requiresConnection {
                 print("need conection")
             } else if  path.status == .unsatisfied {
                 DispatchQueue.main.async {
                     let massage = "Please,conect to internet and refresh the page"
                     let alert = UIAlertController(title: "No internet conection", message: massage, preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title:"OK",style: .default, handler: nil))
                     self.present(alert,animated: true,completion: nil)
                 }
             }
         }
         monitor.start(queue: queue)
     }
}

