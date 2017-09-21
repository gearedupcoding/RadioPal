//
//  StationsViewController.swift
//  RadioPal
//
//  Created by Jami, Dheeraj on 9/20/17.
//  Copyright © 2017 Jami, Dheeraj. All rights reserved.
//

import UIKit
import MediaPlayer

protocol StationsViewControllerDelegate : class {
    func clearStations()
}

class StationsViewController: UIViewController {

    var stations = [StationModel]()
    var pageViewController: UIPageViewController
    var streamsVC = [StreamViewController]()
    weak var delegate: StationsViewControllerDelegate?

    init(stations: [StationModel]) {
        self.stations = stations
        var index = 0
        for station in self.stations {
            let streamVC = StreamViewController(station: station)
            streamVC.index = index
            print(station.name)
            self.streamsVC.append(streamVC)
            index += 1
        }
        print(self.stations.count)
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.pageViewController.do {
            $0.dataSource = self
            $0.view.backgroundColor = .green
            if let streamVC = self.streamsVC.first {
                let arr = [streamVC]
                $0.setViewControllers(arr, direction: .forward, animated: true, completion: nil)
            }
            self.addChildViewController($0)
            self.view.addSubview($0.view)
            $0.didMove(toParentViewController: self)
            
            $0.view.snp.makeConstraints({ (make) in
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.left.right.bottom.equalTo(self.view)
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.clearStations()
        self.stations.removeAll()
        self.streamsVC.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension StationsViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.streamsVC.index(of: (viewController as? StreamViewController)!) else {
            return nil
        }
        
        let nextIndex = index + 1
        
        guard self.streamsVC.count != nextIndex else {
            if let firstVC = self.streamsVC.first {
                return firstVC
            }
            return nil
        }
        
        guard  self.streamsVC.count > nextIndex else {
            return nil
        }
        
        return self.streamsVC[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.streamsVC.index(of: (viewController as? StreamViewController)!) else {
            return nil
        }
        
        let prevIndex = index - 1
        
        guard prevIndex >= 0 else {
            if let lastVC = self.streamsVC.last {
                return lastVC
            }
            return nil
        }
        
        guard self.streamsVC.count > prevIndex else {
            return nil
        }
        
        return self.streamsVC[prevIndex]
    }
}
//
//extension StationsViewController: UIPageViewControllerDelegate {
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//
//    }
//}

