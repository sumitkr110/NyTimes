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
    var datePicker : UIDatePicker = UIDatePicker()
    let viewModel : HomeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetchBookListForDate(date: Date().string(format: Constant.dateFormat))
        searchBar.delegate = self
        self.configureTableView()
        self.bindData()
    }
    //Table View SetUp
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName:BookListTableCell.cellIdentifier() , bundle: nil), forCellReuseIdentifier: BookListTableCell.cellIdentifier())
    }
    //Data binding with View Model
    func bindData(){
        viewModel.sectionVMs.addObserver(fireNow: false) { [weak self] sectionVMs in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
            }
        }
        viewModel.bookCount.addObserver(fireNow: false) { [weak self] bookCount in
            DispatchQueue.main.async {
                if bookCount == 0{
               self?.showAlertForBookUnavailability()
                }
            }
        }
        viewModel.filteredList.addObserver(fireNow: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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
    func showAlertForBookUnavailability() {
        let alert = UIAlertController(title: Constant.noBookAlertTitle, message: Constant.noBookAlertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in self.showDatePicker()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableView DataSource
extension HomeViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionVMs.value.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionVMs.value[section].rowViewModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  rowVM = viewModel.sectionVMs.value[indexPath.section].rowViewModels[indexPath.row]
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
        return CGFloat(Constant.tableViewSectionHeight)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(Constant.tableViewSectionHeight)))
        headerView.backgroundColor = Constant.tableViewSectionBackgroundColor
        let label = UILabel()
        label.frame = headerView.frame
        label.text = viewModel.sectionVMs.value[section].headerTitle
        label.font = Constant.tableViewSectionTitleFont
        headerView.addSubview(label)
        return headerView
    }
}

//MARK: - Date Picker implementation
extension HomeViewController{
    
    func showDatePicker(){
        datePickerView = UIView(frame: CGRect(x: 0, y: view.frame.height - CGFloat(Constant.datePickerViewHeight), width: view.frame.width, height: CGFloat(Constant.datePickerViewHeight)))
        datePickerView.backgroundColor = .white
        //ToolBar
        let toolbar = self.getConfiguredToolBarForDatePicker()
        datePickerView.addSubview(toolbar)
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: toolbar.frame.height, width: view.frame.width, height: datePickerView.frame.height-toolbar.frame.height))
        //Format Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePickerView.addSubview(datePicker)
        self.view.addSubview(datePickerView)
    }
    
    func getConfiguredToolBarForDatePicker() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: datePickerView.frame.width, height: CGFloat(Constant.toolBarHeight)))
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
        let date = datePicker.date.string(format: Constant.dateFormat)
        viewModel.isLoading.value = true
        viewModel.fetchBookListForDate(date:date)
        datePickerView.removeFromSuperview()
    }
    
    @objc func cancelDatePicker(){
        datePickerView.removeFromSuperview()
    }
}
//MARK: - UISearchBarDelegate implementation
extension HomeViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.filterBooksForSearchText(searchText: searchText)
        if searchText.isEmpty{
            searchBar.resignFirstResponder()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.viewModel.filterBooksForSearchText(searchText: "")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
