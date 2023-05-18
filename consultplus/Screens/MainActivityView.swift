//
//  MainActivityView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 21/3/2023.
//

import SwiftUI
import KeychainAccess

struct MainActivityView: View {
    @State var selectedTab = "home"
    @State var title = "House"
    @State private var role: String = ""
    

    var body: some View {
        
        NavigationView{
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                
              
                
                
                
                if(self.role == Optional("patient")){
                    TabView(selection: $selectedTab){
                        HomeUIView().tag("house.fill")
                        
                      
                      DoctorsListUIView().tag("magnifyingglass")
                        
                        UpdateProfileView().tag("menucard.fill")

                        
                    }.edgesIgnoringSafeArea(.all)
                } else if (self.role == Optional("doctor")){
                    TabView(selection: $selectedTab){
                        ConfirmRdvUIView().tag("house.fill")
                        
                                              
                        UpdateProfileView().tag("menucard.fill")

                        
                    }.edgesIgnoringSafeArea(.all)
                }else{
                    
                    TabView(selection: $selectedTab){
                        
                                              
                        UpdateProfileView().tag("menucard.fill")

                        
                    }.edgesIgnoringSafeArea(.all)
                }
                
                

                
                
                
                
                
                
            
                HStack(spacing : 0){
                        ForEach(tabs,id: \.self){
                            image in
                            BottomNavBarItem(image: image, selectedTab: $selectedTab, title: $title)
                            if image != tabs.last{
                                Spacer(minLength: 0)
                            }
                        }
                        
                        
                    }.padding()
                    .background(Color.accentColor)
                    .clipShape(Capsule()).padding()
                    .padding(.bottom,-30)
                    .shadow(color: Color.black.opacity(0.15), radius: 8,x:2 ,y:6)
                    .frame(maxHeight: .infinity,alignment: .bottom)
                    .ignoresSafeArea(.keyboard,edges: .bottom)
                
                
            }
            
            
            

                

            
                
            
            
        }.onAppear{
            
            
            let keychain = Keychain(service: "esprit.tn.consultplus")
            self.role = keychain["Role"] ?? ""
            print("zdzdzdzd z    " ,self.role)
            
            
            
            
        }
        
       
            
    }

}

struct MainActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MainActivityView()
    }
}

var tabs = ["house.fill","magnifyingglass","menucard.fill"]
struct BottomNavBarItem: View {
    let image: String
    @Binding var selectedTab : String
    @Binding var title : String

    var body: some View {

            
   
           
                Button(action: {selectedTab = image}, label: {
                    VStack{
                        Image(systemName: image).frame(maxWidth: .infinity)
                            .foregroundColor(selectedTab == image ? Color.black : Color.white)
                    }
                    
                })
                

            
     
    }
}
