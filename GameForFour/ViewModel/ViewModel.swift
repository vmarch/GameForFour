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
    @Published var userAppName: String = ""
    @Published var viewSelector: ViewSelector = .login
    
    @Published var userIsLoggedIn: Bool = false

    @Published var showAlert: Bool = false
    @Published var messageTitle: String = ""
    @Published var messageText: String = ""
     
    @Published var updateButtonPressed: Bool = false {
        didSet{
            secretButton += 1
            if(secretButton == 6){
                                clearRoom()
                secretButton = 0
            }
        
        }
    }
     private var secretButton:Int = 0
       
    
    //---------------------------------------------------------------------
    
    init(){
        print("DataController is initialised.")
    }
    
    //Used after getting Response from authentication server.
    private func deleteVMInstanceFromRepository(){
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
       // if(!loginName.isEmpty && !loginPassword.isEmpty){
       // print ("<<<<< VM Ready to LOGIN >>>>> login: \(loginName), password: \(loginPassword)")
        
        if(!loginName.isEmpty){
            print ("<<<<< VM Ready to LOGIN >>>>> login: \(loginName), password: \(loginPassword)")
            isReadyToLogin = true
        }else{
            isReadyToLogin = false
        }
    }
    
    func loginButtonAction(){
        if(isReadyToLogin){
            tryLogin()
        }else{
            showAllert(showAlert: true, errorTitle: "Login Error:", errorText: "Login field can not be empty!")
        }
    }

    func tryLogin(){
        print ("<<<<< VM >>>>> tryLogin() -> --1-- login: \(loginName), password: \(loginPassword)")
        repository.login(vm: self, login: loginName, password: loginPassword)
    }
    
    //Respond by login:
    //state = another value is an Error
    //state = 0 - User not exist in DB???????
    //state = 1 - User exist in DB but registration not confirmed by email
    //state = 2 - User exist in DB but password is not correct
    //state = 3 - User is logged
    func isLoggedIn(data: LoginResponseData){
        print("<<<<< VM >>>>> isLoggedIn() -> data: \(data)")
        if(data.state == "3"){
            //Set User Name in app. Clear Login Name.
            userAppName = loginName
            loginName = ""
            
            self.userIsLoggedIn = true
            self.viewSelector = .main
        }else if(data.state == "2"){
            print("Show ALLERT #2")
            showAllert(showAlert: true, errorTitle: "Error", errorText: "\(data.txt)")
            self.userIsLoggedIn = false
            self.viewSelector = .login
        }else if(data.state == "1"){
            print("Show ALLERT #1")
            showAllert(showAlert: true, errorTitle: "Info", errorText: "\(data.txt).")
            self.loginName = ""
            self.userIsLoggedIn = false
            self.viewSelector = .login
        }else if(data.state == "0"){
            print("Show ALLERT #0")
            showAllert(showAlert: true, errorTitle: "Info", errorText: "\(data.txt).")
            self.userIsLoggedIn = false
            self.viewSelector = .login
        }else{
            print("Show ALLERT ERROR")
            showAllert(showAlert: true, errorTitle: "Error", errorText: "Something happend by login. Try to login again or use temporary gast login")
            self.userIsLoggedIn = false
            self.viewSelector = .login
        }
        // repository.dc = nil
        deleteVMInstanceFromRepository()
    }
    
    //=========================================================================
    //---------------------------- END of LOGIN -------------------------------
    //=========================================================================
    
    
    func clearRoom(){
        repository.clearRoom()
    }
    
//    func logOut(){
//        repository.logout()
//        userIsLoggedIn = false
//        viewSelector = .login
//    }
}

