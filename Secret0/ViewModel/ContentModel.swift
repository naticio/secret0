//
//  ContentModel.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Firebase
import SwiftUI
import GeoFire

class ContentModel: ObservableObject{
    
    
    @Published var matches = [Matches]()
    @Published var usersLoaded : Bool =  false
    
    @Published var userDataCompletion = false
    @Published var loggedIn = false //assume user is not loggfed in,published to notify al views that use this property
    //but still this doesn;t mean the user is logedout...we need to check that as well
    
    @Published var onboardingIndex = 0
    @Published var isOnboarding = false
    
    //matches images
    @Published var images: [UIImage] = [UIImage()]
    
    @Published var usernameSignUp = ""
    @Published var emailSignUp = ""
    @Published var passwordSignUp = ""
    @Published var birthdate: Date = Date()
    @Published var locationModel: String = ""
    @Published var genderModel: String = ""
    @Published var sexualityModel: String = ""
    @Published var datingPrefModel: String = ""
    @Published var heightModel: Int = 0
    @Published var Q1day2liveModel: String = ""
    @Published var QlotteryWinModel: String = ""
    @Published var QmoneynotanIssueModel: String = ""
    @Published var bucketListModel: String = ""
    @Published var jokesModel: String = ""
    
    
    let db = Firestore.firestore()
    
    init() {
        let matchDummy = Matches()
        matchDummy.name = "Poncho de Nigris"
        matchDummy.birthdate = Date()
        matchDummy.gender = "Male"
        matchDummy.height = 180
        matchDummy.latitude = 32
        matchDummy.longitude = 50
        matchDummy.datingPreferences = "Women"
        matchDummy.sexuality = "Straight"
        
        matchDummy.imageUrl1 = "https://firebasestorage.googleapis.com/v0/b/secret0-63695.appspot.com/o/4rX78fIQPPeWaJIr8OUuQ8bHNgq2%2F2A846400-EEE3-4244-A6D4-6952ED07675D?alt=media&token=0299ed53-1d8d-4aaf-b997-7ffc98ca1937"
        matchDummy.imageUrl2 = "https://firebasestorage.googleapis.com/v0/b/secret0-63695.appspot.com/o/4rX78fIQPPeWaJIr8OUuQ8bHNgq2%2F2A846400-EEE3-4244-A6D4-6952ED07675D?alt=media&token=0299ed53-1d8d-4aaf-b997-7ffc98ca1937"
        matchDummy.imageUrl3 = "https://firebasestorage.googleapis.com/v0/b/secret0-63695.appspot.com/o/4rX78fIQPPeWaJIr8OUuQ8bHNgq2%2F2A846400-EEE3-4244-A6D4-6952ED07675D?alt=media&token=0299ed53-1d8d-4aaf-b997-7ffc98ca1937"
        matchDummy.imageUrl4 = "http://www.profightdb.com/img/wrestlers/thumbs-600/213517f78aponchodenegris.jpg"
        matchDummy.imageUrl5 = "https://firebasestorage.googleapis.com/v0/b/secret0-63695.appspot.com/o/4rX78fIQPPeWaJIr8OUuQ8bHNgq2%2F2A846400-EEE3-4244-A6D4-6952ED07675D?alt=media&token=0299ed53-1d8d-4aaf-b997-7ffc98ca1937"
        matchDummy.imageUrl6 = "http://www.profightdb.com/img/wrestlers/thumbs-600/213517f78aponchodenegris.jpg"
        
        matchDummy.Q1day2live = "Alfonso de Nigris Guajardo (Monterrey, Nuevo León, México; 3 de marzo de 1976), conocido como Poncho de Nigris, es un presentador, actor, bailarín e influencer mexicano. Es hermano de los exfutbolistas Aldo de Nigris y Antonio de Nigris"
        matchDummy.QlotteryWin = "Alfonso de Nigris Guajardo nació el 3 de marzo de 1973 en Monterrey, Nuevo León. Hijo de Alfonso de Nigris Dávila y de Leticia Guajardo Cantú, es el mayor de los hermanos Antonio de Nigris y Aldo de Nigris"
        matchDummy.QmoneynotanIssue = "s egresado del ITESM Campus Monterrey como Licenciado en Administración de Empresas. Inició su carrera en el mundo del espectáculo tras participar en la segunda temporada del reality show, Big Brother "
        matchDummy.bucketList = "Ser cantante"
        matchDummy.jokes = "Ya llego papa"
        matchDummy.city = "NYC"

        self.matches.append(matchDummy)
    }
    
