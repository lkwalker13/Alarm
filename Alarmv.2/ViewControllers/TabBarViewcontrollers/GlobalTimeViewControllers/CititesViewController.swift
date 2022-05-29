//
//  CititesViewController.swift
//  Alarm v.2
//
//  Created by Евгений Лянкэ on 24.05.2022.
//

import UIKit


final class CititesViewController: UIViewController {
    /// MARK: Properties
    private var titleLabel:UILabel = {
        let title = UILabel()
        title.text = Constants.Labels.chooseCity
        title.font = .systemFont(ofSize: 14)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private var searchTextfield:UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = UIColor(named: Constants.Colors.searchTxtflBCColor)
        textfield.layer.cornerRadius = 6
        textfield.textColor = .white
#warning("Не показывается placeholder")
        textfield.placeholder = Constants.Labels.placeholderTitle
        let image = UIImage(systemName: Constants.Image.searchImage)
        if let image = image {
            let leftImageView =  UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
            leftImageView.image = image
            leftImageView.tintColor = .gray
            textfield.leftView = leftImageView
            textfield.leftViewMode = .always
        }
        textfield.clearButtonMode = .always
        return textfield
    }()
    
    private var cancelButton:UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Labels.cancelLabel, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        return button
    }()
    
    private var tableview:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .darkGray
        return tableView
    }()
    
    var cityModelsArray = [CityModel]()
    var filteredCityModelsArray = [CityModel]()
    var filtered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        cityModelsArray = getCityModelsArray()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.delegate = self
        tableview.dataSource  = self
        searchTextfield.delegate = self
    }
    
    @objc func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func configure() {
        
        view.backgroundColor = UIColor(named: Constants.Colors.darkGray)
        
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            searchTextfield,
            cancelButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 10, left: 20, bottom: 0, right: 20),size: .init(width: 0, height: 33))
        
        view.addSubview(tableview)
        tableview.anchor(top: stackView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,padding: .init(top: 5, left: 20, bottom: 0, right: 20))
        
    }
    
    func  getCityModelsArray()->[CityModel] {
        var citiesArray = [CityModel]()
        let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
        for id in timeZoneIdentifiers {
            let timezone = TimeZone(identifier: id)
            if let timezone = timezone {
                let cityName = timezone.identifier.split(separator: "/").last!
                let continent = timezone.identifier.split(separator: "/").first!
                let abbreviation =  timezone.abbreviation()!
                let completedCity = CityModel(name: String(cityName), continent: String(continent), abbreviation: abbreviation)
                citiesArray.append(completedCity)
            }
            
        }
        return citiesArray
    }
}
// MARK: TableViewMethods
extension CititesViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredCityModelsArray.isEmpty {
            return filteredCityModelsArray.count
        }
        return filtered ? 0:cityModelsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(named: Constants.Colors.darkGray)
        var city = CityModel(name: "", continent: "", abbreviation: "")
        if !filteredCityModelsArray.isEmpty {
            
            city = filteredCityModelsArray[indexPath.row]
        }else {
            
            city = cityModelsArray[indexPath.row]
            
        }
        var content = cell.defaultContentConfiguration()
        content.text = "\(city.name),\(city.continent)"
        content.textProperties.color = .white
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gloabalVC = GlobalTimeViewController()
        let city = cityModelsArray[indexPath.row]
        gloabalVC.getSelectedCity(city: city)
        dismiss(animated: true, completion: nil)
    }
}

extension CititesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if string.count == 0 {
                filterText(String(text.dropLast()))
            } else {
                filterText(text + string)
            }
        }
        return  true
    }
    
    func filterText(_ text:String) {
        filteredCityModelsArray.removeAll()
        for city in cityModelsArray {
            if city.name.lowercased().starts(with: text.lowercased()){
                filteredCityModelsArray.append(city)
            }
        }
        tableview.reloadData()
        filtered = true
    }
}
