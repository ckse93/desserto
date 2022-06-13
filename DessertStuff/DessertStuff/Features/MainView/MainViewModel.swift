//
//  MainViewModel.swift
//  DessertStuff
//
//  Created by Chan Jung on 6/13/22.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    let networkMgr: NetworkManager = NetworkManager.shared
    @Published var mealList: [Meal] = []
    @Published var isError: Bool = false
    
    @Published var selectedMealId: String = ""
    @Published var selectedMealDetail: MealDetail?
    @Published var showDetailView: Bool = false
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        networkMgr.$dessert
            .receive(on: DispatchQueue.main)
            .sink { dessert in
                guard let dessert = dessert else {
                    return
                }
                self.mealList = dessert.meals
                self.isError = false
                print("successfully fetched, dessert: \(dessert)")
            }.store(in: &cancellable)
    }
    
    @MainActor
    func fetchMealList() async {
        self.isError = false
        do {
            try await networkMgr.fetchDessert()
        } catch(let mgrError) {
            print("mgr error: \(mgrError.localizedDescription)")
            self.isError = true
        }
    }
    
    @MainActor
    func updateSelectedMealDetail(by id: String) async {
        let detail = try? await networkMgr.fetchMealDetailById(id: id)
        
        if let detail = detail {
            self.selectedMealDetail = detail
            self.showDetailView = true
        }
    }
}
