//
//  UserModel.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 21/3/2023.
//

import Foundation



struct UserModel :Codable {
    
     var id : String?
     var name: String?
     var email: String?
     var password: String?
     var genders: String?
     var birthdate: String?
     var adresse: String?
     var role: String?
     var firstname: String?
     var lastname: String?
     var specialite: String?
     var experience: String?
     var patient: String?
     var description: String?
    
    init(id: String? = nil, name: String? = nil, email: String? = nil, password: String? = nil, genders: String? = nil, birthdate: String? = nil, adresse: String? = nil, role: String? = nil, firstname: String? = nil, lastname: String? = nil, specialite: String? = nil, experience: String? = nil, patient: String? = nil, description: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.genders = genders
        self.birthdate = birthdate
        self.adresse = adresse
        self.role = role
        self.firstname = firstname
        self.lastname = lastname
        self.specialite = specialite
        self.experience = experience
        self.patient = patient
        self.description = description
    }
    
    init(email: String, password: String)
    {
        self.email = email
        self.password =  password
    }
    
    init(name: String,email: String, password: String)
    {
        self.name = name
        self.email = email
        self.password =  password
    }
}
