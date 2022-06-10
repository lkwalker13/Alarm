//
//  TabBarViewController.swift
//  Alarm v.2
//
//  Created by Евгений Лянкэ on 24.05.2022.
//

import UIKit

 final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureView()
        addControllersToTabBar()
        
    }
    
   private func configureView() {
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        tabBar.tintColor = .orange
    }
    
  private  func addControllersToTabBar() {
        let globalTimeVC = createViewControllers(viewcontroller: GlobalTimeVC(), title: Constants.Labels.globalTimeLabel, image:UIImage(named: Constants.Image.globalTimeImage) )
        let alarmVC = createViewControllers(viewcontroller: AlarmViewController(), title: Constants.Labels.alarmLabel, image: UIImage(named: Constants.Image.alarmImage))
        let stopWatchVC = createViewControllers(viewcontroller: StopWatchViewController(), title: Constants.Labels.stopWatchLabel, image: UIImage(named: Constants.Image.stopwatchImage))
        let timerVC = createViewControllers(viewcontroller: TimerViewController(), title: Constants.Labels.timerLabel, image: UIImage(named: Constants.Image.timerImage))
        viewControllers = [globalTimeVC,alarmVC,stopWatchVC,timerVC]
    }
    
    
  fileprivate func createViewControllers(viewcontroller:UIViewController,title:String,image:UIImage?)->UIViewController {
        viewcontroller.tabBarItem.title = title
        viewcontroller.tabBarItem.image = image
        return viewcontroller
    }
    
    
}
