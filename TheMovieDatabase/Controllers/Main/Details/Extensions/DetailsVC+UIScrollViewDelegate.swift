//
//  DetailsVC+UIScrollViewDelegate.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 22.02.2023.
//

import UIKit

extension DetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.mainScrollView else { return }
        
        let viewWidth = self.view.bounds.width
        let initialImageHeight = viewWidth * 1.1
        let scrollPositionY = initialImageHeight + (scrollView.contentOffset.y - initialImageHeight)
                        
        if scrollPositionY > 0 {
            UIView.animate(withDuration: 0.3) {
                self.posterImageView.frame = CGRect(x: 0, y: 0,
                                                    width: viewWidth, height: 150)
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.posterImageView.frame = CGRect(x: 0, y: 0,
                                                    width: viewWidth, height: initialImageHeight)
                self.view.layoutIfNeeded()
            }
        }
    }
}
