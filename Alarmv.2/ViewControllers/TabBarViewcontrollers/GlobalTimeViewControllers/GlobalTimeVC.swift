//
//  GlobalTimeViewController.swift
//  Alarm v.2
//
//  Created by Евгений Лянкэ on 24.05.2022.
//

import UIKit

final class GlobalTimeVC: UIViewController, CitiesVCDelegate {
   
    let citiesVC = CitiesVC()
   
    var addCityButton:UIButton = {
        let button = UIButton()
        button.tintColor = .orange
        let font = UIFont.systemFont(ofSize: 23)
        let config = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: Constants.Image.plusImage, withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    var removeCityButton:UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Labels.removeCityLabel, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        return button
    }()
    
    var timeLabel:UILabel = {
        let time = UILabel()
        time.text = "Мировые часы"
        time.font = .systemFont(ofSize: 35)
        time.textColor = .white
        return time
    }()
    
    var tableview:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    var citiesCV = CitiesVC()
    var selectedCities = [CityData]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        removeCityButton.addTarget(self, action: #selector(removeCityPressed), for: .touchUpInside)
        addCityButton.addTarget(self, action: #selector(addCityPressed), for: .touchUpInside)
        tableview.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        tableview.delegate = self
        tableview.dataSource = self
        citiesVC.controllerDelegate = self
        selectedCities = DataManager.shared.cities()
        
    }
    
    //MARK: - Actions
    @objc
    func removeCityPressed() {
        if tableview.isEditing {
            tableview.isEditing = false
        } else {
            tableview.isEditing = true
        }
    }
    
    @objc
    func addCityPressed() {
        present(citiesVC, animated: true, completion: nil)
    }
    
    private func configureView() {
        view.backgroundColor = .black
        
        view.addSubview(addCityButton)
        addCityButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor,padding: .init(top: 10, left: 0, bottom: 0, right: 20))
        
        view.addSubview(removeCityButton)
        removeCityButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 10, left: 20, bottom: 0, right: 0))
        
        view.addSubview(timeLabel)
        timeLabel.anchor(top: removeCityButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 10, left: 20, bottom: 0, right: 0))
        
        view.addSubview(tableview)
        tableview.anchor(top: timeLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        tableview.backgroundColor = .black
    }
    func didSelectCity(_ city: CityModel) {
        
        let savedCity = DataManager.shared.city(name: city.name, continent: city.continent, abbreviation: city.abbreviation)
        
        selectedCities.append(savedCity)
        
        DataManager.shared.save()
        
        selectedCities = DataManager.shared.cities()
    
        tableview.reloadData()
    }
    
    func getTime(idCity:String,idContinent:String)->String {
        let currentDate = Date()
        let format = DateFormatter()
        format.timeZone = TimeZone(identifier: "\(idContinent)/\(idCity)")
        format.dateFormat = "HH:mm"
        let dateString = format.string(from: currentDate)
        return dateString
    }
}

extension GlobalTimeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        
        let city = selectedCities[indexPath.row]
        let currentTime = getTime(idCity: city.continent!, idContinent: city.name!)
        
        cell.cityLabel.text = city.name
        cell.abbreviationLabel.text = "Сегодня," + city.abbreviation!
        cell.timeLabel.text = currentTime
        
 
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let city = selectedCities[indexPath.row]
            DataManager.shared.persistentContainer.viewContext.delete(city)
              selectedCities.remove(at: indexPath.row)
              tableview.deleteRows(at: [indexPath], with: .fade)
            DataManager.shared.save()
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = selectedCities[sourceIndexPath.row]
        selectedCities.remove(at: sourceIndexPath.row)
        selectedCities.insert(itemToMove, at: destinationIndexPath.row)
    }
  
    
}
