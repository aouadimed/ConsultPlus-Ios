//
//  SwiftUIView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 10/5/2023.
//

import SwiftUI
 
struct SwiftUIView: View {
     
    @State var selected = -1
    @State var message = false
     
    var body: some View {
        VStack {
            Image("1")
                .resizable()
                .aspectRatio(contentMode: .fill)
            Text("Pinoy Food Recipes")
                .font(.title)
                .fontWeight(.medium)
            Form {
                Section {
                    HStack {
                        VStack {
                            Text("Detail")
                                .foregroundColor(.gray)
                                .font(.title)
                             
                            Text("Traditional Foods You Want to Eat When in the Philippines Visiting the Philippines anytime soon? If you are, you want to enjoy some of the fine foods that people have eaten there for generations. While some go on vacation and want to stick with their traditional favorites, you want the full experience in a great nation like the Philippines.")
                                .foregroundColor(.gray)
                                .font(.callout)
                                .frame(alignment: .leading)
                        }
                    }
                    HStack {
                        Text("Rating")
                        Spacer()
                         
                        HStack {
                            RatingView(selected: $selected, message: $message)
                        }
                    }.alert(isPresented: $message) {
                        Alert(title: Text("Rating Submit"), message: Text("You Rated \(self.selected + 1) out of 5 Star Rating"), dismissButton: .none)
                    }
                      
                }
  
            }
        }
        //.environment(\.colorScheme, .light)
    }
}
 
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
  
struct RatingView : View {
     
    @Binding var selected : Int
    @Binding var message : Bool
     
    var body: some View {
        ForEach(0..<5) { rating in
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(self.selected >= rating ? .yellow : .gray)
                .onTapGesture {
                    self.selected = rating
                    self.message.toggle()
                }
        }
    }
}
