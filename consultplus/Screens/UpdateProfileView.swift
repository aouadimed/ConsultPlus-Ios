//
//  UpdateProfileView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 22/3/2023.
//

import SwiftUI

struct UpdateProfileView: View {
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemBlue
    }
    @State private var path = NavigationPath()
    @State private var selected_role : ParRole = .patient
    var body: some View {


        NavigationStack(path: $path){
            ScrollView{
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
                            
                        }.pickerStyle(SegmentedPickerStyle()).padding(.bottom,40)
                        ChosenRoleView(selected_role: selected_role)
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
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


struct ChosenRoleView : View {
    var selected_role : ParRole
    
    var body: some View {
        
        switch selected_role {
        case .patient:
            ChosenRolePatientView()
        case .doctor:
            Text("doctor")

        }
        
        
        
    }
    
    
    
    
    struct ChosenRolePatientView : View {
        
        
        var body: some View {
            
            
            Text("patient")
            
            
            
        }
    }
}
