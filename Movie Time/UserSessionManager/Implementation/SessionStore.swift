//
//  SessionStore.swift
//  Movie Time
//
//  Created by Arpit Singh on 28/01/23.
//
import Combine
import Foundation
import LocalAuthentication

class SessionStore: SessionManager {
    
    // MARK: - Properties
    private var task = Set<AnyCancellable>()
    private let encoder: UserDataEncoding
    private let dataLayer: UserDataLayer
    private let context: LAContext
    
    
    // MARK: - Methods
    init(encoder: UserDataEncoding,
         context: LAContext,
         dataLayer: UserDataLayer) {
        self.encoder = encoder
        self.dataLayer = dataLayer
        self.context = context
    }
    
    func createUserSession(info: UserAuth) -> AnyPublisher<Session, Error> {
        dataLayer
        .login(user: info)
        .subscribe(on: DispatchQueue.global())
        .tryMap({ (userSession: UserSession) -> Session in
            let session = try self.generateSessionFor(user: userSession)
            return session
        })
        .eraseToAnyPublisher()
    }
    
    
    func getUserSession() -> AnyPublisher<Session?, Error> {
        Future { promise in
            self.context.localizedReason = StringResource.biometricAuthMessage

                do {
                    let keyQuery = KeyQuery(context: self.context)
                    if let data = try KeyStore.findItem(query: keyQuery) {
                        let session = self.encoder.decode(data: data)
                        promise(.success(session))
                    } else {
                        promise(.success(nil))
                    }
                } catch {
                    promise(.failure(error))
                }
            
        }
        .subscribe(on: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    
    func signUp(user: RegisterUser) -> AnyPublisher<Session, Error> {
        dataLayer
        .create(user: user)
        .subscribe(on: DispatchQueue.global())
        .tryMap({ (userSession: UserSession) -> Session in
            let session = try self.generateSessionFor(user: userSession)
            return session
        })
        .eraseToAnyPublisher()
    }
    
    func clearUserSession() -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                let keyItem = KeyItem()
                try KeyStore.delete(item: keyItem)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .subscribe(on: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    private func generateSessionFor(user: UserSession) throws -> Session {
        let session = Session(user: user, sessionCreated: Date().timeIntervalSince1970)
        guard let data = encoder.encode(userData: session) else { throw SessionStoreError.encodingFailed }
        let keyItem = KeyItemWithData(data: data, context: context)
        try KeyStore.save(item: keyItem)
        return session
    }
}

extension SessionStore {
    /// Factory for instance of user session manager
    static func sessionManagerFactory() -> SessionManager {
        let encoder = UserDataCoder()
        let fileStore = FileUserSessionStore()
        let context = LAContext()
        return SessionStore(encoder: encoder,
                            context: context,
                            dataLayer: fileStore)
    }
}

/// Handling Error
fileprivate enum SessionStoreError: LocalError {
    case encodingFailed
    
    var localizedDescription: String {
        switch self {
          case .encodingFailed:
             return StringResource.sessionError
        }
    }
}
