//
//  UpdateProfileView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 22/3/2023.
//

import SwiftUI
import KeychainAccess

struct UpdateProfileView: View {
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = .lightGray
        
    }
    @State private var selected_role : ParRole = .patient
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var birthdate = Date()
    @State private var selected_gender : Gender = .male
    @State private var adresse: String = ""
    @State private var selected_specialite: Specialite = .Surgery
    @State private var yearsOfpractice: String = ""
    @State private var patientnb: String = ""
    @State private var description: String = ""
    @State private var checkRole: String = "patient"
   @State var shouldShowImagePicker = false
   @State var image: UIImage?
    var body: some View {
        NavigationView{
                ZStack(alignment: .top) {
                    Color(.white).edgesIgnoringSafeArea(.all)
                    Image("Rectangle ili wset").resizable().padding(.top,100).edgesIgnoringSafeArea(.bottom)
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
                            Image("top right").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -30))
                        }
                        if(checkRole=="patient"){
                            ChosenRoleView(selected_role: .patient,fullname: $name, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender , adresse: $adresse, selected_specialite: $selected_specialite, yearsOfpractice: $yearsOfpractice, patientnb: $patientnb, description: $description,image: $image,shouldShowImagePicker: $shouldShowImagePicker)
                        }else if (checkRole == "doctor"){
                            ChosenRoleView(selected_role: .doctor,fullname: $name, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender , adresse: $adresse, selected_specialite: $selected_specialite, yearsOfpractice: $yearsOfpractice, patientnb: $patientnb, description: $description,image: $image,shouldShowImagePicker: $shouldShowImagePicker)
    
                        }else{
                            Picker("Choose a role", selection: $selected_role){
                                ForEach(ParRole.allCases,id :\.self){
                                    Text($0.rawValue)
                                }
                                
                            }.pickerStyle(SegmentedPickerStyle()).padding()
                            ChosenRoleView(selected_role: selected_role,fullname: $name, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender , adresse: $adresse, selected_specialite: $selected_specialite, yearsOfpractice: $yearsOfpractice, patientnb: $patientnb, description: $description,image: $image,shouldShowImagePicker: $shouldShowImagePicker)
                        }
                        
                    }
                        
                        
           
                    
                }.navigationBarTitle("", displayMode: .inline)
            

        }.onAppear {
            let keychain = Keychain(service: "esprit.tn.consultplus")
            self.checkRole = keychain["Role"] ?? ""
            userdatils()
}.navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image,email: $email)
                    .ignoresSafeArea()
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMMM yy"
                    if let birthdateString = userResponse.birthdate,
                        let birthdate = dateFormatter.date(from: birthdateString) {
                        self.birthdate = birthdate
                    } else {
                        // handle the case where the birthdate string is invalid or missing
                    }
                    self.email = userResponse.email ?? ""
                    self.firstname = userResponse.firstname ?? ""
                    self.lastname = userResponse.lastname ?? ""
                    self.selected_gender = Gender(rawValue: userResponse.genders ?? "") ?? .male
                    self.adresse = userResponse.adresse ?? ""
                    if let specialiteString = userResponse.specialite,
                        let specialite = Specialite(rawValue: specialiteString) {
                        self.selected_specialite = specialite
                    }
                    self.yearsOfpractice = String(userResponse.experience ?? 0)
                    self.patientnb = String(userResponse.patient ?? 0)
                    self.description = userResponse.description ?? ""
                    let filename = userResponse.image ?? "person.fill"
                    let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let directoryUrl = documentsUrl.appendingPathComponent("ConsultPlus")
                    let fileUrl = directoryUrl.appendingPathComponent(filename)
                    let imageData = try Data(contentsOf: fileUrl)
                    self.image = UIImage(data: imageData)
                    
                    let keychain = Keychain(service: "esprit.tn.consultplus")
                    keychain["Email"] = email
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

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView()
    }
}

extension Date{
    var displayForamt: String{
        self.formatted(
            .dateTime.year(.twoDigits)
            .month(.wide)
            .day(.twoDigits)
        )
    }
}
enum ParRole : String,CaseIterable{
    case patient = "Patient"
    case doctor = "Doctor"
}
enum Gender : String,CaseIterable{
    case male = "Male"
    case female = "Female"
    
    
    init?(rawValue: String) {
            switch rawValue {
            case "Male":
                self = .male
            case "Female":
                self = .female
            default:
                return nil
            }
        }
}

