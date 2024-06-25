//
//  MapViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

final class MapViewModel: ObservableObject {
    
    @Published private(set) var isError: Bool = false
    @Published private(set) var errorMessage: String = ""
    
    @Published private(set) var memories: [MemoryModel] = []
    
    private let usecase: AppUsecase
    
    init(usecase: AppUsecase = AppUsecase(AppRepositoryImpl())) {
        self.usecase = usecase
        self.getMemories()
    }
    
    @MainActor
    func showErrorMessage(_ message: String) async {
        self.isError = true
        self.errorMessage = message
    }
    
    func getMemories() {
        Task {
            do {
                let memories = try await self.usecase.getMemories()
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.memories = memories
                }
            } catch(let error) {
                await self.showErrorMessage(error.localizedDescription)
            }
        }
    }
}
