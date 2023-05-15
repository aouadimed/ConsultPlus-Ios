//
//  BookingModel.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 27/4/2023.
//

import Foundation


struct Booking: Codable, Identifiable {
    let id: String?
    let date: String?
    let time: String?
    let status: Int?
    let doctor: String?
    let patient: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date
        case time
        case status = "statu"
        case doctor
        case patient
    }
    
    init(id: String? = nil ,date: String? = nil, time: String? = nil, status: Int? = nil, doctor: String? = nil, patient: String? = nil) {
        self.id = id
        self.date = date
        self.time = time
        self.status = status
        self.doctor = doctor
        self.patient = patient
    }
}

struct Fullnames: Codable, Hashable {
    let id: String
    let firstname: String
    let lastname: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstname
        case lastname
    }

    init(id: String, firstname: String, lastname: String) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
    }
}

struct PatientBooking: Codable, Identifiable, Hashable {
    let id: String
    let date: String
    let time : String
    let status: Int
    let doctor: Fullnames
    let patient: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date
        case time
        case status = "statu"
        case doctor
        case patient
    }

    init(id: String, date: String, time: String, status: Int, doctor: Fullnames, patient: String) {
        self.id = id
        self.date = date
        self.time = time
        self.status = status
        self.doctor = doctor
        self.patient = patient
    }
}


struct DoctorBooking: Codable, Identifiable, Hashable {
    let id: String
    let date: String
    let time : String
    let status: Int
    let doctor: String
    let patient: Fullnames
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date
        case time
        case status = "statu"
        case doctor
        case patient
    }

    init(id: String, date: String, time: String, status: Int, doctor: String, patient: Fullnames) {
        self.id = id
        self.date = date
        self.time = time
        self.status = status
        self.doctor = doctor
        self.patient = patient
    }
}
