//
//  EditMemoryViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

final class EditMemoryViewModel: ObservableObject {
    
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    private let usecase: AppUsecase
    
    init(usecase: AppUsecase = AppUsecase(AppRepositoryImpl())) {
        self.usecase = usecase
    }
    
    func appendMemory(memory: MemoryModel) {
        Task {
            do {
                try await self.usecase.saveMemory(memory: memory)
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
