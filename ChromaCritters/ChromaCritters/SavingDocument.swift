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
            // save data when lines change
            saveLines()
        }
    }
    
    //load the lines/data automatically
    init(animalPictureName: String) {
        self.animalPictureName = animalPictureName
        
        if FileManager.default.fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url) {
            
            let decoder = JSONDecoder()
            do {
                let lines = try decoder.decode([Line].self, from: data)
                self.lines = lines
                //self.animalPictureName = animalPictureName
            } catch {
                print("decoding error \(error)")
            }
        }
    }
    
    func saveLines() {
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(lines)
        
        do {
            try data?.write(to: url)
        } catch {
            print("error saving \(error)")
        }
    }
    
    var animalPictureName: String
    var url: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        // final url
        return documentsDirectory.appendingPathComponent(animalPictureName).appendingPathExtension("json")
        
    }
}
