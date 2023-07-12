//
//  SettingsView.swift
//  RickAndMortyApp
//
//  Created by João Alexandre Bitar on 21/03/23.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    
    let viewModel: SettingsViewViewModel
    
    // MARK: - Init
    
    init(viewModel: SettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(8)
                        .listRowSeparator(.hidden)
                }
                
                Text(viewModel.title)
                    .padding(.leading, 10)
                
                Spacer()
            }
            .padding(10)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: .init(cellViewModels: SettingsOption.allCases.compactMap({
            return SettingsCellViewModel(type: $0) { option in

            }
        })))
    }
}
