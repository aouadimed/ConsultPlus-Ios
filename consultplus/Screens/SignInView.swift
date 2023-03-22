//
//  SignInView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 20/3/2023.
//

import SwiftUI
import Alamofire
import KeychainAccess


struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
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
                    Text("Welcome Back !").fontWeight(.bold).padding(.bottom,10)
                    Image("for login").padding()
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
                    

                    NavigationLink(destination: ForgetPasswordView(), label:
                                    {
                        Text("Forget Pasword").foregroundColor(Color("AccentColor"))
                    }
                    
                    
                    
                    ).navigationBarHidden(true)
                    
                    Button(action: {
                        
                        NavigateToMainPage()
                        
                        
                    }, label: {
                        Text("Sign In")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(50).padding()
                    })
                    

                    
                    HStack{
                        Text("Don't have an account ? ")
                        NavigationLink(destination: SignUpView().navigationBarHidden(true), label:
                                        {
                            Text("Sign Up").foregroundColor(Color("AccentColor"))
                        }
                        
                        
                        
                        ).navigationBarHidden(true)
                    }
                }
                
                
                
                
                
                
                
                
            }
            .navigationDestination(for: String.self){
                view in
                if view == "ForgetPassword"{
                    ForgetPasswordView()
                }
        }
        }
    }
    
    func NavigateToMainPage(){
        
        let user = UserModel(email: email, password: password)
        ApiManager.shareInstance.callingLoginApi(Login: user)
        {
            
            (result) in
             switch result
             {
             case .success:
                 do {
               
                     print("sa7a")

                    
                     let keychain = Keychain(service: "esprit.tn.consultplus")
                     keychain["Email"] = email
                     
                     path.append("ForgetPassword")
                 }
                 
             case .failure:
                 
                print("fuck no")

             }
            
            
            
            
        }
        
    }
    
}
        
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


