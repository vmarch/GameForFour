//
//  ViewModel.swift
//  GameForFour
//
//  Created by devtolife on 23.09.21.
//

import MapKit
import SwiftUI

final class ViewModel: ObservableObject{
    
    private var repository: Repository = Repository()
    
    @Published var viewSelector: ViewSelector = .start
    
    @StateObject private var userLocationManager = UserLocationManager()
    
    @Published var userIsLoggedIn: Bool = false
        

    @Published var showAlert: Bool = false
    @Published var messageTitle: String = ""
    @Published var messageText: String = ""
     
    @Published var updateButtonPressed: Bool = false
    // private var currentUserLocation: CLLocation
    
    
    //---------------------------------------------------------------------
    
    init(){
        print("DataController is initialised.")
        checkIfUserIsLogged()
    }
    
    //Used after getting Response from authentication server.
    private func deleteDCInstanceFromRepository(){
        repository.viewModel = nil
    }
    
    //---------------------------------------------
    
   private func showAllert(showAlert:Bool, errorTitle: String, errorText: String ){
        self.showAlert = showAlert
        self.messageTitle = errorTitle
        self.messageText = errorText
        
    }
    
    //=========================================================================
    //--------------------------------- LOGIN ---------------------------------
    //=========================================================================
    
    //-------------------- Login --------------------
    @Published var loginName: String = "" {
        didSet{
          showIfReadyToLogin()
        }
    }
    @Published var loginPassword: String = ""{
        didSet{
            showIfReadyToLogin()
        }
    }
    @Published var isReadyToLogin: Bool = false
    @Published var loginButtonPressed: Bool = false {
        didSet{
          loginButtonAction()
        }
    }
    
    //-------------------- Methods ---------------

    func showIfReadyToLogin(){
        if(!loginName.isEmpty && !loginPassword.isEmpty){

            print ("<<<<< DC Ready to LOGIN >>>>> login: \(loginName), password: \(loginPassword)")
            isReadyToLogin = true
        }else{
            isReadyToLogin = false
        }
    }
    
    func loginButtonAction(){
        if(isReadyToLogin){
            viewSelector = .wait
            tryLogin()
        }else{
            showAllert()
        }
    }
    
    func showAllert(){
        //TODO     !!!!!!!!!!!!!!
    }
    
    func tryLogin(){
        print ("<<<<< DC >>>>> tryLogin() -> --1-- login: \(loginName), password: \(loginPassword)")
        repository.login(dc: self, login: loginName, password: loginPassword)
    }
    
    //Respond by login:
    //state = another value is an Error
    //state = 0 - User not exist in DB
    //state = 1 - User exist in DB but registration not confirmed by email
    //state = 2 - User exist in DB but password is not correct
    //state = 3 - User is logged
    func isLoggedIn(data: LoginResponseData){
        print("<<<<< DC >>>>> isLoggedIn() -> data: \(data)")
        if(data.state == "3"){
            //Save user's Token in Preferences.
            
            repository.saveUserTokenInApp(userToken: data.uid)
            self.userIsLoggedIn = true
            self.viewSelector = .main
            
        }else if(data.state == "2"){
            print("Show ALLERT #2")
            
            showAllert(showAlert: true, errorTitle: "Error", errorText: "Password is not correct. Please check your password!")
            self.userIsLoggedIn = false
            self.viewSelector = .login
        }else if(data.state == "1"){
            print("Show ALLERT #1")
            showAllert(showAlert: true, errorTitle: "Info", errorText: "Please open your e-mail and confirm registration.")
            self.userIsLoggedIn = false
            self.viewSelector = .login
        }else if(data.state == "0"){
            print("Show ALLERT #0")
            showAllert(showAlert: true, errorTitle: "Error", errorText: "This User is not registered. Check your login.")
            self.userIsLoggedIn = false
            self.viewSelector = .login
        }else{
            print("Show ALLERT ERROR")
            showAllert(showAlert: true, errorTitle: "Error", errorText: "Something happend by login. Try to login again or use temporary gast login")
            self.userIsLoggedIn = false
            self.viewSelector = .login
        }
        // repository.dc = nil
        deleteDCInstanceFromRepository()
    }
    
    //=========================================================================
    //---------------------------- END of LOGIN -------------------------------
    //=========================================================================
    
    //Check on Server/FireBase if User logged
    func checkIfUserIsLogged() {
        // Check if user stay logged in App
      let uid = repository.checkUserTokenInApp()
        if(uid != ""){
            repository.checkOnServerIfCurrentUserIsLogged(dc:self, userToken: uid)
        }else{
            viewSelector = .login
        }
    }
       
    func logOut(){
        repository.logout()
        userIsLoggedIn = false
        viewSelector = .login
    }
}

