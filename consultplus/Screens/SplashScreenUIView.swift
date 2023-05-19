//
//  SplashScreenUIView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 19/5/2023.
//

import SwiftUI


struct SplashScreenUIView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
        
        
        if isActive {
            ContentView()
        } else{
            VStack{
                
                VStack{
                    
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(0.5)
                        Image("CONSULT")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.7)
                

                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    
                    withAnimation{
                        self.isActive = true
                    }
                    
                }
            }
        }
        
        
        
    }
}

struct SplashScreenUIView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenUIView()
    }
}

