//
//  GalleryViewController.swift
//  DishwasherApp
//
//  Created by Matt Harding on 24/01/2017.
//  Copyright © 2017 Mobile Sandpit LTD. All rights reserved.
//

import UIKit
import Kingfisher

class ImageViewController: UIViewController {
    
    var imageURL: URL? = nil { didSet {
        guard oldValue != imageURL else {
            return
        }
        
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.1))])
        }
    }
    
    let imageView = UIImageView()
    
    override func loadView() {
        super.loadView()
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = view.bounds.size
        
        view.addSubview(imageView)
    }
}

class GalleryViewController: UIPageViewController {
    
    var imageURLs: [URL]? { didSet {

        reloadViewControllers()
        } }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func reloadViewControllers() {
        
        guard let url = imageURLs?.first else {
            setViewControllers(nil, direction: .forward, animated: false, completion: nil)
            return
        }
        
        let imageViewController = ImageViewController()
        imageViewController.imageURL = url
        setViewControllers([imageViewController], direction: .forward, animated: false, completion: nil)
    }
}

// MARK:- UIPageViewControllerDataSource

extension GalleryViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(from: viewController, withIndexModifier: -1)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
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
