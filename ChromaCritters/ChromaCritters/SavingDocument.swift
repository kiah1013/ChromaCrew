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
            // automatically save data when lines are added/changed
            saveLines()
        }
    }
    
    func loadLines() {
        if FileManager.default.fileExists(atPath: linesURL.path),
           let data = try? Data(contentsOf: linesURL) {
            
            let decoder = JSONDecoder()
            do {
                let lines = try decoder.decode([Line].self, from: data)
                self.lines = lines
            } catch {
                print("decoding error \(error)")
            }
        }
    }
    
    func saveLines() {
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(lines)
        
        do {
            try data?.write(to: linesURL)
        } catch {
            print("error saving \(error)")
        }
    }
    
    var linesURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        // final url
        return documentsDirectory.appendingPathComponent("Document").appendingPathExtension("json")
    }
}
