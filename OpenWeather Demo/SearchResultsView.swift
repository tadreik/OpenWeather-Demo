//
//  SearchResultsView.swift
//  OpenWeather Demo
//
//  Created by Tadreik Campbell on 6/2/23.
//

import SwiftUI

struct SearchResultsView: View {
    
    @ObservedObject var viewModel: SearchResultsViewModel<OpenWeatherLocationFetcher, OpenWeatherFetcher>
    
    var body: some View {
        List(viewModel.results) { result in
            ResultView(result: result)
        }
    }
}

struct ResultView: View {
    
    var result: SearchResult
    
    @State private var image: UIImage = UIImage()
    
    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: 100, height: 100)
            Text(result.location.name ?? "")
                .bold()
            Spacer()
            Text("\(result.weather.main?.temp ?? 0)")
        }
        .task {
            if let icon = result.weather.weather?.first?.icon {
                let image = await ImageFetcher.fetchImage(named:  icon)
                await MainActor.run {
                    self.image = image
                }
            }
        }
    }
}