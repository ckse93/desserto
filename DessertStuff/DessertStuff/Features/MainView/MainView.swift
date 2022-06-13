//
//  ContentView.swift
//  DessertStuff
//
//  Created by Chan Jung on 6/13/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.isError {
                VStack {
                    Spacer ()
                    
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .opacity(0.3)
                    
                    Text("Error while fetching data")
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.mealList, id: \.self) { meal in
                            Button {
                                viewModel.selectedMealId = meal.idMeal
                            } label: {
                                HStack {
                                    AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                    
                                    Text(meal.strMeal)
                                        .padding(.leading)
                                    
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .padding(.horizontal)
                                }
                                .padding(.leading)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showDetailView, content: {
            MealDetailView(viewModel: MealDetailViewModel(mealDetail: viewModel.selectedMealDetail!))
        })
        .onChange(of: viewModel.selectedMealId, perform: { selectedMealId in
            Task {
                await viewModel.updateSelectedMealDetail(by: selectedMealId)
            }
        })
        .task {
            await viewModel.fetchMealList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}

struct MealTileView: View {
    let meal: Meal
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                image
                    .centerCropped()
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .clipShape(Circle())
//                    .shadow(radius: 10)
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(meal.strMeal)
                                .fontWeight(.light)
                        }
                        .tint(Color.white)
                        
                        Spacer()
                    }
                    .padding(.leading, Constants.paddingMedium)
                    .padding(Constants.paddingSmall)
                    .frame(width: geo.size.width)
                    .background(
                        .ultraThinMaterial
                    )
                    
                }
            }
        }
        .cornerRadius(Constants.cornerlarge)
        .shadow(radius: Constants.shadowSmall)
    }
}
