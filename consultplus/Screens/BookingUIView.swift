//
//  BookingUIView.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 18/4/2023.
//

import SwiftUI
import KeychainAccess
import Combine


struct BookingUIView: View {
    let times = [
        TimeView(time: "10:00", endTime: "11:00", isSelected: false, selectTime: {}),
        TimeView(time: "11:00", endTime: "12:00", isSelected: false, selectTime: {}),
        TimeView(time: "12:00", endTime: "13:00", isSelected: false, selectTime: {}),
        TimeView(time: "13:00", endTime: "14:00", isSelected: false, selectTime: {}),
        TimeView(time: "14:00", endTime: "15:00", isSelected: false, selectTime: {}),
        TimeView(time: "15:00", endTime: "16:00", isSelected: false, selectTime: {}),
        TimeView(time: "16:00", endTime: "17:00", isSelected: false, selectTime: {}),
        TimeView(time: "17:00", endTime: "18:00", isSelected: false, selectTime: {}),
        TimeView(time: "18:00", endTime: "19:00", isSelected: false, selectTime: {})
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let calendar = Calendar.current
    let start = Date()
    let doctorEmail: String?
    @State private var name: String = ""
    @State var image: UIImage?
    @State private var selectedMonthYear = ""
    @State private var scrollViewGeometry: GeometryProxy?
     @State private var visibleMonthYears: [String] = []
    @State private var scrollView: UIScrollView?
    @State private var scrollViewWidth: CGFloat = 0
    @State var  firstname : String? = ""
    @State  var lastname : String? = ""
    @State  var doctorimage :UIImage?
    @State  var specialite: String? = ""
    @State  var DoctorId: String? = ""
    @State  var patientId: String? = ""
    @State private var selectedDate: Date?
      @State private var selectedTime: String?
    @State private var selectedTimeIndex: Int?
    @State private var showingConfirmationDialog = false

    init(doctorEmail: String? = nil) {
        self.doctorEmail = doctorEmail
    }

/*
    var showIndicators :Bool
    var axis 
    init(@ViewBuilder content: ()->Content,offset: Binding<CGFloat>,showIndicators: Bool,axis:Axis.Set){
        self.content = content()
        self._offset = offset
        self.showIndicators =showIndicators
        self.axis = axis
    }
*/
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
                                ProfileCardView(firstname: self.$firstname, lastname: self.$lastname, doctorimage: self.$doctorimage, specialite: self.$specialite).padding()
                                Divider().frame(width: 320,height: 2).padding()
                                HStack {
                                    Text("Date")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(self.selectedMonthYear)
                                        .fontWeight(.bold).padding(.trailing,10)
                                }
                                .padding(.leading, 10)
                                GeometryReader { geometry in
                                    ScrollViewReader { proxy in
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(0..<365, id: \.self) { index in
                                                    let date = calendar.date(byAdding: .day, value: index, to: start)!
                                                    CustomView(date: date, isSelected: Binding(get: {
                                                        if let selectedDate = selectedDate {
                                                            return calendar.isDate(date, inSameDayAs: selectedDate)
                                                        } else {
                                                            return false
                                                        }
                                                    }, set: { newValue in
                                                        if newValue {
                                                            selectedDate = date
                                                        } else {
                                                            selectedDate = nil
                                                        }
                                                    })) {
                                                        selectedDate = date
                                                        print(date)
                                                    }
                                                        
                                                    
                                                        .id(formatDate(date: date))
                                                        .background(GeometryReader { geometry in
                                                            Color.clear
                                                                .onAppear {
                                                                    if shouldPrintMonthYear(proxy: proxy, index: index, geometry: geometry) {
                                                                        let monthYear = formatDate(date: date)
                                                                        // Print the current month-year to the console
                                                                        print(monthYear)
                                                                        selectedMonthYear = monthYear
                                                                    }
                                                                }
                                                        })
                                                }
                                                
                                            }
                                            }.onChange(of: scrollView?.contentOffset) { value in
                                             print("value")
                                                if let scrollViewContentOffset = value?.x {
                                                    let relativeOffset = scrollViewContentOffset / scrollViewWidth
                                                    let currentIndex = Int(round(relativeOffset * 365))
                                                    let date = calendar.date(byAdding: .day, value: currentIndex, to: start)!
                                                    let monthYear = formatDate(date: date)
                                                    // Update the selectedMonthYear variable
                                                    self.selectedMonthYear = monthYear
                                                    print(monthYear)
                                                }
                                         





                                        }
                                    }
                                    .onAppear {
                                        // Store the geometry of the scroll view in a variable
                                        self.scrollViewGeometry = geometry
                                        self.scrollViewWidth = geometry.size.width

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
                                            TimeView(
                                                time: times[i].time,
                                                endTime: times[i].endTime,
                                                isSelected: selectedTimeIndex == i,
                                                selectTime: {
                                                    selectedTime = "\(times[i].time) - \(times[i].endTime)"
                                                    selectedTimeIndex = i
                                                    print(selectedTime)
                                                }
                                            )
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                }
                                .frame(height: 200)

                                
                                Button(action: {
                                    showingConfirmationDialog = true
                                }, label: {
                                    Text("BOOK APPOINTMENT")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color("AccentColor"))
                                        .cornerRadius(50)
                                        .padding().padding(.bottom,60)
                                })
                                .alert(isPresented: $showingConfirmationDialog) {
                                    Alert(
                                        title: Text("Confirm booking"),
                                        message: Text("Are you sure you want to book this appointment?"),
                                        primaryButton: .default(Text("Book")) {
                                            BookAppointment()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                      
                        
                       
                        
                    }
                        
                        
           
                    
                }.edgesIgnoringSafeArea(.bottom)
            

        }.onAppear {
            userdatils()
            DocotrInformation()
}

    }
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, yyyy"
        return dateFormatter.string(from: date)
    }
    func shouldPrintMonthYear(proxy: ScrollViewProxy, index: Int, geometry: GeometryProxy) -> Bool {
        guard let scrollViewGeometry = scrollViewGeometry else {
            return false
        }

        let visibleRect = CGRect(origin: scrollViewGeometry.frame(in: .global).origin, size: scrollViewGeometry.size)
        let rect = geometry.frame(in: .global)
        let intersection = visibleRect.intersection(rect)
        return intersection.width > 0 && intersection.height > 0
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
    func DocotrInformation(){
        let user = UserModel(email: doctorEmail)
        ApiManager.shareInstance.callingUserDataApi(UserData: user) { result in
            switch result {
            case .success(let userResponse as ApiManager.UserResponse):
                do {
                    print("sa7a")
                    // Accessing the name and role properties of the UserResponse object
                    self.firstname = userResponse.firstname ?? ""
                    self.lastname = userResponse.lastname ?? ""
                    self.specialite = userResponse.specialite ?? ""
                    let filename = userResponse.image ?? "person.fill"
                    let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let directoryUrl = documentsUrl.appendingPathComponent("ConsultPlus")
                    let fileUrl = directoryUrl.appendingPathComponent(filename)
                    let imageData = try Data(contentsOf: fileUrl)
                    self.doctorimage = UIImage(data: imageData)
                    self.DoctorId = userResponse.id
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
    
    func BookAppointment(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate!)
        let timeString: String? = selectedTime
        let formattedTimeString = timeString?.components(separatedBy: " ").first ?? "" // formattedTimeString = "11:00"
        let Booking = Booking(date: dateString, time: formattedTimeString, status: 0, doctor: DoctorId!, patient: patientId!)
        ApiManager.shareInstance.callingBookingApi(Booking: Booking)
        {
            
            (result) in
             switch result
             {
             case .success:
                 do {
               
                     print("sa7a")
                 
                 }
                 
             case .failure:
                 
                print("no")

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
    let action: () -> Void // closure parameter
    @Binding var isSelected: Bool
    
    init(date: Date, isSelected: Binding<Bool>, action: @escaping () -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        self.day = formatter.string(from: date)
        formatter.dateFormat = "d"
        self.date = formatter.string(from: date)
        self.action = action
        self._isSelected = isSelected
    }
    
    var body: some View {
        VStack(spacing: 12.10) {
            Text(day.prefix(1).capitalized)
                .font(.custom("Poppins-Medium", size: 15))
                .foregroundColor(isSelected ? .white : .accentColor)
            Text(date)
                .font(.custom("Poppins-Medium", size: 20))
                .foregroundColor(isSelected ? .white : .black)
        }.frame(width: 25, height: 60)
        .padding(.horizontal, 12.10)
        .padding(.vertical, 9.10)
        .background(RoundedRectangle(cornerRadius: 30)
            .fill(isSelected ? Color.accentColor : Color.white)
            .shadow(radius: 10))
        .padding(EdgeInsets(top:20,leading:10,bottom: 20,trailing: 0))
        .onTapGesture {
            isSelected.toggle()
            action() // execute the closure when tapped
        }
    }
}





struct TimeView: View {
    let time: String
    let endTime: String
    let isSelected: Bool
    let selectTime: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(time)
                    .font(.custom("Poppins-Medium", size: 14.30))
                    .foregroundColor(isSelected ? .white : .black)
                Text(" - ")
                    .font(.custom("Poppins-Medium", size: 14.30))
                    .foregroundColor(isSelected ? .white : .black)
                Text(endTime)
                    .font(.custom("Poppins-Medium", size: 14.30))
                    .foregroundColor(isSelected ? .white : .black)
            }
            .padding(.vertical, 10.40)
        }
        .frame(width: 110, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? Color.accentColor: Color.white)
                .shadow(radius: 2, x: 0, y: 2)
        )
        .padding(.horizontal, 10.40)
        .padding(.vertical, 6.50)
        .onTapGesture {
            selectTime()
        }
    }
}




struct ScrollViewReaderHelper: UIViewRepresentable {
    
    static let publisher = PassthroughSubject<[CGRect], Never>()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        let visibleRects = uiView.subviews.map { $0.frame }
        Self.publisher.send(visibleRects)
    }
}
