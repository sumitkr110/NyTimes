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
    var datePickerView: UIView? = nil
    var datePicker : UIDatePicker = UIDatePicker()
    let dataSource = HomeTableViewDataSource()
    let delegate = HomeTableViewDelegate()
    lazy var viewModel : HomeViewModel = {
        let viewModel = HomeViewModel(dataSource:dataSource , delegate: delegate)
        return viewModel
    }()
    
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
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.register(UINib.init(nibName:BookListTableCell.cellIdentifier() , bundle: nil), forCellReuseIdentifier: BookListTableCell.cellIdentifier())
    }
    //Data binding with View Model
    func bindData(){
        viewModel.errorResult.addObserver(fireNow: false) { [weak self] errorResult in
            DispatchQueue.main.async {
               self?.tableView.isHidden = true
                self?.showAlertWithErrorResult(result:errorResult!)
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
                    self?.tableView.isHidden = false
                     self?.tableView.reloadData()
                }
            }
        }
    }
    @IBAction func showDatePicker(_ sender: UIBarButtonItem) {
        self.showDatePicker()
        searchBar.resignFirstResponder()
    }
    func showAlertWithErrorResult(result:ErrorResult) {
        let alert = UIAlertController(title: result.errorTitle, message: result.errorMessage, preferredStyle: UIAlertController.Style.alert)
        if result.errorTitle == Constant.noBookAlertTitle {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in self.showDatePicker()
            }))
        }
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Date Picker implementation
extension HomeViewController{
    
    func showDatePicker(){
       if datePickerView == nil {
            self.searchBar.text = ""
            datePickerView = UIView(frame: CGRect(x: 0, y: view.frame.height - CGFloat(Constant.datePickerViewHeight), width: view.frame.width, height: CGFloat(Constant.datePickerViewHeight)))
            datePickerView?.backgroundColor = .white
            //ToolBar
            let toolbar = self.getConfiguredToolBarForDatePicker()
            datePickerView?.addSubview(toolbar)
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: toolbar.frame.height, width: view.frame.width, height: datePickerView!.frame.height-toolbar.frame.height))
            //Format Date
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
            datePickerView?.addSubview(datePicker)
            self.view.addSubview(datePickerView!)
        }
    }
    
    func getConfiguredToolBarForDatePicker() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: datePickerView!.frame.width, height: CGFloat(Constant.toolBarHeight)))
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
        datePickerView?.removeFromSuperview()
        datePickerView = nil
    }
    
    @objc func cancelDatePicker(){
        datePickerView?.removeFromSuperview()
        datePickerView = nil
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