enum Specialite : String,CaseIterable{
    case Dermatology = "Dermatology"
    case Optometry = "Optometry"
    case Neurosurgery = "Neurosurgery"
    case General = "General"
    case Surgery = "Surgery"
    case Psychiatry = "Psychiatry"
    case Ophthalmology = "Ophthalmology"
    case Virology = "Virology"
    case Radiology = "Radiology"
    case Plastic_Surgery = "Plastic Surgery"
    case Obstetrics = "Obstetrics"
    case Orthopedics = "Orthopedics"
    
    static func allCasesWithUnderscores() -> [Specialite] {
        let rawValues = ["Dermatology", "Optometry", "Neurosurgery", "General", "Surgery", "Psychiatry", "Ophthalmology", "Virology", "Radiology", "Plastic_Surgery", "Obstetrics", "Orthopedics"]
        return rawValues.compactMap { Specialite(rawValue: $0.replacingOccurrences(of: "_", with: " ")) }
    }
}
struct ChosenRoleView : View {
    var selected_role : ParRole
    @Binding var fullname: String
    @Binding var email: String
    @Binding var firstname: String
    @Binding var lastname: String
    @Binding var birthdate : Date
    @Binding var selected_gender : Gender
    @Binding var adresse: String
    @Binding var  selected_specialite :Specialite
    @Binding var  yearsOfpractice: String
    @Binding var  patientnb: String
    @Binding var  description: String
    @Binding var image: UIImage?
    @Binding var shouldShowImagePicker : Bool
    var body: some View {
        
        switch selected_role {
        case .patient:
            ChosenRolePatientView(fullname:$fullname, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender, adresse: $adresse,image: $image,shouldShowImagePicker: $shouldShowImagePicker)
        case .doctor:
            ChosenRoleDoctorView(fullname: $fullname, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender , adresse: $adresse, selected_specialite: $selected_specialite, yearsOfpractice: $yearsOfpractice, patientnb: $patientnb, description: $description,image: $image,shouldShowImagePicker: $shouldShowImagePicker)
        }
        
        
        
    }
    

    
    struct CommonFileds : View {
        @Binding var fullname: String
        @Binding var email: String
        @Binding var firstname: String
        @Binding var lastname: String
        @Binding var birthdate : Date
        @Binding var selected_gender : Gender
        @Binding var adresse: String
        @Binding var image: UIImage?
        @Binding var shouldShowImagePicker : Bool
        
