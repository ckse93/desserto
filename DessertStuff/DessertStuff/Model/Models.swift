//
//  Models.swift
//  DessertStuff
//
//  Created by Chan Jung on 6/13/22.
//

import Foundation

// MARK: - Dessert
struct Dessert: Codable {
    let meals: [Meal]
}

// MARK: - Meal
struct Meal: Codable, Hashable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

// MARK: - MeadDetail
/// fetched by idMeal
struct MealDetail: Codable {
    let meals: [[String: String?]]
}

struct IngrMeasure: Hashable { // this could have been a tuple smh
    let ingredient: String
    let measure: String
}

extension MealDetail {
    var imgUrl: URL? {
        guard let meal = self.meals.first else { return nil }
        guard let strUrl = meal[DictKey.strMealThumbImg.rawValue] ?? nil else { return nil }
        return URL(string: strUrl)
    }
    
    var mealName: String {
        guard let meal = self.meals.first else { return "" }
        guard let mealName = meal[DictKey.strMeal.rawValue] ?? nil else { return "" }
        return mealName
    }
    
    var mealInst: String {
        guard let meal = self.meals.first else { return "" }
        guard let instruction = meal[DictKey.strInstructions.rawValue] ?? nil else { return "" }
        return instruction
    }
    
    var ingredientMeasureList: [IngrMeasure] {
        var list: [IngrMeasure] = []
        
        for i in 1...20 {  // ranges from 1 thru 20
            if let tuple = findIngrAndMeasure(at: i), !tuple.measure.isEmpty, !tuple.ingr.isEmpty {
                list.append(IngrMeasure(ingredient: tuple.ingr, measure: tuple.measure))
            }
        }
        
        return list
    }
    
    private func findIngrAndMeasure(at index: Int) -> (ingr: String, measure: String)? {
        guard let meal = meals.first else { return nil }
        
        let ingrKey: String = "strIngredient\(index)"
        let ingrValue: String? = meal[ingrKey] ?? nil
        let measureKey: String = "strMeasure\(index)"
        let measureValue: String? = (meal[measureKey] ?? nil) ?? nil
        
        guard let ingr = ingrValue, let measure = measureValue else {
            return nil
        }
        
        return (ingr, measure)
    }
}

enum DictKey: String, CaseIterable {
    case strMeal = "strMeal"
    case strArea = "strArea"
    case strInstructions = "strInstructions"
    case strMealThumbImg = "strMealThumb"
    case strYoutubeLink = "strYoutube"
    case strSource = "strSource"
}
