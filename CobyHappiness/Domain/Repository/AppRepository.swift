//
//  AppRepository.swift
//  CobyHappiness
//
//  Created by Coby on 6/25/24.
//

import Foundation

protocol AppRepository {
    
    // Memory
    func getMemory(id: UUID) async throws -> Memory
    func getMemories() async throws -> [Memory]
    func saveMemory(request: SaveMemoryRequest) async throws
    func deleteMemory(id: UUID) async throws
    
    // Bunch
    func getBunch(id: UUID) async throws -> Bunch
    func getBunches() async throws -> [Bunch]
    func saveBunch(request: SaveBunchRequest) async throws
    func deleteBunch(id: UUID) async throws
}
