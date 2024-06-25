//
//  AppRepository.swift
//  CobyHappiness
//
//  Created by Coby on 6/25/24.
//

import Foundation

protocol AppRepository {
    
    // Memory
    func getMemories() async throws -> [Memory]
    func saveMemory(memory: Memory) async throws
    func removeMemory(memory: Memory) async throws
    
    // Bunch
    func getBunches() async throws -> [Bunch]
    func saveBunch(bunch: Bunch) async throws
    func removeBunch(bunch: Bunch) async throws
}
