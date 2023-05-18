//
//  MyRdvUIView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 18/5/2023.
//

import SwiftUI
import KeychainAccess

struct MyRdvUIView: View {
    @State private var name: String = ""
    @State var image: UIImage?
    @State var specialities: [ApiManager.Speciality] = []
    @State  var patientId: String? = ""
    @State var appointments: [PatientBooking] = []
    @State private var showingConfirmationDialog = false
    @State private var navigateToMainPage = false
    @State private var currentPage = 0
    let pageSize = 4

    var body: some View {
        NavigationStack{
                ZStack(alignment: .top) {
                    NavigationLink(destination: MainActivityView().navigationBarHidden(true), isActive: $navigateToMainPage) {
            EmptyView()
                    }
                    Color(.white).edgesIgnoringSafeArea(.all)
                    VStack{
                        HStack(alignment: .top){
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            ZStack{
                                
                                Image("top right").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -30))
                                RoundUserImage(image: self.$image).padding(EdgeInsets(top:0,leading:20,bottom: 20,trailing: 0))
                            }
                            

                           
                        }
                        VStack(spacing:0 ){
                            HStack {
                                Text("Your appointments")
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                            .padding(.leading, 10).padding(.top,10)
                            

                            
                            
                            
                            ScrollView(.vertical) {
                                if appointments.count > pageSize {
                                    let pageCount = (appointments.count - 1) / pageSize + 1

                                    Picker(selection: $currentPage, label: Text("Pages")) {
                                        ForEach(0..<pageCount, id: \.self) { page in
                                            Text("\(page + 1)")
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding(.horizontal, 40)

                                    Divider()

                                    let startIndex = currentPage * pageSize
                                    let endIndex = min(startIndex + pageSize, appointments.count)
                                    ForEach(appointments[startIndex..<endIndex], id: \.self) { appointment in
                                        AppointmentView(data: appointment,showingConfirmationDialog: $showingConfirmationDialog, navigateToMainPage: $navigateToMainPage)
                                    }
                                } else {
                                    ForEach(appointments, id: \.self) { appointment in
                                        AppointmentView(data: appointment,showingConfirmationDialog: $showingConfirmationDialog, navigateToMainPage: $navigateToMainPage)
                                    }
                                }
                            }
                            
                            
                            
                        }
                        .padding(.top,-10)

                      
                        
                       
                        
                    }
                        
                        
           
                    
                }.edgesIgnoringSafeArea(.bottom)
            

        }.onAppear {
            userdatils()
            ApiManager.shareInstance.getSpecialities { result in
                switch result {
                case .success(let specialities as [ApiManager.Speciality]):
                    self.specialities = specialities
                    print("dzdzdz",self.specialities)
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                     print("Unexpected result type")
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
                    self.patientId = userResponse.id
                    getappointments()
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
    
    func getappointments(){
        ApiManager.shareInstance.getPatientAppointments(patientId: self.patientId!) { result in
            switch result {
            case .success(let PatientBooking as [PatientBooking]):
                self.appointments = PatientBooking
            case .failure(let error):
                print(error.localizedDescription)
            default:
                print("Unexpected result type")
            }
        }
    }
    
}

struct MyRdvUIView_Previews: PreviewProvider {
    static var previews: some View {
        MyRdvUIView()
    }
}
