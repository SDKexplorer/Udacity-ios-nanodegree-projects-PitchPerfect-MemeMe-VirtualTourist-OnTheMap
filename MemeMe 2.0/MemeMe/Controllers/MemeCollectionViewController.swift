//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Marius Chelariu on 01/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation

import UIKit

class MemeCollectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RefreshDataProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var collectionViewData: [Meme]!
    
    // MARK: - Lifecycle Hooks
    override func viewWillAppear(_ animated: Bool) {
        collectionViewData = MemeService.instance.getItems()
        collectionView.delegate = self
        collectionView.dataSource = self
        subscribeToRefresh()
        RefreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromRefresh()
    }
    
    func subscribeToRefresh(){
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshData), name:NSNotification.Name(rawValue: "updateParent"), object: nil)
    }
    
    func unsubscribeFromRefresh(){
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "updateParent"), object: nil)
    }
    
    @objc func RefreshData() {
        collectionViewData = MemeService.instance.getItems()
        collectionView.reloadData()
    }
    
    // MARK: - CollectionView Inherited methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.memeCollectionViewCellIdentifier, for: indexPath) as! MemeCollectionViewCell
        cell.setupCell(collectionViewData[indexPath.row])
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let img = collectionViewData[indexPath.row].memedImage;
        performSegue(withIdentifier: Segues.memeDisplayFromCollection, sender:img)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.memeDisplayFromCollection {
            let viewController = segue.destination as! MemeDisplayViewController
            viewController.image = sender as? UIImage
        }
    }
    
    
    

}
