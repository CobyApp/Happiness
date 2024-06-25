//
//  AppRepository.swift
//  CobyHappiness
//
//  Created by Coby on 6/25/24.
//

import Foundation

protocol AppRepository {
    
    // Memory
    func getMemories() async throws -> [MemoryModel]
    func saveMemory(memory: MemoryModel) throws
    func removeMemory(memory: MemoryModel) throws
    
    // Bunch
    func getBunches() async throws -> [BunchModel]
    func saveBunch(bunch: BunchModel) throws
    func removeBunch(bunch: BunchModel) throws
}
