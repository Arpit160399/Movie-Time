//
//  FileUserSessionStore.swift
//  Movie Time
//
//  Created by Arpit Singh on 28/01/23.
//
import CryptoKit
import Combine
import Foundation
class FileUserSessionStore: UserDataLayer {

    // MARK: - Properties
    /// Set limit to data enters into document.
    private let limit: Int
    /// FilePath
    private let documentPath: URL
    
    //MARK: - Methods
    init(url: URL? = nil,
         limit: Int = 10,
         name: String = "movie_time_user.json") {
        self.limit = limit
        if let url = url {
            documentPath = url
        } else {
            do {
                var url = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                url.append(path: name)
                documentPath = url
            } catch {
                var url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                url.append(path: name)
                documentPath = url
            }
        }
    }
    
    /// To hash user password
    private func hash(data: String) -> String {
        guard let salt = Bundle.main.object(forInfoDictionaryKey: "salt") as? String else { return data }
        let fragments = salt.split(separator: "_")
        let customString = fragments.count > 2 ? "\(fragments[0])\(data)\(fragments[fragments.count - 1])" : data
        guard let dataBuffer = customString.data(using: .utf8) else { return data }
        let digest = SHA256.hash(data: dataBuffer)
        let hash = String(describing: digest).replacingOccurrences(of: "SHA256 digest:",with: "")
        return hash
    }
    
    private func readData<T: Decodable>() throws -> T? {
        if FileManager.default.fileExists(atPath: documentPath.relativePath) {
            let jsonData = try Data(contentsOf: documentPath)
            let decoder = JSONDecoder()
            let jsonObject = try decoder.decode(T.self, from: jsonData)
            return jsonObject
        } else {
            return nil
        }
    }
    
    private func save<T: Encodable>(data: T) throws  {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(data)
        if  FileManager.default.fileExists(atPath: documentPath.relativePath) {
            try jsonData.write(to: documentPath)
        } else {
            if !FileManager.default.createFile(atPath: documentPath.relativePath, contents: jsonData) {
                throw FileSessionStoreError.failedToSave
            }
        }
    }
    
    fileprivate func checkForLimit(_ users: [String: User]) -> [String: User] {
        let size = users.count
        if size > limit {
            let result = users
                         .dropLast(size - limit)
                         .reduce([String : User](), { prevRes,current in
                             var newRes = prevRes
                             newRes[current.key] = current.value
                             return newRes
                         })
            
            return result
        } else {
           return users
        }
    }
    
    func create(user: RegisterUser) -> AnyPublisher<UserSession, Error> {
        Future { promise in
            do {
                var userInfos: [String:User] = try self.checkForLimit(self.readData() ?? [String: User]())
                let userData = User(data: user, password: self.hash(data: user.password))
                if userInfos[userData.email] != nil {
                    promise(.failure(FileSessionStoreError.alreadyUserExist))
                    return
                } else {
                    userInfos[userData.email] = userData
                }
                try self.save(data: userInfos)
                promise(.success(.init(user: userData)))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func login(user: UserAuth) -> AnyPublisher<UserSession, Error> {
        Future {  promise in
            do {
                let password = self.hash(data: user.password)
                let userInfos: [String: User] = try self.readData() ?? [String :User]()
                if let userInfo = userInfos[user.userEmail]  {
                    guard password == userInfo.password else {
                        promise(.failure(FileSessionStoreError.VerificationFailed))
                        return
                    }
                    promise(.success(.init(user: userInfo)))
                } else {
                    promise(.failure(FileSessionStoreError.noUserFound))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
     
}


fileprivate enum FileSessionStoreError: LocalError {
    
    case noUserFound
    case VerificationFailed
    case unknown
    case alreadyUserExist
    case failedToSave
   
    var localizedDescription: String {
        switch self {
        case .unknown:
            return StringResource.unknownErrorMessage
        case .VerificationFailed:
            return StringResource.userValidationError
        case .noUserFound:
            return StringResource.noUserErrorMessage
        case .alreadyUserExist:
            return StringResource.alreadyUserExistError
        case .failedToSave:
            return StringResource.failToSave
        }
    }
}
