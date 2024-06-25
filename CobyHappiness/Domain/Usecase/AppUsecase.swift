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
    
    func getMemories() async throws -> [Memory] {
        do {
            return try await self.repository.getMemories()
        } catch(let error) {
            throw error
        }
    }
    
    func saveMemory(memory: Memory) async throws {
        do {
            return try await self.repository.saveMemory(memory: memory)
        } catch(let error) {
            throw error
        }
    }
    
    func removeMemory(memory: Memory) async throws {
        do {
            return try await self.repository.removeMemory(memory: memory)
        } catch(let error) {
            throw error
        }
    }
    
    func getBunches() async throws -> [Bunch] {
        do {
            return try await self.repository.getBunches()
        } catch(let error) {
            throw error
        }
    }
    
    func saveBunch(bunch: Bunch) async throws {
        do {
            return try await self.repository.saveBunch(bunch: bunch)
        } catch(let error) {
            throw error
        }
    }
    
    func removeBunch(bunch: Bunch) async throws {
        do {
            return try await self.repository.removeBunch(bunch: bunch)
        } catch(let error) {
            throw error
        }
    }
}
