//
//  SignUpView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 20/3/2023.
//

import SwiftUI
import SnapKit


struct SignUpView: View {
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var Confirmpassword: String = ""
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .top) {
                Color(.white).edgesIgnoringSafeArea(.all)
                Image("Rectangle ili wset").resizable().padding(.top,100).edgesIgnoringSafeArea(.bottom)
                VStack{
                    HStack(alignment: .top){
                        HStack{
                            Image("logo")
                            Image("CONSULT")
                        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                        Spacer()
                        Image("top right")
                    }
                    Text("Register with us").fontWeight(.bold).padding(.bottom,10)
                    Text("Your information is safe with us").padding(.bottom,10)
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
                    SecureField("Enter your Password",text: $password)
                        .padding()
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    SecureField("Confirm Password",text: $Confirmpassword)
                        .padding()
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    
                    
                    Button(action: {
                        if password == Confirmpassword{
                            signup()
                        }else{

                            
                        }
                    }, label: {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(50).padding()
                    })

                    
                    HStack{
                        Text("Aleardy have an account ? ")
                        NavigationLink(destination: SignInView().navigationBarHidden(true), label:
                                        {
                            Text("Sign in").foregroundColor(Color("AccentColor"))
                        }
                        
                        
                        
                        ).navigationBarHidden(true)
                    }
                    
                    
                }
                
                
                
                
        
            }
            .navigationDestination(for: String.self){
                view in
                if view == "signin"{
                        SignInView().navigationBarHidden(true)
                }
            }
        }
    }
    
    func signup(){
        
        let user = UserModel(name: fullname.lowercased(), email: email.lowercased(), password: password)
        ApiManager.shareInstance.callingRegisterApi(Register: user)
        {
            
            (result) in
             switch result
             {
             case .success:
                 do {
               
                     print("sa7a")
                     path.append("signin")
                 }
                 
             case .failure:
                 
                print("no")

             }
            
            
            
            
        }
        
    }
    
}
        
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
