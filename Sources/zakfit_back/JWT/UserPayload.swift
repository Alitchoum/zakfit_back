//
//  jwt.swift
//  zakfit_back
//
//  Created by alize suchon on 25/11/2025.
//

import Fluent
import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    var id: UUID
    var expiration: Date
    
    func verify(using signer: JWTSigner) throws {
        if self.expiration < Date() {
            throw JWTError.invalidJWK
        }
    }
    init(id: UUID) {
        self.id = id
        self.expiration = Date().addingTimeInterval(60 * 60 * 24 * 7)
    }
}



