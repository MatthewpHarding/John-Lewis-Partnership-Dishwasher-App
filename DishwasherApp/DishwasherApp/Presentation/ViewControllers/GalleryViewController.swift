//
//  GalleryViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 24/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit

class GalleryViewController: UIPageViewController {
    
    var imageURLs: [URL]? { didSet {

        reloadViewControllers()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        setupPageControl()
    }
    
    private func setupPageControl() {
        
        let pageControlAppearance = UIPageControl.appearance(whenContainedInInstancesOf: [GalleryViewController.self])
        pageControlAppearance.pageIndicatorTintColor = UIColor.lightGray
        pageControlAppearance.currentPageIndicatorTintColor = UIColor.darkGray
    }
    
    private func reloadViewControllers() {
        
        guard let url = imageURLs?.first else {
            return
        }
        
        let imageViewController = ImageViewController()
        imageViewController.imageURL = url
        setViewControllers([imageViewController], direction: .forward, animated: false, completion: nil)
    }
}

// MARK:- UIPageViewControllerDataSource

extension GalleryViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return imageURLs?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nextViewController(from: viewController, withIndexModifier: -1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return nextViewController(from: viewController, withIndexModifier: +1)
    }
    
    private func nextViewController( from viewController: UIViewController, withIndexModifier indexModifier: Int) -> UIViewController? {
        
        guard
            let imageURLs = self.imageURLs,
            let previousViewController = viewController as? ImageViewController,
            let imageURL = previousViewController.imageURL,
            let index = imageURLs.index(where: { $0 == imageURL }),
            let nextImageURL = imageURLs[safe: index + indexModifier]
            else {
                return nil
        }
        
        let imageViewController = ImageViewController()
        imageViewController.imageURL = nextImageURL
        return imageViewController
    }
}
