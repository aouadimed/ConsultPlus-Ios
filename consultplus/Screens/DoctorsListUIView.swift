//
//  DoctorsListUIView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 18/4/2023.
//

import SwiftUI
import KeychainAccess
import URLImage

struct DoctorsListUIView: View {
    let specialite: String?
    @State private var name: String = ""
    @State var image: UIImage?
    @State var doctors: [ApiManager.Doctor] = []
    @State private var searchText: String = ""

    init(speciality: String? = nil) {
        self.specialite = speciality
    }
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

                            SearchBarView(searchText: $searchText).padding()

                            HStack {
                                Text("Our Doctors")
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                            .padding(.leading, 10).padding(.top,10)
                            
                            ScrollView(.vertical) {
                                if searchText.isEmpty {
                                    ForEach(doctors, id: \.self) { doctor in
                                        DoctorCardView(doctordata: doctor)
                                    }
                                } else {
                                    let filteredDoctors = doctors.filter { $0.firstname.lowercased().contains(searchText.lowercased()) || $0.lastname.lowercased().contains(searchText.lowercased()) || $0.specialite.lowercased().contains(searchText.lowercased()) }
                                    if filteredDoctors.isEmpty {
                                        Text("No doctors found").padding().padding(.top,56)
                                    } else {
                                        ForEach(filteredDoctors, id: \.self) { doctor in
                                            DoctorCardView(doctordata: doctor)
                                        }
                                    }
                                }
                            }

                            
                            
                            
                            
                            
                            
                            
                        }
                        .padding(.top,-10)

                      
                        
                       
                        
                    }
                        
                        
           
                    
                }.edgesIgnoringSafeArea(.bottom)
            

        }.edgesIgnoringSafeArea(.bottom).onAppear {
            userdatils()
            if let specialite = specialite, !specialite.isEmpty {
                ApiManager.shareInstance.getDoctorsBySpeciality(speciality: specialite) { result in
                    switch result {
                    case .success(let doctor as [ApiManager.Doctor]):
                        self.doctors = doctor
                    case .failure(let error):
                        print(error.localizedDescription)
                    default:
                        print("Unexpected result type")
                    }
                }
            } else {
                ApiManager.shareInstance.getDoctors { result in
                    switch result {
                    case .success(let doctor as [ApiManager.Doctor]):
                        self.doctors = doctor
                    case .failure(let error):
                        print(error.localizedDescription)
                    default:
                        print("Unexpected result type")
                    }
                }
                
            }


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

struct DoctorsListUIView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorsListUIView()
    }
}

struct DoctorCardView: View {
    let doctordata: ApiManager.Doctor
    var body: some View {
        NavigationLink(destination: DoctorProfilUIView(doctorEmail: doctordata.email)) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(radius: 10)
                HStack {
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 5)
                        .frame(width: 60, height: 60)
                        .overlay(
                            URLImage(URL(string: doctordata.image)!) { image in
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            }.clipShape(Circle())
                        )
                        .padding(.leading, 30).padding(.trailing,25)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 0) {
                            Text("Dr.")
                                .font(.custom("eastman_medium", size: 15))
                                .foregroundColor(.black)
                            Text(doctordata.firstname+" ")
                                .font(.custom("eastman_medium", size: 15))
                                .foregroundColor(.black)
                            Text(doctordata.lastname)
                                .font(.custom("eastman_medium", size: 15))
                                .foregroundColor(.black)
                        }
                        Text(doctordata.specialite)
                            .font(.custom("eastman_medium", size: 15))
                            .foregroundColor(.black)
                            .lineSpacing(-3)
                    }
                    Spacer()
                    Image("right_arrow")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                }
                .frame(width: 350, height: 90)
            }.padding()
        }
    }
}
struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray).padding()

            TextField("Search by doctors or diseases", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 8)

            if searchText != "" {
                Button(action: {
                    searchText = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray).padding()
                })
            }
        }
        .frame(width: 350, height: 50)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 10)
    }
}
