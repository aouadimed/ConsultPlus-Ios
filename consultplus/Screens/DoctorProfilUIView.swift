//
//  DoctorProfilUIView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 18/4/2023.
//

import SwiftUI
import KeychainAccess
import MapKit


struct DoctorProfilUIView: View {
    @State private var name: String = ""
    @State var image: UIImage?
    @State var numPatients: Double = 1.4
    @State var experience: Int = 9
    @State var rating: Double = 4.0
    @State private var description: String = "dddddddddd"

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
                                VStack(spacing: 30) {
                                    HStack(spacing: 55) {
                                        Text("Patients")
                                            .font(.custom("Roboto Regular", size: 18))
                                            .foregroundColor(Color.black)
                                            .frame(width: 100)
                                        
                                        Text("Experience")
                                            .font(.custom("Roboto Regular", size: 18))
                                            .foregroundColor(Color.black)
                                            .frame(width: 100)
                                        
                                        Text("Rating")
                                            .font(.custom("Roboto Regular", size: 18))
                                            .foregroundColor(Color.black)
                                            .frame(width: 70)
                                    }
                                    
                                    HStack(spacing: 55) {
                                        Text("\(numPatients, specifier: "%.1f") K")
                                            .font(.custom("Roboto Regular", size: 18))
                                            .foregroundColor(Color.black)
                                            .frame(width: 100)
                                        
                                        Text("\(experience) yr")
                                            .font(.custom("Roboto Regular", size: 18))
                                            .foregroundColor(Color.black)
                                            .frame(width: 100)
                                        
                                        Text("\(rating, specifier: "%.1f")")
                                            .font(.custom("Roboto Regular", size: 18))
                                            .foregroundColor(Color.black)
                                            .frame(width: 70)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 30)
                                
                                HStack {
                                    Text("About")
                                        .fontWeight(.bold)
                                        .padding(.bottom, 10)
                                    Spacer()
                                }
                                .padding(.leading, 10).padding(.top,20)
                                
                                HStack {
                                    Text(description)
                                        .fontWeight(.regular)
                                        .padding(.bottom, 10)
                                    Spacer()
                                }
                                .padding(.leading, 20)
                                HStack {
                                    Text("Location")
                                        .fontWeight(.bold)
                                        .padding(.bottom, 10)
                                    Spacer()
                                }.padding(.leading, 10).padding(.top,20)
                                
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.white)
                                        .shadow(radius: 30)
                                    MapCardView(address: "Rue Abderrahmene El Ghafeki, Ariana") .cornerRadius(30)
                                        .frame(height: 200)
                                }
                                .frame(width: UIScreen.main.bounds.width - 40, height: 160)
                                .background(RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)).padding().padding(.top,20)
                                
                            
                                AppointmentCardView().padding(.top,40).padding(.bottom,40)
                                
                     
                                

                                
                                
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

struct DoctorProfilUIView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorProfilUIView()
    }
}


struct ProfileCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 340, height: 180)
                .foregroundColor(Color.white)
                .shadow(radius: 5)
            
            HStack {
                RoundedRectangle(cornerRadius: 150)
                    .frame(width: 150, height: 150)
                    .foregroundColor(Color.white)
                    .shadow(radius: 30)
                    .overlay(
                        Image("img")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Dr.")
                            .font(.custom("Poppins-Bold", size: 20))
                            .foregroundColor(Color.black)
                        Text("Mohamed")
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(Color.black)
                    }
                    Text("Aouadi")
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundColor(Color.black)
                    
                    HStack {
                        Text("Dermatology")
                            .font(.custom("Poppins", size: 20))
                            .foregroundColor(Color.black)
                    }
                }
                .padding(.leading, 20)
            }
            .frame(width: 300)
         
        }
    }
}


struct AppointmentCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .shadow(radius: 30)

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Instant Appointment")
                        .font(.custom("Poppins-Bold", size: 15))
                        .foregroundColor(.black)

                    Text("Lorem ipsum dolor sit amet, consectetur.")
                        .font(.custom("Roboto-Regular", size: 15))
                        .foregroundColor(.black)
                        .frame(width: 160, alignment: .leading)

                    Button(action: {
                        // Handle button tap
                    }) {
                        Text("Book Appointment")
                            .font(.custom("Roboto-Regular", size: 8))
                            .foregroundColor(.white)
                            .frame(width: 100, height: 32)
                            .background(RoundedRectangle(cornerRadius: 16)
                                .fill(Color.accentColor))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 10)
                }

                Spacer()

                Image("undraw_medicine")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 130, height: 92)
                    .cornerRadius(30)
            }
            .padding(20)
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 160)
        .background(RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1))
    }
}
struct MapCardView: UIViewRepresentable {
    var address: String
    let regionRadius: CLLocationDistance = 1000
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.delegate = context.coordinator
        
        // Convert address to coordinates and center map on location
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let location = placemarks?.first?.location {
                let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
                
                // Add pin at location
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                mapView.addAnnotation(annotation)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapCardView
        
        init(_ parent: MapCardView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            return view
        }
    }
}
