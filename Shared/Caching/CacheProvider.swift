import Foundation

protocol CacheImplementation {
    func get<T: Codable>(_ key: String) throws -> T?
    func set<T: Codable>(_ key: String, to: T) throws
}

struct FileCache: CacheImplementation {
    func get<T>(_ key: String) throws -> T? where T : Decodable, T : Encodable {
        let path = filePath(forKey: key)
        guard let fileContents = FileManager.default.contents(atPath: path) else {
            return nil
        }

        return try JSONDecoder().decode(T.self, from: fileContents)
    }

    func set<T>(_ key: String, to newValue: T) throws where T : Decodable, T : Encodable {
        let url = fileUrl(forKey: key)
        try JSONEncoder().encode(newValue).write(to: url)
    }

    private func filePath(forKey key: String) -> String {
        fileUrl(forKey: key).path
    }

    private func fileUrl(forKey key: String) -> URL {
        cacheDirectory
            .appendingPathComponent("episode-cache")
            .appendingPathExtension("\(key).json")
    }

    private var cacheDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
