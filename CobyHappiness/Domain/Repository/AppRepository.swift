//
//  AppRepository.swift
//  CobyHappiness
//
//  Created by Coby on 6/25/24.
//

import Foundation

protocol AppRepository {
    
    // Memory
    func getMemoryById(id: UUID) async throws -> MemoryModel
    func getMemories() async throws -> [MemoryModel]
    func saveMemory(memory: MemoryModel) async throws
    func removeMemory(memory: MemoryModel) async throws
    
    // Bunch
    func getBunchById(id: UUID) async throws -> BunchModel
    func getBunches() async throws -> [BunchModel]
    func saveBunch(bunch: BunchModel) async throws
    func removeBunch(bunch: BunchModel) async throws
}
