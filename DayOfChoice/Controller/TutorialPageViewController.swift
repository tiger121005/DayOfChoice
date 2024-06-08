//
//  TutorialPageViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/09.
//

import UIKit

class TutorialPageViewController: UIPageViewController {
    
    var controllers: [UIViewController] = []
    
//    var pageControl: UIPageControl!
    
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageView()
    }
    
    func setupPageView() {
        let firstVC = storyboard!.instantiateViewController(withIdentifier: "firstTutorial") as! FirstTutorialViewController
        let secondVC = storyboard!.instantiateViewController(withIdentifier: "secondTutorial") as! SecondTutorialViewController
        let thirdVC = storyboard!.instantiateViewController(withIdentifier: "thirdTutorial") as! ThirdTutorialViewController
        
        // インスタンス化したViewControllerを配列に追加
        self.controllers = [firstVC, secondVC, thirdVC]

        // 最初に表示するViewControllerを指定する
        setViewControllers([self.controllers[0]],
                            direction: .forward,
                            animated: true,
                            completion: nil)

        // PageViewControllerのDataSourceとの関連付け
        self.dataSource = self
        
//        pageControl = UIPageControl(frame: CGRect(x: (self.view.frame.width / 2) - 30, y: self.view.frame.height - 70, width: 120, height: 30))
//        pageControl.backgroundColor = .lightGray
//        pageControl.currentPageIndicatorTintColor = .black
//        
//        pageControl.layer.cornerRadius = 15
//        pageControl.layer.cornerCurve = .continuous
//        
//        // PageControlするページ数を設定する.
//        pageControl.numberOfPages = controllers.count
//        
//        // 現在ページを設定する.
//        pageControl.currentPage = 0
//        pageControl.isUserInteractionEnabled = false
//        self.view.addSubview(pageControl)
    }

}

extension TutorialPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }
    //左にスワイプ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = self.controllers.firstIndex(of: viewController), index > 0 {
//            pageControl.currentPage = index
            return self.controllers[index - 1]
        } else {
            return nil
        }
        
    }
    
    //右にスワイプ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = self.controllers.firstIndex(of: viewController), index < self.controllers.count - 1 {
//            pageControl.currentPage = index
            return self.controllers[index + 1]
        } else {
            return nil
        }
        
    }
    
    //viewが変更された時
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed, let currentVC = pageViewController.viewControllers?.first, let index = self.controllers.firstIndex(of: currentVC) {
//            pageControl.currentPage = index
//        }
    }
    
}
