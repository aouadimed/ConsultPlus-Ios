//
//  BookingUIView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 18/4/2023.
//

import SwiftUI
import KeychainAccess

struct BookingUIView: View {
    let times = [
        TimeView(time: "10:00", endTime: "11:00"),
        TimeView(time: "11:00", endTime: "12:00"),
        TimeView(time: "12:00", endTime: "13:00"),
        TimeView(time: "13:00", endTime: "14:00"),
        TimeView(time: "14:00", endTime: "15:00"),
        TimeView(time: "15:00", endTime: "16:00"),
        TimeView(time: "16:00", endTime: "17:00"),
        TimeView(time: "17:00", endTime: "18:00"),
        TimeView(time: "18:00", endTime: "19:00"),
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var name: String = ""
    @State var image: UIImage?
    var body: some View {
        NavigationView{
                ZStack(alignment: .top) {
                    Color(.white).edgesIgnoringSafeArea(.all)
                    VStack{
                        HStack(alignment: .top){
                            Spacer()
                            Spacer()
                            Spacer()
                            VStack{
                                Text("Hello_").fixedSize()
                                Text(self.name)
                            }.frame(height: 50).fixedSize()
                            Spacer()
                            ZStack{
                                Image("top right").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -30))
                                RoundUserImage(image: self.$image).padding(EdgeInsets(top:0,leading:20,bottom: 20,trailing: 0))
                            }
                            
                            
                        }
                        ScrollView(.vertical) {
                        ZStack{
                            Image("Rectangle ili wset").resizable().edgesIgnoringSafeArea(.bottom)
                            VStack(spacing:0 ){
                                ProfileCardView().padding()
                                Divider().frame(width: 320,height: 2).padding()
                                HStack {
                                    Text("Date")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("Avril")
                                        .fontWeight(.bold).padding(.trailing,10)
                                }
                                .padding(.leading, 10)
                                
                                ScrollView(.horizontal) {
                                    HStack{
                                        CustomView(day: "M", date: "29")
                                        CustomView(day: "M", date: "29")
                                        CustomView(day: "M", date: "29")
                                        CustomView(day: "M", date: "29")

                                        CustomView(day: "M", date: "29")
                                        CustomView(day: "M", date: "29")
                                        CustomView(day: "M", date: "29")
                                        CustomView(day: "M", date: "29")
                                        CustomView(day: "M", date: "29")
                                        CustomView(day: "M", date: "29")

                                    }

                                    
                                }
                                
                                Divider().frame(width: 320,height: 2).padding()
                                HStack {
                                    Text("Time")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                
                                
                    
                                ScrollView {
                                    LazyVGrid(columns: columns) {
                                        ForEach(0..<9) { i in
                                            TimeView(time: times[i].time, endTime: times[i].endTime)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                       
                                }

                                
                                Button(action: {
                                    
                               
                                    
                                    
                                }, label: {
                                    Text("BOOK APPOINTMNT")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color("AccentColor"))
                                        .cornerRadius(50).padding()
                                }).padding()
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                      
                        
                       
                        
                    }
                        
                        
           
                    
                }.edgesIgnoringSafeArea(.bottom)
            

        }.onAppear {
            userdatils()
}

    }
    func userdatils(){
        let keychain = Keychain(service: "esprit.tn.consultplus")
        let user = UserModel(email: keychain["Email"])
        ApiManager.shareInstance.callingUserDataApi(UserData: user) { result in
            switch result {
            case .success(let userResponse as ApiManager.UserResponse):
                do {
                    print("sa7a")
                    // Accessing the name and role properties of the UserResponse object
                    self.name = userResponse.name ?? ""
                    let filename = userResponse.image ?? "person.fill"
                    let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let directoryUrl = documentsUrl.appendingPathComponent("ConsultPlus")
                    let fileUrl = directoryUrl.appendingPathComponent(filename)
                    let imageData = try Data(contentsOf: fileUrl)
                    self.image = UIImage(data: imageData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            default:
                print("Unexpected result type")
            }
        }
    }
}
struct BookingUIView_Previews: PreviewProvider {
    static var previews: some View {
        BookingUIView()
    }
}

struct CustomView: View {
    
    let day: String
    let date: String
    
    var body: some View {
        VStack(spacing: 12.10) {
            Text(day)
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(.accentColor)
            Text(date)
                .font(.custom("Poppins-Medium", size: 20))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 12.10)
        .padding(.vertical, 9.10)
        .background(RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .shadow(radius: 10)).padding(EdgeInsets(top:20,leading:10,bottom: 20,trailing: 0))
    }
}

struct TimeView: View {
    let time: String
    let endTime: String
    
    var body: some View {
        VStack {
            HStack {
                Text(time)
                    .font(.custom("Poppins-Medium", size: 14.30))
                    .foregroundColor(.black)
                Text(" - ")
                    .font(.custom("Poppins-Medium", size: 14.30))
                    .foregroundColor(.black)
                Text(endTime)
                    .font(.custom("Poppins-Medium", size: 14.30))
                    .foregroundColor(.black)
            }
            .padding(.vertical, 10.40)
        }
        .frame(width: 110, height: nil)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 2, x: 0, y: 2)
        )
        .padding(.horizontal, 10.40)
        .padding(.vertical, 6.50)
    }
}
