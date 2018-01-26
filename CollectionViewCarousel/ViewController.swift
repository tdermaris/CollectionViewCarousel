//
//  ViewController.swift
//  CollectionViewCarousel
//
//  Created by Thomas Dermaris on 25/01/2018.
//  Copyright © 2018 TDermaris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var lastContentOffset: CGPoint?
    var lastOffset:CGFloat = 0.0
    var scrollDirection = "Right"
    
    let cellScaling: CGFloat = 0.75
    let itemSpacing: CGFloat = 25
    var insetX: CGFloat = 0
    
    var photos = [#imageLiteral(resourceName: "photo1"), #imageLiteral(resourceName: "photo2"), #imageLiteral(resourceName: "photo3"), #imageLiteral(resourceName: "photo4"), #imageLiteral(resourceName: "photo5")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling) //floor(screenSize.width - 100) //
        let cellHeight = collectionView.frame.height
        insetX = (view.bounds.width - cellWidth ) / 2.0
        
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX , bottom: 0, right: insetX)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - UICollectionViewDataSource delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as? TutorialCollectionViewCell else {fatalError()}
        cell.collectionImageView.image = photos[indexPath.row]
        
        return cell
    }
    
    
    //MARK: - Scrollview delegate methods
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (lastContentOffset?.x ?? 0) < scrollView.contentOffset.x {
            scrollDirection = "Right"
        }
        else if (lastContentOffset?.x)! > scrollView.contentOffset.x {
            scrollDirection = "Left"
        }
        
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let desirableScrollOffset = insetX + collectionViewLayout.itemSize.width - (view.frame.size.width - collectionViewLayout.itemSize.width - itemSpacing)
        if scrollDirection == "Right" {
            let targetPointX = lastOffset + desirableScrollOffset
            targetContentOffset.pointee = CGPoint(x: targetPointX, y: -scrollView.contentInset.top)
            lastOffset = targetContentOffset.pointee.x + insetX
        } else {
            lastOffset -= 2*insetX
            let targetPointX = lastOffset - desirableScrollOffset
            targetContentOffset.pointee = CGPoint(x: targetPointX, y: -scrollView.contentInset.top)
            lastOffset = targetContentOffset.pointee.x + insetX
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentPage = floor(collectionView.contentOffset.x / (collectionView.frame.size.width - insetX/2)) + 1
        pageControl.currentPage = Int(currentPage)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
