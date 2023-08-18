
import Foundation

public final class Fly {
    static let root = "fly_db/"

    private let path: String
    private let lock: NSLock = .init()

    public init(name: String, schemaVersion: Int = 1) throws {
        if name.last?.description == "/" {
            self.path = Self.root + name
        } else {
            self.path = Self.root + name + "/"
        }

        try createDirectoryIfDoesNotExist(at: self.path).get()

        let prevSchemaVersion = currentSchemaVersion()

        if prevSchemaVersion != schemaVersion {
            // db clean up
        }
    }

    private func locking<T>(_ operation: () -> T) -> T {
        lock.lock()

        let result = operation()
        lock.unlock()
        return result
    }

    public func transaction<T>(_ operation: () -> Result<T, Error>) -> Result<T, Error> {
        self.locking {
            operation()
            // commit (react etc)
        }
    }

    public func read<FO: FlyingObject>(_ objectType: FO.Type) -> [FO] {
        self.locking {
            guard directoryExist(at: self.path + FO.collection) else {
                return []
            }
            switch contentsofFiles(at: self.path + FO.collection) {
            case .failure:
                return []
            case .success(let contents):
                return contents.map { data in
                    data.decode()
                }.compactMap { $0 }
            }
        }
    }

    public func read<FO: FlyingObject>(_ objectType: FO.Type, pk: any PrimaryKeyType) -> FO? {
        self.locking {
            let filePath = self.path + FO.collection + "/" + pk.raw
            return try? contentsofFile(at: filePath).get().decode()
        }
    }

    public func white<FO: FlyingObject>(objects: some Collection<FO>) -> Result<Void, Error> {
        if self.lock.try() {
            let result: Result<Void, Error> = .failure(FlyingError.writeAttemptOutOfTransactionBlock)
            self.lock.unlock()
            return result
        }
        let collectionPath = self.path + FO.collection + "/"
        return createDirectoryIfDoesNotExist(at: collectionPath).flatMap { _ in
            createFiles(at: collectionPath, with: objects.map { object in
                (object.primaryKey.raw, object.encode())
            })
        }
    }
}
