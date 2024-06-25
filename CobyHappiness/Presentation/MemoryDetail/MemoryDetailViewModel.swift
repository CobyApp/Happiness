//
//  MemoryDetailViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

final class MemoryDetailViewModel: ObservableObject {
    
    @Published private(set) var isError: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    @Published private(set) var memory: MemoryModel
    
    private let usecase: AppUsecase
    
    init(
        usecase: AppUsecase = AppUsecase(AppRepositoryImpl()),
        memory: MemoryModel
    ) {
        self.usecase = usecase
        self.memory = memory
    }
    
    @MainActor
    func showErrorMessage(_ message: String) async {
        self.isError = true
        self.errorMessage = message
    }
    
    func getMemoryById(id: UUID) {
        Task {
            do {
                let memory = try await self.usecase.getMemoryById(id: id)
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.memory = memory
                }
            } catch(let error) {
                await self.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
    func removeMemory(memory: MemoryModel) {
        Task {
            do {
                try await self.usecase.removeMemory(memory: memory)
            } catch(let error) {
                await self.showErrorMessage(error.localizedDescription)
            }
        }
    }
}
