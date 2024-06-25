//
//  BunchViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

final class BunchViewModel: ObservableObject {
    
    @Published private(set) var isError: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    @Published private(set) var bunches: [BunchModel] = []
    
    private let usecase: AppUsecase
    
    init(usecase: AppUsecase = AppUsecase(AppRepositoryImpl())) {
        self.usecase = usecase
        self.getBunches()
    }
    
    @MainActor
    func showErrorMessage(_ message: String) async {
        self.isError = true
        self.errorMessage = message
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
                await self.showErrorMessage(error.localizedDescription)
            }
        }
    }
}