    //MARK: - authentication methods
    func checkLogin() {
        //to check if user is logged in or not every time the app opens
        loggedIn = Auth.auth().currentUser == nil ? false : true
        //if current user is nil then loggedin = false
        
        //CHECK IF USERR metadata has been FETCHED. if the user was already logged in from a previous session, we need to get their data in a separate call
        if UserService.shared.user.name == "" {
            getUserData() //to fetch metadata related to user
        }
    }
    
    //retrieve user data for the first time
    func getUserData() {
        
        // Check that there's a logged in user
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Get the meta data for that user
        let db = Firestore.firestore()
        //let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        let ref = db.collection("users").document(Auth.auth().currentUser!.displayName ??  "")
        
        ref.getDocument { snapshot, error in
            
            // Check there's no errors
            guard error == nil, snapshot != nil else {
                return
            }
            
            // Parse the data out and set the user meta data
            let data = snapshot!.data()
            let user = UserService.shared.user
            
            user.name = data?["name"] as? String ?? ""
            user.birthdate = data?["birthdate"] as? Date ?? Date()
            user.gender = data?["gender"] as? String ?? ""
            user.height = data?["height"] as? Int ?? 0
            user.latitude = data?["latitude"] as? Double ?? 0.0
            user.longitude = data?["longitude"] as? Double ?? 0.0
            user.datingPreferences = data?["datingPreferences"] as? String ?? ""
            user.sexuality = data?["sexuality"] as? String ?? ""
            
            //did I use photo as prefix when saving in firebase?
            user.imageUrl1 = data?["photo1"] as? String ?? ""
            user.imageUrl2 = data?["photo2"] as? String ?? ""
            user.imageUrl3 = data?["photo3"] as? String ?? ""
            user.imageUrl4 = data?["photo4"] as? String ?? ""
            user.imageUrl5 = data?["photo5"] as? String ?? ""
            user.imageUrl6 = data?["photo6"] as? String ?? ""
            
            user.Q1day2live = data?["Q1day2live"] as? String ?? ""
            user.QlotteryWin = data?["QlotteryWin"] as? String ?? ""
            user.QmoneynotanIssue = data?["QmoneynotanIssue"] as? String ?? ""
            user.bucketList = data?["bucketList"] as? String ?? ""
            user.jokes = data?["jokes"] as? String ?? ""
            
            DispatchQueue.main.async {
                self.userDataCompletion = true
            }
        }
    }
    
