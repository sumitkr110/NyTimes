//
//  ViewController.swift
//  NyTimes
//
//  Created by Sumit Kumar on 14/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var datePickerButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var datePickerView: UIView = UIView()
    let viewModel : HomeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetchBookListForDate(date: Date().string(format: "2020-08-14"))
        searchBar.delegate = self
        self.configureTableView()
        self.bindData()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName:BookListTableCell.cellIdentifier() , bundle: nil), forCellReuseIdentifier: BookListTableCell.cellIdentifier())
    }
    
    func bindData(){
        viewModel.sectionVMs.addObserver(fireNow: false) { [weak self] (homeVMs) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
            }
        }
        viewModel.isLoading.addObserver {[weak self] isLoading in
            DispatchQueue.main.async {
                if (isLoading){
                    self?.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.3))
                    self?.tableView.isHidden = true
                }
                else{
                    self?.view.activityStopAnimating()
                }
            }
        }
        
    }
    @IBAction func showDatePicker(_ sender: UIBarButtonItem) {
        self.showDatePicker()
    }
}

//MARK: - UITableView DataSource
extension HomeViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        print("section count is \(viewModel.sectionVMs.value.count)")
        return viewModel.sectionVMs.value.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionViewModel = viewModel.sectionVMs.value[section]
        print("Row count is \(sectionViewModel.rowViewModels.count)")
        return sectionViewModel.rowViewModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionVM = viewModel.sectionVMs.value[indexPath.section]
        let rowVM = sectionVM.rowViewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:BookListTableCell.cellIdentifier(), for: indexPath)
        if let cell = cell as? CellConfigurable{
            cell.setup(viewModel: rowVM)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionVMs.value[section].headerTitle
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .groupTableViewBackground
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = viewModel.sectionVMs.value[section].headerTitle
        label.font = UIFont.init(name: "Verdana-Bold", size: 18)
        headerView.addSubview(label)
        return headerView
    }
}

//MARK: - Date Picker implementation
extension HomeViewController{
    
    func showDatePicker(){
        datePickerView = UIView(frame: CGRect(x: 0, y: view.frame.height - 260, width: view.frame.width, height: 260))
        //ToolBar
        let toolbar = self.getConfiguredToolBarForDatePicker()
        datePickerView.addSubview(toolbar)
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: toolbar.frame.height, width: view.frame.width, height: datePickerView.frame.height-toolbar.frame.height))
        //Format Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePickerView.addSubview(datePicker)
        self.view.addSubview(datePickerView)
    }
    
    func getConfiguredToolBarForDatePicker() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: datePickerView.frame.width, height: 44))
        toolbar.barStyle = .black
        toolbar.isTranslucent =  true
        toolbar.tintColor = .white
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(selectDateFromPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        return toolbar
    }
    @objc func selectDateFromPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        datePickerView.removeFromSuperview()
    }
    
    @objc func cancelDatePicker(){
        datePickerView.removeFromSuperview()
    }
}
extension HomeViewController : UISearchBarDelegate
{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        self.viewModel.filterBooksForSearchText(searchText: searchText)
    }
}
