//
//  EditBunchViewModel.swift
//  CobyHappiness
//
//  Created by Coby on 6/16/24.
//

import Foundation

final class EditBunchViewModel: ObservableObject {
    
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var memories: [Memory] = []
    
    private let usecase: AppUsecase
    
    init(usecase: AppUsecase = AppUsecase(AppRepositoryImpl())) {
        self.usecase = usecase
        self.getMemories()
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
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.isError = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func saveBunch(bunch: Bunch) {
        Task {
            do {
                try await self.usecase.saveBunch(bunch: bunch)
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
