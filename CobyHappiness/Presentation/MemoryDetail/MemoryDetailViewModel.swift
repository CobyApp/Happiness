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
    
    private let usecase: AppUsecase
    
    init(usecase: AppUsecase = AppUsecase(AppRepositoryImpl())) {
        self.usecase = usecase
    }
    
    @MainActor
    func showErrorMessage(_ message: String) async {
        self.isError = true
        self.errorMessage = message
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
    
    func getMemoryById(id: UUID, completion: @escaping (MemoryModel) -> Void) {
        Task {
            do {
                let memory = try await self.usecase.getMemoryById(id: id)
                await MainActor.run {
                    completion(memory)
                }
            } catch(let error) {
                await self.showErrorMessage(error.localizedDescription)
            }
        }
    }
}
