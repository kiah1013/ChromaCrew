//
//  SavingDocument.swift
//  Demo1
//
//  Created by Krisma Antonio on 10/14/23.
//

import Foundation

class SavingDocument: ObservableObject {
    
    @Published var lines = [Line]() {
        didSet{
            // automatically save data when lines change
            saveColoringPages()
        }
    }
    
    func loadColoringPages() {
        if FileManager.default.fileExists(atPath: getColoringPagesURL.path),
           let data = try? Data(contentsOf: getColoringPagesURL) {
            
            let decoder = JSONDecoder()
            do {
                let lines = try decoder.decode([Line].self, from: data)
                self.lines = lines
            } catch {
                print("decoding error \(error)")
            }
        }
    }
    
    func saveColoringPages() {
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(lines)
        
        do {
            try data?.write(to: getColoringPagesURL)
        } catch {
            print("error saving \(error)")
        }
    }
    
    var getColoringPagesURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        // final url
        return documentsDirectory.appendingPathComponent("Document").appendingPathExtension("json")
    }
}
