//
//  BunchViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

final class BunchViewModel: ObservableObject {
    
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var bunches: [BunchModel] = []
    
    private let usecase: AppUsecase
    
    init(usecase: AppUsecase = AppUsecase(AppRepositoryImpl())) {
        self.usecase = usecase
        self.getBunches()
    }
    
    func getBunches() {
        Task {
            do {
                let bunches = try await self.usecase.getBunches()
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.bunches = bunches
                }
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
