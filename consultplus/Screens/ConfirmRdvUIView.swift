//
//  ConfirmRdvUIView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 15/5/2023.
//

import SwiftUI
import KeychainAccess

struct ConfirmRdvUIView: View {
    @State private var name: String = ""
    @State var image: UIImage?
    @State  var doctorId: String? = ""
    @State var appointments: [DoctorBooking] = []
    @State private var showingConfirmationDialog = false
    @State private var showingConfirmationDialogAprrove = false
    @State private var currentPage = 0
    @State private var navigateToMainPage = false

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
                                        AppointmentConfirmationView(data: appointment, showingConfirmationDialog: $showingConfirmationDialog, showingConfirmationDialogAprrove: $showingConfirmationDialogAprrove, navigateToMainPage: $navigateToMainPage)
                                    }
                                } else {
                                    ForEach(appointments, id: \.self) { appointment in
                                        AppointmentConfirmationView(data: appointment, showingConfirmationDialog: $showingConfirmationDialog, showingConfirmationDialogAprrove: $showingConfirmationDialogAprrove, navigateToMainPage: $navigateToMainPage)
                                    }
                                }
                            }



                            
                            
                            
                            
                            
                            
                            
                        }
                        .padding(.top,-10)

                      
                        
                       
                        
                    }
                        
                        
           
                    
                }.edgesIgnoringSafeArea(.bottom)
            

        }.onAppear {
            userdatils()
            getappointments()
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
                    self.doctorId = userResponse.id
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
        ApiManager.shareInstance.getDoctorAppointments(doctorId: self.doctorId!) { result in
            switch result {
            case .success(let DoctorBooking as [DoctorBooking]):
                self.appointments = DoctorBooking
            case .failure(let error):
                print(error.localizedDescription)
            default:
                print("Unexpected result type")
            }
        }
    }
    

}
struct ConfirmRdvUIView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmRdvUIView()
    }
}


struct AppointmentConfirmationView: View {
    let data: DoctorBooking

    @Binding var showingConfirmationDialog : Bool
    @Binding var showingConfirmationDialogAprrove : Bool
    @Binding var navigateToMainPage : Bool

    
    var body: some View {
        VStack(spacing: 3) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 0){
                        Text(data.patient.firstname.capitalized+" ")
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(.black)
                        Text(data.patient.lastname.capitalized)
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(.black)
                    }
                    Text("Appointment Date:")
                        .font(.custom("Eastman-Medium", size: 15))
                        .foregroundColor(.black)
                    HStack(spacing: 6) {
                        Text(data.date)
                            .font(.custom("Poppins", size: 15))
                            .lineSpacing(-3)
                            .foregroundColor(.black)
                        Text(data.time)
                            .font(.custom("Poppins", size: 15))
                            .lineSpacing(-3)
                            .foregroundColor(.black)
                    }
                }
                Spacer()
                VStack {
                    
                    if(data.status == 0){
                        
                  
                        HStack{
                            
                            Button(action: {
                                showingConfirmationDialogAprrove = true
                                
                            }) {
                                Text("Aprrove")
                                    .font(.custom("Roboto-Regular", size: 8))
                                    .frame(width: 70, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.accentColor, lineWidth: 1)
                                    ).padding(.trailing,20)
                            }.alert(isPresented: $showingConfirmationDialogAprrove) {
                                Alert(
                                    title: Text("Aprrove this booking"),
                                    message: Text("Are you sure you want to Aprrove this appointment?"),
                                    primaryButton: .default(Text("Aprrove")) {
                                        ConfirmRdv(patient : data.id)
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            
                            
                            
                            
                            Button(action: {
                                showingConfirmationDialog = true
                                
                            }) {
                                Text("Cancel")
                                    .font(.custom("Roboto-Regular", size: 8))
                                    .frame(width: 70, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.red, lineWidth: 1)
                                    ).padding(.trailing,20)
                            }.alert(isPresented: $showingConfirmationDialog) {
                                Alert(
                                    title: Text("Cancel this booking"),
                                    message: Text("Are you sure you want to cancel this appointment?"),
                                    primaryButton: .default(Text("Yes")) {
                                        deleteappointments(patient : data.id)
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            
                            
                            
                            
                            
                        }
                        
                        
                    } else if(data.status == 1)  {
                        
                        Button(action: {
                            showingConfirmationDialog = true
                            
                        }) {
                            Text("Cancel")
                                .font(.custom("Roboto-Regular", size: 8))
                                .frame(width: 70, height: 30)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: 1)
                                ).padding(.trailing,20)
                        }.alert(isPresented: $showingConfirmationDialog) {
                            Alert(
                                title: Text("Cancel this booking"),
                                message: Text("Are you sure you want to cancel this appointment?"),
                                primaryButton: .default(Text("Book")) {
                                    deleteappointments(patient : data.id)
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                        
                    }


                }
            }

        }
        .padding()
        .background(RoundedRectangle(cornerRadius:15).foregroundColor(.white))
        .shadow(radius: 10).padding().padding(.bottom,-20)
    }
    func deleteappointments(patient : String){
        ApiManager.shareInstance.deleteApponitment(bookId: patient) {
            (result) in
             switch result
             {
             case .success:
                 do {
               
                     navigateToMainPage=true
                 }
                 
             case .failure:
                 
                print("no")

             }
            
        }
    }
    func ConfirmRdv(patient : String){
        ApiManager.shareInstance.ConfirmRdv(Id: patient) {
            (result) in
             switch result
             {
             case .success:
                 do {
            
                     navigateToMainPage=true
                 }
                 
             case .failure:
                 
                print("no")

             }
        }
    }
}
