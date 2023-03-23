//
//  UpdateProfileView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 22/3/2023.
//

import SwiftUI

struct UpdateProfileView: View {
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = .lightGray
    }
    @State private var path = NavigationPath()
    @State private var selected_role : ParRole = .patient
    var body: some View {
        NavigationStack(path: $path){
                ZStack(alignment: .top) {
                    Color(.white).edgesIgnoringSafeArea(.all)
                    Image("Rectangle ili wset").resizable().padding(.top,100).edgesIgnoringSafeArea(.bottom)
                    VStack{
                        HStack(alignment: .top){
                            Spacer()
                            Spacer()
                            Spacer()
                            VStack{
                                Text("Hello_").fixedSize()
                                Text("aouadi")
                            }.frame(height: 50).fixedSize()
                            Spacer()
                            Image("top right").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -30))
                        }
                        
                        Picker("Choose a role", selection: $selected_role){
                            ForEach(ParRole.allCases,id :\.self){
                                Text($0.rawValue)
                            }
                            
                        }.pickerStyle(SegmentedPickerStyle()).padding()
                        ChosenRoleView(selected_role: selected_role)
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
            

        }




    }
}

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView()
    }
}



enum ParRole : String,CaseIterable{
    case patient = "Patient"
    case doctor = "Doctor"
}
enum Gender : String,CaseIterable{
    case male = "Male"
    case female = "Female"
}

struct ChosenRoleView : View {
    var selected_role : ParRole
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var birthdate = Date()
    @State private var selected_gender : Gender = .male
    @State private var adresse: String = ""
    @State private var selected_specialite: Specialite = .Surgery
    @State private var yearsOfpractice: String = ""
    @State private var patientnb: String = ""
    @State private var description: String = ""
    var body: some View {
        
        switch selected_role {
        case .patient:
            ChosenRolePatientView(fullname:$fullname, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender, adresse: $adresse)
        case .doctor:
            ChosenRoleDoctorView(fullname: $fullname, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender , adresse: $adresse, selected_specialite: $selected_specialite, yearsOfpractice: $yearsOfpractice, patientnb: $patientnb, description: $description)
        }
        
        
        
    }
    

    
    struct CommonFileds : View {
        @Binding var fullname: String
        @Binding var email: String
        @Binding var firstname: String
        @Binding var lastname: String
        @Binding var birthdate : Date
        @Binding var selected_gender : Gender
        @Binding var adresse: String
        var body: some View{
            TextField("Enter your full name",text: $fullname)
                .padding()
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
            TextField("Enter your E-mail",text: $email)
                .padding()
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
            TextField("Enter your Firstname",text: $firstname)
                .padding()
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
            TextField("Enter your Lastname",text: $lastname)
                .padding()
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
                Picker("Choose your gender", selection: $selected_gender){
                    ForEach(Gender.allCases,id :\.self){
                        Text($0.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle()).padding()
                    .frame(maxWidth : .infinity)
                    .background(Color.white)
                    .cornerRadius(50.5)
                    .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                    .padding()
            DatePicker("Birthday", selection: $birthdate, in: ...Date(),displayedComponents: .date)
                    .padding().foregroundColor(Color.gray)
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
                TextField("Enter your Adresse",text: $adresse)
                    .padding()
                    .frame(maxWidth : .infinity)
                    .background(Color.white)
                    .cornerRadius(50.5)
                    .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                    .padding()
            
            
            
            
            
        }
    }
    struct ChosenRolePatientView : View {
        @Binding var fullname: String
        @Binding var email: String
        @Binding var firstname: String
        @Binding var lastname: String
        @Binding var birthdate : Date
        @Binding var selected_gender : Gender
        @Binding var adresse: String
        var body: some View {
            Form{
                
            
            CommonFileds(fullname: $fullname, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender, adresse: $adresse)
              
                Button(action: {
                    
                    print(fullname)
                                    
                }, label: {
                    Text("Save")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .cornerRadius(50).padding()
                })
            
           
            }.scrollContentBackground(.hidden)
        }
       
    }
    
    enum Specialite : String,CaseIterable{
        case Dermatology = "Dermatology"
        case Optometry = "Optometry"
        case Neurosurgery = "Neurosurgery"
        case General = "General"
        case Surgery = "Surgery"
        case Psychiatry = "Psychiatry"
        case Ophthalmology = "Ophthalmology"
        case Virology = "Virology"
        case Radiology = "Radiology"
        case Plastic_Surgery = "Plastic Surgery"
        case Obstetrics = "Obstetrics"
        case Orthopedics = "Orthopedics"
    }
    
    struct ChosenRoleDoctorView : View {
        @Binding var fullname: String
        @Binding var email: String
        @Binding var firstname: String
        @Binding var lastname: String
        @Binding var birthdate : Date
        @Binding var selected_gender : Gender
        @Binding var adresse: String
        @Binding var  selected_specialite :Specialite
        @Binding var  yearsOfpractice: String
        @Binding var  patientnb: String
        @Binding var  description: String
        var body: some View {
            Form{
            CommonFileds(fullname: $fullname, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender, adresse: $adresse)
                    Picker("Your specialty", selection: $selected_specialite){
                        ForEach(Specialite.allCases,id :\.self){
                            Text($0.rawValue)
                        }
                    }.padding().foregroundColor(Color.gray)
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    TextField("How many years of practice",text: $yearsOfpractice)
                        .padding()
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    TextField("How many patient do you have",text: $patientnb)
                        .padding()
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    TextField("Description",text: $description)
                        .padding()
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    Button(action: {
                        
                       print(selected_specialite)
                        print(firstname)
                        
                    }, label: {
                        Text("Save")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(50).padding()
                    })
            
            }.scrollContentBackground(.hidden)
                
                


            
            }
        
    }
    
    
}
