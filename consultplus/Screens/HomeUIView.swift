//
//  HomeUIView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 18/4/2023.
//

import SwiftUI
import KeychainAccess

struct HomeUIView: View {
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
                        VStack(spacing:0 ){
                            HStack {
                                Text("Most Popular")
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                            .padding(.leading, 10)

                            ScrollView(.horizontal) {
                                HStack {
                                    MyCardView()
                                    MyCardView()
                                    MyCardView()
                                    MyCardView()
                                }
                            }
                            .frame(height:180)
                            
                            
                            HStack {
                                Text("Your appointments")
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                            .padding(.leading, 10).padding(.top,10)
                            
                            ScrollView(.vertical) {
                                
                                    AppointmentView()
                                    AppointmentView()
                                    AppointmentView()
                                

                                
                            }
                            
                            
                            
                            
                            
                            
                            
                        }
                        .padding(.top,-10)

                      
                        
                       
                        
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

struct HomeUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeUIView()
    }
}


struct RoundUserImage: View {
    @Binding var image: UIImage?

    
    var body: some View {
    
        
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50) // change size to 80x80
                    .cornerRadius(40) // change corner radius to 40
                    .overlay(Circle().stroke(Color.white, lineWidth: 3)) // add white circle border
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .padding()
                    .foregroundColor(.white) // change color to white
                    .background(Circle().fill(Color.gray)) // add gray circle background
                    .frame(width: 50, height: 50) // change size to 80x80
            }
        }
            
            
    
    }
}


struct MyCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .shadow(radius: 0)
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .frame(width: 144, height: 171)
                        .foregroundColor(Color(.lightGray))
                        .cornerRadius(25)
                VStack(spacing: 10) {
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .padding(.bottom,20)
                    Text("Dentistry")
                        .font(.custom("Eastman-Medium", size: 15))
                        .lineSpacing(-3)
                        .foregroundColor(.white)

                    HStack(spacing: 3) {
                        Text("70")
                            .font(.custom("Roboto-Regular", size: 13))
                            .lineSpacing(-2)
                            .foregroundColor(.white)

                        Text("doctors")
                            .font(.custom("Roboto-Regular", size: 13))
                            .lineSpacing(-2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.leading, -50)
            }
}
        }
    }
}

struct AppointmentView: View {
    var body: some View {
        VStack(spacing: 3) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Appointment Date:")
                        .font(.custom("Eastman-Medium", size: 15))
                        .foregroundColor(.black)
                    HStack(spacing: 6) {
                        Text("2022-12-22")
                            .font(.custom("Poppins", size: 15))
                            .lineSpacing(-3)
                            .foregroundColor(.black)
                        Text("11:00")
                            .font(.custom("Poppins", size: 15))
                            .lineSpacing(-3)
                            .foregroundColor(.black)
                    }
                    HStack {
                        Text("Dr.")
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(.black)
                        Text("Mohamed")
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(.black)
                        Text("aouadi")
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(.black)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Button(action: {}) {
                        Text("Cancel")
                            .font(.custom("Roboto-Regular", size: 8))
                            .frame(width: 50, height: 20)
                            .background(Color(red: 1.0, green: 1.0, blue: 1.0))
                            .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1))
                    }
                    VStack(spacing: 2) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(red: 0.0, green: 0.5, blue: 1.0))
                        Text("Pending for confirmation")
                            .font(.custom("Poppins", size: 10))
                            .foregroundColor(Color(red: 0.0, green: 0.5, blue: 1.0))
                    }
                }
            }

        }
        .padding()
        .background(RoundedRectangle(cornerRadius:15).foregroundColor(.white))
        .shadow(radius: 10).padding().padding(.bottom,-20)
    }
}
