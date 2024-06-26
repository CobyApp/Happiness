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
            return try await self.repository.getMemoryById(id: id).toMemoryModel()
        } catch(let error) {
            throw error
        }
    }
    
    func getMemories() async throws -> [MemoryModel] {
        do {
            return try await self.repository.getMemories().map { $0.toMemoryModel() }
        } catch(let error) {
            throw error
        }
    }
    
    func saveMemory(memory: MemoryModel) async throws {
        do {
            return try await self.repository.saveMemory(memory: memory.toMemory())
        } catch(let error) {
            throw error
        }
    }
    
    func removeMemory(memory: MemoryModel) async throws {
        do {
            return try await self.repository.removeMemory(memory: memory.toMemory())
        } catch(let error) {
            throw error
        }
    }
    
    func getBunchById(id: UUID) async throws -> BunchModel {
        do {
            return try await self.repository.getBunchById(id: id).toBunchModel()
        } catch(let error) {
            throw error
        }
    }
    
    func getBunches() async throws -> [BunchModel] {
        do {
            return try await self.repository.getBunches().map { $0.toBunchModel() }
        } catch(let error) {
            throw error
        }
    }
    
    func saveBunch(bunch: BunchModel) async throws {
        do {
            return try await self.repository.saveBunch(bunch: bunch.toBunch())
        } catch(let error) {
            throw error
        }
    }
    
    func removeBunch(bunch: BunchModel) async throws {
        do {
            return try await self.repository.removeBunch(bunch: bunch.toBunch())
        } catch(let error) {
            throw error
        }
    }
}
