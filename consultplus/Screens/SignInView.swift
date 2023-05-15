//
//  SignInView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 20/3/2023.
//

import SwiftUI
import Alamofire
import KeychainAccess
import LocalAuthentication


struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToMainPage = false
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top) {
                NavigationLink(destination: MainActivityView().navigationBarBackButtonHidden(true), isActive: $navigateToMainPage) {
        EmptyView()
                }.navigationBarBackButtonHidden(true)
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
                        Text("Forget Password").foregroundColor(Color("AccentColor"))
                        
                    }
                                  
                    
                    
                    
                    ).navigationBarHidden(true)
                    
                    Button("faceid"){
                        faceid()
                    }
                    
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

            
            
        }

    }
    
    func faceid(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,localizedReason: "faceid secuity"){
                success, AuthenticationError in
                if success{
                    NavigateToMainPage()
                }else{
                    
                }
            }
        }
    }
    
    
    func NavigateToMainPage(){
        
        let user = UserModel(email: email.lowercased(), password: password)
        ApiManager.shareInstance.callingLoginApi(Login: user)
        {
            
            (result) in
             switch result
             {
             case .success(let userResponse as ApiManager.UserResponse):
                 do {
                     print("sa7a")
                     // Accessing the name and role properties of the UserResponse object
                     let role = userResponse.role ?? "Unknown"
                     let image = userResponse.image ?? "person.fill"
              
                     let keychain = Keychain(service: "esprit.tn.consultplus")
                     keychain["Email"] = email.lowercased()
                     keychain["Role"] = role
                     print(keychain["Role"])
                     
                     
                     ApiManager.shareInstance.downloadImage(email: email,imageName: image) { result in
                         switch result {
                         case .success(let success):
                             print("Image downloaded successfully: \(success)")
                         case .failure(let error):
                             print("Error downloading image: \(error)")
                         }
                     }
                     
                     
                     navigateToMainPage = true
                 }
                 
             case .failure:
                 
                print("no")
                 
             default:
                 print("Unexpected result type")

             }
            
            
            
            
        }
        
    }
    
}
        
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
        
    }
}


