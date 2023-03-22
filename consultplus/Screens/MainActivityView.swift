//
//  MainActivityView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 21/3/2023.
//

import SwiftUI

struct MainActivityView: View {
    var body: some View {




        HStack{
            Button(action: {
                
            }, label: {
                VStack{
                    Image(systemName: "house").frame(maxWidth: .infinity)
                    Text("home")
                }
            })
        }.padding()
            .background(Color.accentColor)
            .clipShape(Capsule())
            .padding()


    }
}

struct MainActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MainActivityView()
    }
}