    func getMatches() {
        
        // Get the documents from the collection
        let usersCollection = db.collection("users")
        
        //if user wants to date FEMALE
        let currentUser = UserService.shared.user
        
        if currentUser.datingPreferences == "Women" {
            let query = usersCollection
                .whereField("gender", isEqualTo: "Women")
                //.whereField("geohas", isEqualTo: "mylocation")
                .whereField("datingPreferences", in: [currentUser.gender, "Everyone"])
                
                .addSnapshotListener { snapshot, error in
                    //query.getDocuments { snapshot, error in
                    if error == nil {
                        
                        var matches = [Matches]() //empty array of user/matches instances
                        
                        ///REMOVE THE IFS AS I USE WHERE FIELD ABOVE!
                        for doc in snapshot!.documents {
                            if doc["datingPreferences"] != nil {
                                if doc["datingPreferences"] as! String == currentUser.gender || doc["datingPreferences"] as! String == "Everyone" {
                                    var m = Matches()
                                    m.id = doc["id"] as? String ?? ""
                                    m.name = doc["name"] as? String ?? ""
                                    m.birthdate = doc["birthdate"] as? Date ?? Date()
                                    m.gender = doc["gender"] as? String ?? ""
                                    m.datingPreferences = doc["datingPreferences"] as? String ?? ""
                                    m.height = doc["height"] as? Int ?? 0
                                    m.latitude = doc["latitude"] as? Double ?? 0.0
                                    m.longitude = doc["longitude"] as? Double ?? 0.0
                                    
                                    m.imageUrl1 = doc["photo1"] as? String ?? ""
                                    m.imageUrl2 = doc["photo2"] as? String ?? ""
                                    m.imageUrl3 = doc["photo3"] as? String ?? ""
                                    m.imageUrl4 = doc["photo4"] as? String ?? ""
                                    m.imageUrl5 = doc["photo5"] as? String ?? ""
                                    m.imageUrl6 = doc["photo6"] as? String ?? ""
                                    
                                    m.Q1day2live = doc["Q1day2live"] as? String ?? ""
                                    m.QlotteryWin = doc["QlotteryWin"] as? String ?? ""
                                    m.QmoneynotanIssue = doc["QmoneynotanIssue"] as? String ?? ""
                                    m.bucketList = doc["bucketList"] as? String ?? ""
                                    m.jokes = doc["jokes"] as? String ?? ""
                                    
                                    matches.append(m)
                                }
                            }
                            
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.matches = matches
                            self.usersLoaded = true
                        }
                    }
                }
            
        }
        
        //if user wants to date MALE
        if currentUser.datingPreferences == "Men" {
            let query = usersCollection
                .whereField("gender", isEqualTo: "Men")
                .whereField("datingPreferences", in: [currentUser.gender, "Everyone"])
                
                .addSnapshotListener { snapshot, error in
                    
                    //query.getDocuments { snapshot, error in
                    if error == nil {
                        
                        var matches = [Matches]() //empty array of user/matches instances
                        
                        for doc in snapshot!.documents {
                            if doc["datingPreferences"] != nil {
                                if doc["datingPreferences"] as! String == currentUser.gender || doc["datingPreferences"] as! String == "Everyone" {
                                    var m = Matches()
                                    //q.id = doc["id"] as? String ?? ""
                                    m.name = doc["name"] as? String ?? ""
                                    m.birthdate = doc["birthdate"] as? Date ?? Date()
                                    m.gender = doc["gender"] as? String ?? ""
                                    m.datingPreferences = doc["datingPreferences"] as? String ?? ""
                                    m.height = doc["height"] as? Int ?? 0
                                    m.latitude = doc["latitude"] as? Double ?? 0.0
                                    m.longitude = doc["longitude"] as? Double ?? 0.0
                                    
                                    m.imageUrl1 = doc["photo1"] as? String ?? ""
                                    m.imageUrl2 = doc["photo2"] as? String ?? ""
                                    m.imageUrl3 = doc["photo3"] as? String ?? ""
                                    m.imageUrl4 = doc["photo4"] as? String ?? ""
                                    m.imageUrl5 = doc["photo5"] as? String ?? ""
                                    m.imageUrl6 = doc["photo6"] as? String ?? ""
                                    
                                    m.Q1day2live = doc["Q1day2live"] as? String ?? ""
                                    m.QlotteryWin = doc["QlotteryWin"] as? String ?? ""
                                    m.QmoneynotanIssue = doc["QmoneynotanIssue"] as? String ?? ""
                                    m.bucketList = doc["bucketList"] as? String ?? ""
                                    m.jokes = doc["jokes"] as? String ?? ""
                                    
                                    matches.append(m)
                                    
                                }
                                
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.matches = matches
                            self.usersLoaded = true
                        }
                    }
                }
            
        }
        
        //if user wants to date EVERYONE
        if currentUser.datingPreferences == "Everyone" {
            let query = usersCollection
                .whereField("datingPreferences", in: [currentUser.gender, "Everyone"])
                
                .addSnapshotListener { snapshot, error in
                    
                    //query.getDocuments { snapshot, error in
                    if error == nil {
                        
                        var matches = [Matches]() //empty array of user/matches instances
                        
                        for doc in snapshot!.documents {
                            if doc["datingPreferences"] != nil {
                                if doc["datingPreferences"] as! String == currentUser.gender || doc["datingPreferences"] as! String == "Everyone" {
                                    var m = Matches()
                                    //q.id = doc["id"] as? String ?? ""
                                    m.name = doc["name"] as? String ?? ""
                                    m.birthdate = doc["birthdate"] as? Date ?? Date()
                                    m.gender = doc["gender"] as? String ?? ""
                                    m.datingPreferences = doc["datingPreferences"] as? String ?? ""
                                    m.height = doc["height"] as? Int ?? 0
                                    m.latitude = doc["latitude"] as? Double ?? 0.0
                                    m.longitude = doc["longitude"] as? Double ?? 0.0
                                    
                                    m.imageUrl1 = doc["photo1"] as? String ?? ""
                                    m.imageUrl2 = doc["photo2"] as? String ?? ""
                                    m.imageUrl3 = doc["photo3"] as? String ?? ""
                                    m.imageUrl4 = doc["photo4"] as? String ?? ""
                                    m.imageUrl5 = doc["photo5"] as? String ?? ""
                                    m.imageUrl6 = doc["photo6"] as? String ?? ""
                                    
                                    m.Q1day2live = doc["Q1day2live"] as? String ?? ""
                                    m.QlotteryWin = doc["QlotteryWin"] as? String ?? ""
                                    m.QmoneynotanIssue = doc["QmoneynotanIssue"] as? String ?? ""
                                    m.bucketList = doc["bucketList"] as? String ?? ""
                                    m.jokes = doc["jokes"] as? String ?? ""
                                    
                                    matches.append(m)
                                    
                                    DispatchQueue.main.async {
                                        self.matches = matches
                                        self.usersLoaded = true
                                    }
                                }
                            }
                            
                            
                        }
                        
                    }
                }
        }
        
    }
    
    //MARK: - GET MATCHES WITH GEOHASH
    func getMatchesNearMe(radius: Double) {
        // Find matches within 50km of my location
        let user = UserService.shared.user
        let center = CLLocationCoordinate2D(latitude: user.latitude ?? 0, longitude: user.longitude ?? 0)
        let radiusInKilometers: Double = radius
        
        // Each item in 'bounds' represents a startAt/endAt pair. We have to issue
        // a separate query for each pair. There can be up to 9 pairs of bounds
        // depending on overlap, but in most cases there are 4.
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                                              withRadius: radiusInKilometers)
        let queries = queryBounds.compactMap { (any) -> Query? in
            guard let bound = any as? GFGeoQueryBounds else { return nil }
            
            //results for matches that prefer men
            if user.datingPreferences == "Women" {
                return db.collection("users")
                    .order(by: "geohash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
                    .whereField("gender", isEqualTo: "Women")
                    .whereField("datingPreferences", in: [user.gender, "Everyone"])
            }
            
            //results for matches that prefer women
            if user.datingPreferences == "Men" {
                return db.collection("users")
                    .order(by: "geohash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
                    .whereField("gender", isEqualTo: "Men")
                    .whereField("datingPreferences", in: [user.gender, "Everyone"])
            }
            
            //results for matches that like tocho
            if user.datingPreferences == "Everybody" {
                return db.collection("users")
                    .order(by: "geohash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
                    .whereField("datingPreferences", in: [user.gender, "Everyone"])
            }
            
            return nil
        }
        
        var matchingDocs = [Matches]()
        // Collect all the query results together into a single list
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
            guard let documents = snapshot?.documents else {
                print("Unable to fetch snapshot data. \(String(describing: error))")
                return
            }
            
            print("\nDocs: Count \(documents.count)")
            for doc in snapshot!.documents {
                var m = Matches()
                m.latitude = doc.data()["latitude"] as? Double ?? 0
                m.longitude = doc.data()["longitude"] as? Double ?? 0
                let coordinates = CLLocation(latitude: m.latitude ?? 0, longitude: m.longitude ?? 0)
                let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
                
                m.id = doc.data()["id"] as? String ?? ""
                m.name = doc.data()["name"] as? String ?? ""
                m.birthdate = doc.data()["birthdate"] as? Date ?? Date()
                m.gender = doc.data()["gender"] as? String ?? ""
                m.datingPreferences = doc.data()["datingPreferences"] as? String ?? ""
                m.height = doc.data()["height"] as? Int ?? 0
                
                m.imageUrl1 = doc.data()["photo1"] as? String ?? ""
                m.imageUrl2 = doc.data()["photo2"] as? String ?? ""
                m.imageUrl3 = doc.data()["photo3"] as? String ?? ""
                m.imageUrl4 = doc.data()["photo4"] as? String ?? ""
                m.imageUrl5 = doc.data()["photo5"] as? String ?? ""
                m.imageUrl6 = doc.data()["photo6"] as? String ?? ""
                
                m.Q1day2live = doc.data()["Q1day2live"] as? String ?? ""
                m.QlotteryWin = doc.data()["QlotteryWin"] as? String ?? ""
                m.QmoneynotanIssue = doc.data()["QmoneynotanIssue"] as? String ?? ""
                m.bucketList = doc.data()["bucketList"] as? String ?? ""
                m.jokes = doc.data()["jokes"] as? String ?? ""
                
                // We have to filter out a few false positives due to GeoHash accuracy, but
                // most will match
                let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                print("MatchName: \(m.name), distance: \(distance) \tlat: \(m.latitude), \(m.longitude)")
                if distance <= radiusInKilometers {
                    matchingDocs.append(m)
                }
            } //end for loop
            
            self.matches = matchingDocs
            self.usersLoaded = true
        }
        
        // After all callbacks have executed, matchingDocs contains the result. Note that this
        // sample does not demonstrate how to wait on all callbacks to complete.
        for query in queries {
            query.addSnapshotListener(getDocumentsCompletion)
//            query
//                .whereField("gender", in: ["Women", "men"])
//                .whereField("conversations", notIn: [user.name])
//                //.getDocuments(completion: getDocumentsCompletion)
//                .addSnapshotListener(getDocumentsCompletion)
        }
        print("Docs: \(matchingDocs.count)")
        
    }
    
    func getMatchesNearMeDispatch(radius: Double) {
        // Find matches within 50km of my location
        let user = UserService.shared.user
        let center = CLLocationCoordinate2D(latitude: user.latitude ?? 0, longitude: user.longitude ?? 0)
        let radiusInKilometers: Double = radius
        
        // Each item in 'bounds' represents a startAt/endAt pair. We have to issue
        // a separate query for each pair. There can be up to 9 pairs of bounds
        // depending on overlap, but in most cases there are 4.
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                                              withRadius: radiusInKilometers)
        let queries = queryBounds.compactMap { (any) -> Query? in
            guard let bound = any as? GFGeoQueryBounds else { return nil }
            //results for matches that prefer men
            if user.datingPreferences == "Women" {
                return db.collection("users")
                    .order(by: "geohash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
                    .whereField("gender", isEqualTo: "Women")
                    .whereField("datingPreferences", in: [user.gender, "Everyone"])
                    //.whereField("conversations", notIn: [user.name]) //I don't have a convo with this user already
            }
            
            //results for matches that prefer women
            if user.datingPreferences == "Men" {
                return db.collection("users")
                    .order(by: "geohash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
                    .whereField("gender", isEqualTo: "Men")
                    .whereField("datingPreferences", in: [user.gender, "Everyone"])
                    //.whereField("conversations", notIn: [user.name])
            }
            
            //results for matches that like tocho
            if user.datingPreferences == "Everybody" {
                return db.collection("users")
                    .order(by: "geohash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
                    .whereField("datingPreferences", in: [user.gender, "Everyone"])
                    //.whereField("conversations", notIn: [user.name])
            }
            
            return nil
        }
        
        // Create a dispatch group outside of the query loop since each iteration of the loop
        // performs an asynchronous task.
        let dispatch = DispatchGroup()
        
        var matchingDocs = [QueryDocumentSnapshot]()
        var matchesNear = [Matches]()
        // Collect all the query results together into a single list
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
            guard let documents = snapshot?.documents else {
                print("Unable to fetch snapshot data. \(String(describing: error))")
                dispatch.leave() // leave the dispatch group when we exit this completion
                return
            }
            
            print("\nDocs: Count \(documents.count)")
            for doc in documents {
                
                let lat = doc.data()["latitude"] as? Double ?? 0
                let lng = doc.data()["longitude"] as? Double ?? 0
                let name = doc.data()["name"] as? String ?? "no name"
                let coordinates = CLLocation(latitude: lat, longitude: lng)
                let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
                
                // We have to filter out a few false positives due to GeoHash accuracy, but
                // most will match
                let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                //print("MatchName: \(m.name), distance: \(distance) \tlat: \(m.latitude), \(m.longitude)")
                if distance <= radiusInKilometers {
                    matchingDocs.append(doc)
                }
            } //end for loop
            dispatch.leave() // leave the dispatch group when we exit this completion
        }
        
        // After all callbacks have executed, matchingDocs contains the result. Note that this
        // sample does not demonstrate how to wait on all callbacks to complete.
        for query in queries {
            dispatch.enter() // enter the dispatch group on each iteration
            query.getDocuments(completion: getDocumentsCompletion)
        }
        // [END fs_geo_query_hashes]
        // This is the completion handler of the dispatch group. When all of the leave()
        // calls equal the number of enter() calls, this notify function is called.
        dispatch.notify(queue: .main) {
            for doc in matchingDocs {
                let conversationsWith = doc.data()["conversations"] as? [String] ?? []
                
                if conversationsWith.contains(user.name) {
                    //do nothing
                } else {
                    var m = Matches()
                    
                    m.latitude = doc.data()["latitude"] as? Double ?? 0
                    m.longitude = doc.data()["longitude"] as? Double ?? 0
                    let coordinates = CLLocation(latitude: m.latitude ?? 0, longitude: m.longitude ?? 0)
                    let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
                    
                    m.id = doc.data()["id"] as? String ?? ""
                    m.name = doc.data()["name"] as? String ?? ""
                    
                    let birthDateTimestamp = doc.data()["birthdate"] as? Timestamp ?? nil
                    m.birthdate = birthDateTimestamp!.dateValue()
                    m.gender = doc.data()["gender"] as? String ?? ""
                    m.datingPreferences = doc.data()["datingPreferences"] as? String ?? ""
                    m.height = doc.data()["height"] as? Int ?? 0
                    m.city = doc.data()["city"] as? String ?? ""
                    
                    m.imageUrl1 = doc.data()["photo1"] as? String ?? ""
                    m.imageUrl2 = doc.data()["photo2"] as? String ?? ""
                    m.imageUrl3 = doc.data()["photo3"] as? String ?? ""
                    m.imageUrl4 = doc.data()["photo4"] as? String ?? ""
                    m.imageUrl5 = doc.data()["photo5"] as? String ?? ""
                    m.imageUrl6 = doc.data()["photo6"] as? String ?? ""
                    
                    m.Q1day2live = doc.data()["Q1day2live"] as? String ?? ""
                    m.QlotteryWin = doc.data()["QlotteryWin"] as? String ?? ""
                    m.QmoneynotanIssue = doc.data()["QmoneynotanIssue"] as? String ?? ""
                    m.bucketList = doc.data()["bucketList"] as? String ?? ""
                    m.jokes = doc.data()["jokes"] as? String ?? ""
                    
                    let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                    print("MatchName: \(m.name), distance: \(distance) \tlat: \(m.latitude), \(m.longitude)")
                    if distance <= radiusInKilometers {
                        matchesNear.append(m)
                    }
                }
                
            } //end of for loop
            
            DispatchQueue.main.async {
                self.matches = matchesNear
                self.usersLoaded = true
            }
        }
    }
    
    //MARK: - data methods - save data into firebase etc to track the user usage
    //parameter so we don't save to the db every single fucking time...it would be a waste of process! by default false
    func saveUserData(writeToDatabase: Bool = false) {
        
        //make sure user is not nil
        if let loggedInUser = Auth.auth().currentUser { //if auth.auth.currentuser is not nil then it wll lbe assigned to constant loggedInuser and execute code
            //save data locally
            let user = UserService.shared.user //user =  the current user using the app right now
            //            user.birthdate = self.birthdate //save to firebase user the values saved in the content model
            //            user.location = self.locationModel
            //            user.gender = self.genderModel
            //            user.sexuality = self.sexualityModel
            //            user.datingPreferences = self.datingPrefModel
            //            user.height = self.heightModel
            //            user.Q1day2live = self.Q1day2liveModel
            //            user.QlotteryWin = self.QlotteryWinModel
            //            user.QmoneynotanIssue = self.QmoneynotanIssueModel
            //            user.bucketList = self.bucketListModel
            //            user.jokes = self.jokesModel
            
            //save to the database
            //            if writeToDatabase { //equal to true
            //                let db = Firestore.firestore()
            //                let ref = db.collection("users").document(loggedInUser.uid)
            //                ref.setData(["birthdate" : user.birthdate,
            //                             "location" : user.location,
            //                             "gender" : user.gender,
            //                             "sexuality" : user.sexuality,
            //                             "datingPreferences" : user.datingPreferences,
            //                             "height" : user.height,
            //                             "Q1day2live" : user.Q1day2live,
            //                             "QlotteryWin" : user.QlotteryWin,
            //                             "QmoneynotanIssue" : user.QmoneynotanIssue,
            //                             "bucketList" : user.bucketList,
            //                             "jokes" : user.jokes],
            //                            merge: true) //merge into doc, not override
            //            }
            
            
        }
    }
    
    //get 6 images for match
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.images.append(UIImage(data: data) ?? UIImage())
            }
        }
        task.resume()
    }
    
    
    
}

