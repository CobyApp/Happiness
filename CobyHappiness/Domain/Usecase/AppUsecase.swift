//
//  AppUsecase.swift
//  CobyHappiness
//
//  Created by Coby on 6/26/24.
//

import UIKit

final class AppUsecase {
    
    private let repository: AppRepository
    
    init(_ repository: AppRepository) {
        self.repository = repository
    }
    
    func getMemory(id: UUID) async throws -> MemoryModel {
        do {
            return try await self.repository.getMemory(id: id).toMemoryModel()
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
    
    func saveMemory(request: SaveMemoryRequest) async throws {
        do {
            return try await self.repository.saveMemory(request: request)
        } catch(let error) {
            throw error
        }
    }
    
    func deleteMemory(id: UUID) async throws {
        do {
            return try await self.repository.deleteMemory(id: id)
        } catch(let error) {
            throw error
        }
    }
    
    func getBunch(id: UUID) async throws -> BunchModel {
        do {
            return try await self.repository.getBunch(id: id).toBunchModel()
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
    
    func saveBunch(request: SaveBunchRequest) async throws {
        do {
            return try await self.repository.saveBunch(request: request)
        } catch(let error) {
            throw error
        }
    }
    
    func deleteBunch(id: UUID) async throws {
        do {
            return try await self.repository.deleteBunch(id: id)
        } catch(let error) {
            throw error
        }
    }
}

extension AppUsecase {
    private func compressImage(_ image: UIImage) -> Data? {
        let newSize = CGSize(width: image.size.width * 0.3, height: image.size.height * 0.3)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let compressedImageData = compressedImage?.jpegData(compressionQuality: 0.3) {
            return compressedImageData
        } else {
            return nil
        }
    }
}
