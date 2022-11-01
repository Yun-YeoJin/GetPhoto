//
//  DocumentManager.swift
//  GetPhoto
//
//  Created by 윤여진 on 2022/10/31.
//

import UIKit

class DocumentManager {
    static let shared = DocumentManager()
    
    private init() { }
    
    func documentDirectoryPath() -> URL? {
        
        guard let documentDiretory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDiretory
        
    }
    
    func ImageDirectoryPath() -> URL? {
        
        let imageDirectory = documentDirectoryPath()?.appendingPathComponent("Image")
        return imageDirectory
    }
    
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let imageDirectory = ImageDirectoryPath() else { return }
        
        if FileManager.default.fileExists(atPath: imageDirectory.path) {
            let fileURL = imageDirectory.appendingPathComponent(fileName)
            
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            print(fileURL)
            
            do {
                try data.write(to: fileURL)
            } catch let error {
                print("file save error", error)
            }
            
        } else {
            do {
                try FileManager.default.createDirectory(at: imageDirectory, withIntermediateDirectories: true)
            } catch {
                print("file save error")
            }
            
            let fileURL = imageDirectory.appendingPathComponent(fileName)
            
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            print(fileURL)
            
            do {
                try data.write(to: fileURL)
            } catch let error {
                print("file save error", error)
            }
        }
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage? {
        
        guard let imageDirectory = ImageDirectoryPath() else { return nil }
        let fileURL = imageDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            
            return UIImage(contentsOfFile: fileURL.path)
            
        } else {
            
            return UIImage(systemName: "star.fill")
            
        }
        
    }
}

