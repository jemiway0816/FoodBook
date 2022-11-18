//
//  Restaurants.swift
//  FoodBook
//
//  Created by CHUN-CHIEH LU on 2022/10/23.
//

import Foundation

struct Restaurant :Codable {
    
    var id:String
    var name:String
    var description:String
    var add:String
    var zipcode:String
    var region:String
    var town:String
    var tel:String
    var openTime:String
    var website:String
    var picture1:String
    var picDescribe1:String
    var picture2:String
    var picDescribe2:String
    var picture3:String
    var picDescribe3:String
    var px:Double
    var py:Double
    var classLevel:String
    var map:String
    var parkingInfo:String
    var date:String
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func readFavFromFile() -> [Self]? {
        
        let propertyDecoder = PropertyListDecoder()
        let url = Self.documentsDirectory.appendingPathComponent("favRests")
        
        if let data = try? Data(contentsOf: url),
           let favRests = try? propertyDecoder.decode([Self].self, from: data) {
            return favRests
        } else {
            return nil
        }
    }
    
    static func saveToFile(favRest:[Self]) {
        
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(favRest) {
            
            let url = Self.documentsDirectory.appendingPathComponent("favRests")
            
            try? data.write(to: url)
        }
    }
}
