//
//  AppUsecase.swift
//  CobyHappiness
//
//  Created by Coby on 6/26/24.
//

import Foundation

final class AppUsecase {
    
    private let repository: AppRepository
    
    init(_ repository: AppRepository) {
        self.repository = repository
    }
    
    func getMemoryById(id: UUID) async throws -> MemoryModel {
        do {
            return try await self.repository.getMemoryById(id: id)
        } catch(let error) {
            throw error
        }
    }
    
    func getMemories() async throws -> [MemoryModel] {
        do {
            return try await self.repository.getMemories()
        } catch(let error) {
            throw error
        }
    }
    
    func saveMemory(memory: MemoryModel) async throws {
        do {
            return try await self.repository.saveMemory(memory: memory)
        } catch(let error) {
            throw error
        }
    }
    
    func removeMemory(memory: MemoryModel) async throws {
        do {
            return try await self.repository.removeMemory(memory: memory)
        } catch(let error) {
            throw error
        }
    }
    
    func getBunchById(id: UUID) async throws -> BunchModel {
        do {
            return try await self.repository.getBunchById(id: id)
        } catch(let error) {
            throw error
        }
    }
    
    func getBunches() async throws -> [BunchModel] {
        do {
            return try await self.repository.getBunches()
        } catch(let error) {
            throw error
        }
    }
    
    func saveBunch(bunch: BunchModel) async throws {
        do {
            return try await self.repository.saveBunch(bunch: bunch)
        } catch(let error) {
            throw error
        }
    }
    
    func removeBunch(bunch: BunchModel) async throws {
        do {
            return try await self.repository.removeBunch(bunch: bunch)
        } catch(let error) {
            throw error
        }
    }
}
