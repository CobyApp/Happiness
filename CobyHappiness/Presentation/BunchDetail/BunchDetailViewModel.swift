//
//  BunchDetailViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

final class BunchDetailViewModel: ObservableObject {
    
    @Published private(set) var isError: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    private let usecase: AppUsecase
    
    init(usecase: AppUsecase = AppUsecase(AppRepositoryImpl())) {
        self.usecase = usecase
    }
    
    @MainActor
    func showErrorMessage(_ message: String) async {
        self.isError = true
        self.errorMessage = message
    }
    
    func removeBunch(id: UUID) {
        Task {
            do {
                try await self.usecase.removeBunch(id: id)
            } catch(let error) {
                await self.showErrorMessage(error.localizedDescription)
            }
        }
    }
}
