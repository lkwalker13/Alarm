//
//  GlobalTimeViewController.swift
//  Alarm v.2
//
//  Created by Евгений Лянкэ on 24.05.2022.
//

import UIKit

final class GlobalTimeViewController: UIViewController {
    
    
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
    
    var citiesCV = CititesViewController()
    var selectedCities = [CityData]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        removeCityButton.addTarget(self, action: #selector(removeCityPressed), for: .touchUpInside)
        addCityButton.addTarget(self, action: #selector(addCityPressed), for: .touchUpInside)
        tableview.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        tableview.delegate = self
        tableview.dataSource = self
        selectedCities = DataManager.shared.cities()
        
    }
    
    @objc
    func removeCityPressed() {
        print("removed")
    }
    
    @objc
    func addCityPressed() {
        let citiesVC = CititesViewController()
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
    }
    
    func getSelectedCity(city: CityModel) {
        let savedCity = DataManager.shared.city(name: city.name, continent: city.continent, abbreviation: city.abbreviation)
        selectedCities.append(savedCity)
        DataManager.shared.save()
        selectedCities = DataManager.shared.cities()
        #warning("Также не рефрешится база")
        #warning("Проблема с гит хаб аутентификацией")
        tableview.reloadData()
        
    }
}

extension GlobalTimeViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        let city = selectedCities[indexPath.row]
        cell.cityLabel.text = city.name
        cell.abbreviationLabel.text = "Сегодня," + city.abbreviation!
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
