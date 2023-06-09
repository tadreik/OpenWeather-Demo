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
        LazyVStack {
            if let myWeatherResult = viewModel.myWeatherResult {
                VStack {
                    Text("Weather for current Location")
                        .padding()
                    ResultView(result: myWeatherResult)
                }
                .background {
                    Color(.sRGB, red: 0, green: 0, blue: 1, opacity: 0.2)
                }
                .padding(.top)
            }
            ForEach(viewModel.results) { result in
                Divider()
                ResultView(result: result)
            }
        }
        .padding(.horizontal)
        Spacer()
    }
}

struct ResultView: View {
    
    var result: SearchResult
    
    @State private var image: UIImage = UIImage()
    
    var body: some View {
        HStack {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                Text(result.weather.weather?.first?.description ?? "")
            }
            VStack {
                Text("\(result.location.name ?? ""), \(result.location.country ?? "")")
                    .bold()
                
            }
            Spacer()
            Text("\(result.weather.main?.temp ?? 0) Kelvin")
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
