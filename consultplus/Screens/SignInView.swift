//
//  SignInView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 20/3/2023.
//

import SwiftUI




struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        NavigationView {
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
                    Text("Sign In")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .cornerRadius(50).padding()
                    
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
}
        
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
