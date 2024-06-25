//
//  BunchDetailViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

final class BunchDetailViewModel: ObservableObject {
    
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    private let usecase: AppUsecase
    
    init(usecase: AppUsecase = AppUsecase(AppRepositoryImpl())) {
        self.usecase = usecase
    }
    
    func removeBunch(bunch: BunchModel) {
        Task {
            do {
                try await self.usecase.removeBunch(bunch: bunch)
            } catch(let error) {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.isError = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
