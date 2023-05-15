//
//  ContentView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 20/3/2023.
//

import SwiftUI
import KeychainAccess

struct ContentView: View {

    @State private var email: String = ""

    
    var body: some View {
      
        NavigationStack{
            
            if (self.email.isEmpty){
                SignInView()
            }else{
                MainActivityView()
            }
            
        }.onAppear{
          
            let keychain = Keychain(service: "esprit.tn.consultplus")
            self.email = keychain["Email"] ?? ""
            
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, Locale(identifier: "French"))
    }
}
