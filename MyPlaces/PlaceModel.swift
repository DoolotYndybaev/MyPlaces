//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Doolot on 9/8/22.
//

import Foundation

struct Place {
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let restaurantNames = ["Burger Heroes", "Kitchen", "Bonsai", "Дастархан", "X.O", "Sherlock Holmes", "Speak Easy", "Morris Pub", "Love&Life", "Индокитай", "Балкан Гриль", "Вкусные истории", "Классик", "Шок", "Бочка"
    ]
    
    static func getPlaces() -> [Place] {
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Ufa", type: "Restoraunt", image: place))
        }
        return places
    }
    
}
