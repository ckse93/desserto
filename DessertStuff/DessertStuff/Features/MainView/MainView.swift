//
//  ContentView.swift
//  DessertStuff
//
//  Created by Chan Jung on 6/13/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    private let layout = [GridItem(.adaptive(minimum: ScreenDimension.width * 0.4))]
    
    var body: some View {
        VStack {
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
                    LazyVGrid(columns: layout) {
                        ForEach(viewModel.mealList, id: \.self) { meal in

                            Button {
                                viewModel.updateSelectedMealDetail(by: meal.idMeal)
                            } label: {
                                MealTileView(meal: meal)
                                    .padding(.bottom, Constants.paddingMedium)
                                    .frame(width: ScreenDimension.width * 0.4,
                                           height: ScreenDimension.height * 0.25)
                            }

                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showDetailView, content: {
            MealDetailView(viewModel: MealDetailViewModel(mealDetail: viewModel.selectedMealDetail!))
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
