//
//  WatchLaterViewController.swift
//  CourseProject
//
//  Created by Дмитрий Куприенко on 21.12.2021.
//

import UIKit

class WatchLaterViewController: UIViewController {
    
    @IBOutlet weak var watchLaterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchLaterCollectionView.register(UINib(nibName: "WatchLaterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WatchLaterCollectionViewCell")
    }

}

extension WatchLaterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let watchLaterCell = watchLaterCollectionView.dequeueReusableCell(withReuseIdentifier: "WatchLaterCollectionViewCell", for: indexPath) as? WatchLaterCollectionViewCell else { return UICollectionViewCell() }
        
        watchLaterCell.configureCell()
        
        return watchLaterCell
    }
    
    
}
