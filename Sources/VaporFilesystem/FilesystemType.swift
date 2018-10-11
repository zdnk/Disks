import Foundation
import Vapor

public enum FileVisibility {
    case `public`
    case `private`
}

public typealias FileMetadata = [FileMetadataKey: Any]

public protocol FilesystemType {
    
    func has(file: String, options: FileOptions?) -> Future<Bool>
    func read(file: String, options: FileOptions?) -> Future<Data>
    func listContents(of: String, recursive: Bool, options: FileOptions?) -> Future<[String]>
    func metadata(of: String, options: FileOptions?) -> Future<FileMetadata>
    func size(of: String, options: FileOptions?) -> Future<Int>
    func mimetype(of: String, options: FileOptions?) -> Future<String>
    func timestamp(of: String, options: FileOptions?) -> Future<Date>
//    func visibility(of: String, options: FileOptions?) -> Future<FileVisibility>
    func write(data: Data, to: String, options: FileOptions?) -> Future<()>
//    func write(file: String, to: String) -> Future<()>
    func update(data: Data, to: String, options: FileOptions?) -> Future<()>
//    func update(file: String, to: String) -> Future<()>
    func put(data: Data, to: String, options: FileOptions?) -> Future<()>
//    func put(file: String, to: String) -> Future<()>
    func rename(file: String, to: String, options: FileOptions?) -> Future<()>
    func copy(file: String, to: String, options: FileOptions?) -> Future<()>
    func delete(file: String, options: FileOptions?) -> Future<()>
    func delete(directory: String, options: FileOptions?) -> Future<()>
    func create(directory: String, options: FileOptions?) -> Future<()>
//    func setVisibility(of: String, to: FileVisibility, options: FileOptions?) -> Future<()>
    
}

extension FilesystemType {
    
    func has(file: String) -> Future<Bool> {
        return has(file: file, options: nil)
    }
    
    func read(file: String) -> Future<Data> {
        return read(file: file, options: nil)
    }
    
    func listContents(of: String, recursive: Bool) -> Future<[String]> {
        return listContents(of: of, recursive: recursive, options: nil)
    }
    
    func metadata(of: String) -> Future<FileMetadata> {
        return metadata(of: of, options: nil)
    }
    
    func size(of: String) -> Future<Int> {
        return size(of: of, options: nil)
    }
    
    func mimetype(of: String) -> Future<String> {
        return mimetype(of: of, options: nil)
    }
    
    func timestamp(of: String) -> Future<Date> {
        return timestamp(of: of, options: nil)
    }
    
    func write(data: Data, to: String) -> Future<()> {
        return write(data: data, to: to, options: nil)
    }
    
    func update(data: Data, to: String) -> Future<()> {
        return update(data: data, to: to, options: nil)
    }
    
    func put(data: Data, to: String) -> Future<()> {
        return put(data: data, to: to, options: nil)
    }
    
    func rename(file: String, to: String) -> Future<()> {
        return rename(file: file, to: to, options: nil)
    }
    
    func copy(file: String, to: String) -> Future<()> {
        return copy(file: file, to: to, options: nil)
    }
    
    func delete(file: String) -> Future<()> {
        return delete(file: file, options: nil)
    }
    
    func delete(directory: String) -> Future<()> {
        return delete(directory: directory, options: nil)
    }
    
    func create(directory: String) -> Future<()> {
        return create(directory: directory, options: nil)
    }
    
}
