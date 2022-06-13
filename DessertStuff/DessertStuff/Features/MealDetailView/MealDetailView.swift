//
//  MealDetailView.swift
//  DessertStuff
//
//  Created by Chan Jung on 6/13/22.
//

import SwiftUI

final class MealDetailViewModel: ObservableObject {
    let mealDetail: MealDetail
    
    init(mealDetail: MealDetail) {
        self.mealDetail = mealDetail
    }
}

struct MealDetailView: View {
    let viewModel: MealDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let url = viewModel.mealDetail.imgUrl {
                    HStack {
                        Spacer()
                        AsyncImage(url: url) { img in
                            img
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 5))
                        } placeholder: {
                            ProgressView()
                        }
                        Spacer()
                    }
                    .padding(.top)

                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                        .opacity(0.3)
                }
                
                Text(viewModel.mealDetail.mealName)
                    .font(.title)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading) {
                    Text("INGREDIANTE")
                        .font(.title2)
                        .padding(.bottom)
                    ForEach(viewModel.mealDetail.ingredientMeasureList, id: \.self) { ingrMeasure in
                        HStack {
                            Text(ingrMeasure.ingredient)
                                .font(.callout)
                            Text(": ")
                            Text(ingrMeasure.measure)
                                .font(.callout)
                            Spacer()
                        }
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            Color.orange,
                            lineWidth: 2
                        )
                }
                VStack(alignment: .leading) {
                    Text("INSTRUCT-O")
                        .fontWeight(.bold)
                        .padding()
                    
                    Text(viewModel.mealDetail.mealInst)
                        .fontWeight(.light)
                        .padding()
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            Color.orange,
                            lineWidth: 2
                        )
                }
                
                
            }
            .padding()
        }
    }
}