        var body: some View{
            HStack{
                Spacer()
                UserImage(image: $image, shouldShowImagePicker: $shouldShowImagePicker)
                Spacer()
            }
            
            TextField("Enter your full name",text: $fullname)
                .padding()
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
            TextField("Enter your E-mail",text: $email)
                .padding()
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
            TextField("Enter your Firstname",text: $firstname)
                .padding()
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
            TextField("Enter your Lastname",text: $lastname)
                .padding()
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
                Picker("Choose your gender", selection: $selected_gender){
                    ForEach(Gender.allCases,id :\.self){
                        Text($0.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle()).padding()
                    .frame(maxWidth : .infinity)
                    .background(Color.white)
                    .cornerRadius(50.5)
                    .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                    .padding()
            DatePicker("Birthday", selection: $birthdate, in: ...Date(),displayedComponents: .date)
                    .padding().foregroundColor(Color.gray)
                .frame(maxWidth : .infinity)
                .background(Color.white)
                .cornerRadius(50.5)
                .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                .padding()
                TextField("Enter your Adresse",text: $adresse)
                    .padding()
                    .frame(maxWidth : .infinity)
                    .background(Color.white)
                    .cornerRadius(50.5)
                    .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                    .padding()
            
            
            
            
            
        }
    }
    

    struct ChosenRolePatientView : View {
        @Binding var fullname: String
        @Binding var email: String
        @Binding var firstname: String
        @Binding var lastname: String
        @Binding var birthdate : Date
        @Binding var selected_gender : Gender
        @Binding var adresse: String
        @Binding var image: UIImage?
        @Binding var shouldShowImagePicker : Bool
        var body: some View {
            Form{
                
            
                CommonFileds(fullname: $fullname, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender, adresse: $adresse,image: $image,shouldShowImagePicker: $shouldShowImagePicker)
              
                Button(action: {
                    
                    updateCommonFileds()
                                    
                }, label: {
                    Text("Save")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .cornerRadius(50).padding()
                })
            
           
            }.scrollContentBackground(.hidden)
        }
        func updateCommonFileds(){
            
            let user = UserModel(name: fullname, email: email, genders: selected_gender.rawValue, birthdate: birthdate.displayForamt, adresse: adresse, role: "patient", firstname: firstname, lastname: lastname)
            ApiManager.shareInstance.callingUpdateApi(Update: user)
            {
                
                (result) in
                 switch result
                 {
                 case .success:
                     do {
                         print("sa7a")


                       //  navigateToMainPage = true
                     }
                     
                 case .failure:
                     
                    print("fuck no")
                     
                 }
                
                
                
                
            }
            
        }
       
    }

    
    struct ChosenRoleDoctorView : View {
        @Binding var fullname: String
        @Binding var email: String
        @Binding var firstname: String
        @Binding var lastname: String
        @Binding var birthdate : Date
        @Binding var selected_gender : Gender
        @Binding var adresse: String
        @Binding var  selected_specialite :Specialite
        @Binding var  yearsOfpractice: String
        @Binding var  patientnb: String
        @Binding var  description: String
        @Binding var image: UIImage?
        @Binding var shouldShowImagePicker : Bool
        var body: some View {
            Form{
                    CommonFileds(fullname: $fullname, email: $email, firstname: $firstname, lastname: $lastname, birthdate: $birthdate, selected_gender: $selected_gender, adresse: $adresse,image: $image,shouldShowImagePicker: $shouldShowImagePicker)
                    Picker("Your specialty", selection: $selected_specialite){
                        ForEach(Specialite.allCases,id :\.self){
                            Text($0.rawValue)
                        }
                    }.padding().foregroundColor(Color.gray)
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    TextField("How many years of practice",text: $yearsOfpractice)
                        .padding()
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    TextField("How many patient do you have",text: $patientnb)
                        .padding()
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    TextField("Description",text: $description)
                        .padding()
                        .frame(maxWidth : .infinity)
                        .background(Color.white)
                        .cornerRadius(50.5)
                        .shadow(color: Color.black.opacity(0.08), radius: 60 ,x: 0.0,y:16)
                        .padding()
                    Button(action: {
                        
                        updateCommonFileds()
                        updateDocteurFileds()
                        
                    }, label: {
                        Text("Save")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .cornerRadius(50).padding()
                    })
            
            }.scrollContentBackground(.hidden)
                
                


            
            }
        func updateCommonFileds(){
            
            let user = UserModel(name: fullname, email: email, genders: selected_gender.rawValue, birthdate: birthdate.displayForamt, adresse: adresse, role: "doctor", firstname: firstname, lastname: lastname)
            ApiManager.shareInstance.callingUpdateApi(Update: user)
            {
                
                (result) in
                 switch result
                 {
                 case .success:
                     do {
                         print("sa7a")


                       //  navigateToMainPage = true
                     }
                     
                 case .failure:
                     
                    print("fuck no")
                     
                 }
                
                
                
                
            }
            
        }
        func updateDocteurFileds(){
            
            let user = UserModel(email: email,specialite: selected_specialite.rawValue, experience: yearsOfpractice, patient: patientnb, description:description)
            
    
            ApiManager.shareInstance.callingUpdateDocteurApi(Update: user)
            {
                
                (result) in
                 switch result
                 {
                 case .success:
                     do {
                         print("sa7a")


                       //  navigateToMainPage = true
                     }
                     
                 case .failure:
                     
                    print("fuck no")
                     
                 }
                
                
                
                
            }
            
        }
        
    }
    
    
}
struct ImagePicker: UIViewControllerRepresentable {
 
    @Binding var image: UIImage?
    @Binding var email: String

 
    private let controller = UIImagePickerController()
 
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self,email: email)
    }
 
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
        let parent: ImagePicker
        let email: String
        init(parent: ImagePicker,email: String) {
            self.parent = parent
            self.email = email

        }
 
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.editedImage] as? UIImage else {
                picker.dismiss(animated: true)
                return
            }
            parent.image = image
            ApiManager.shareInstance.uploadImage(image, email: email) { result in
                switch result {
                case .success:
                    // Display an alert to confirm upload
                    let alert = UIAlertController(title: "Image uploaded", message: "Your image was successfully uploaded.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    picker.present(alert, animated: true)
                case .failure(let error):
                    // Display an alert with the error message
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    picker.present(alert, animated: true)
                }
            }
            
            // Dismiss the picker
            picker.dismiss(animated: true)
        }
 
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        

 
    }
 
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        controller.allowsEditing = true
        return controller
    }
 
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
 
    }
    


 
}

struct UserImage: View {
    @Binding var image: UIImage?
    @Binding var shouldShowImagePicker : Bool

    
    var body: some View {
        Button(action: {
            shouldShowImagePicker.toggle()
        }, label: {
            
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 143, height: 143)
                        .cornerRadius(80)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 80))
                        .padding()
                        .foregroundColor(Color(.label))
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 80)
                .stroke(Color.accentColor, lineWidth: 3)
            )
            
            
        })
    }
}
