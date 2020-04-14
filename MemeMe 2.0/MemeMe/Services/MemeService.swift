//
//  MemeService.swift
//  MemeMe
//
//  Created by Marius Chelariu on 01/04/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import Foundation
import UIKit

class MemeService {
    
    private var data: [Meme]!
    static let instance = MemeService()
    
    
    private init() {
        data = [Meme]()
    }
    
    func addItem(_ item: Meme){
        data.append(item)
    }
    
    func removeItem(_ index: Int){
        data.remove(at: index);
    }
    
    func updateItem(_ item: Meme, index: Int){
        data[index] = item
    }
    
    func getItems() -> [Meme] {
        return data;
    }
    
    func setData(_ items: [Meme]){
        data = items;
    }
    
}
