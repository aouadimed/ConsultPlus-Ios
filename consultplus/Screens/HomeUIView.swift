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
    @State var specialities: [ApiManager.Speciality] = []
    @State  var patientId: String? = ""
    @State var appointments: [PatientBooking] = []
    @State private var showingConfirmationDialog = false
    @State private var navigateToMainPage = false


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
                                Text("Most Popular")
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                            .padding(.leading, 10)

                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(specialities, id: \.self) { speciality in
                                        MyCardView(speciality: speciality)
                                    }
                                }
                            }
                            .frame(height:180)
                            
                            HStack {
                                Text("Your appointments")
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                Spacer()
                                NavigationLink(destination: MyRdvUIView(), label:
                                                {
                                    Text("Expand")
                                        .fontWeight(.bold)
                                        .padding(.bottom, 10)
                                    
                                }
)
                            }
                            .padding(.leading, 10).padding(.top,10)
                            
                            ScrollView(.vertical) {
                                ForEach(appointments.prefix(4), id: \.self) { appointment in
                                    AppointmentView(data: appointment, showingConfirmationDialog: $showingConfirmationDialog, navigateToMainPage: $navigateToMainPage)
                                }
                            }.padding(.bottom,100)
                        

                            
                            
                            
                            
                            
                            
                            
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
    let speciality: ApiManager.Speciality
    @State private var isPresented = false

    var body: some View {
        Button(action: { isPresented = true }) {
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
                            Text(speciality.id)
                                .font(.custom("Eastman-Medium", size: 15))
                                .lineSpacing(-3)
                                .foregroundColor(.white)

                            HStack(spacing: 3) {
                                Text("\(speciality.doctorsCount)")
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
        .sheet(isPresented: $isPresented) {
            DoctorsListUIView(speciality: speciality.id)
        }
    }
}




struct AppointmentView: View {
    let data: PatientBooking

    @Binding var showingConfirmationDialog : Bool
    @Binding var navigateToMainPage : Bool
    var body: some View {
        VStack(spacing: 3) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
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
                    HStack(spacing: 0){
                        Text("Dr.")
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(.black)
                        Text(data.doctor.firstname.capitalized+" ")
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(.black)
                        Text(data.doctor.lastname.capitalized)
                            .font(.custom("Poppins-SemiBold", size: 15))
                            .foregroundColor(.black)
                    }
                }
                Spacer()
                VStack {
                    
                    if(data.status == 0){
                        
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
                        
                        
                    } else {
                        
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
                                title: Text("Cancel booking"),
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
}
