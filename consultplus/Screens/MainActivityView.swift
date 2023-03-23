//
//  MainActivityView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 21/3/2023.
//

import SwiftUI

struct MainActivityView: View {
    @State var selectedTab = "home"
    @State var title = "House"
    
    var body: some View {
        
     
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            
            TabView(selection: $selectedTab){
                SignUpView().tag("house.fill")
                
              
              UpdateProfileView().tag("magnifyingglass")
                
                SignInView().tag("menucard.fill")

                
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
                .clipShape(Capsule())
                .padding()
                .shadow(color: Color.black.opacity(0.15), radius: 8,x:2 ,y:6)
                .frame(maxHeight: .infinity,alignment: .bottom)
                .ignoresSafeArea(.keyboard,edges: .bottom)
            
            
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
