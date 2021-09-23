//
//  Repository.swift
//  GameForFour
//
//  Created by devtolife on 23.09.21.
//

/*
For testing user's "token" == "id" in Server DB Table
*/

import Foundation
class Repository{
    
    var viewModel:ViewModel? = nil
    
    private var isInternet: Bool = true
    
    var userLoggedIn: Bool = false
       
    init(){}
    
    //====================================================================
    //---------------------- GET USER COUNT--------------------------
    //--------------------------------------------------------------------
    
    func checkOnServerIfCurrentUserIsLogged(vm:ViewModel, userToken: String){
        viewModel = vm

        if(!isInternet){
            print("Show allert = No Internet")
        }else{
            let url = URL(string: (ConectData().testIsLoggedEndpoint))!
            let bodyData: String = "uid=\(userToken)"
            NetworkService.connectToServer(url: url, bodyDataText: bodyData) {  [weak self] resultData, resultError in
                guard let self = self else{return}
                if(resultData != nil){
                   
                    do {
                        guard let d = resultData else {return}
                            let decodedJson = try JSONDecoder().decode([IsLoggedResponseData].self, from: d)
                    
                            DispatchQueue.main.async {
                                guard let dataController = self.dataController else { return }
                                dataController.isStayLoggedInApp(data: decodedJson[0])
                            }
                            //If on server User status is not logged -> delete current user token in app.
                            if(decodedJson[0].state == "2"||decodedJson[0].state == "0"){
                                self.deleteUserTokenInApp()
                            }
                            
                    }catch{
                        print("ERROR")
                        self.dataController = nil
                    }
                }else{
                    print("ERROR: \(String(describing: resultError))")
                    self.dataController = nil
                }
            }
        }
    }

    //====================================================================
    //---------------------------- LOGIN --------------------------------
    //--------------------------------------------------------------------
    
    //Authenticate with LoginName and Password
    func login(dc: DataController,login: String, password: String){
     dataController = dc
        
        if(!isInternet){
            userLoggedIn = server.login(login: login, password: password)
        }else{
            let url = URL(string: (ConectData().testLogintEndpoint))!
            let bodyData: String = "username=\(login)&password=\(password)"
            NetworkService.connectToServer(url: url, bodyDataText: bodyData) {  [weak self] resultData, resultError in
                guard let self = self else{return}
                if(resultData != nil){
                   
                    do {
                        guard let d = resultData else {return}
                            let decodedJson = try JSONDecoder().decode([LoginResponseData].self, from: d)
                    
                            DispatchQueue.main.async {
                                guard let dataController = self.dataController else { return }
                                dataController.isLoggedIn(data: decodedJson[0])
                            }
                    }catch{
                        print("ERROR")
                        self.dataController = nil
                    }
                }else{
                    print("ERROR: \(String(describing: resultError))")
                    self.dataController = nil
                }
            }
        }
    }
    
    //====================================================================
    //---------------------------- LOGOUT --------------------------------
    //--------------------------------------------------------------------
    
    //Logout from Server and App.
    func logout(){
        changeUserLoginStatusOnServer(userToken:checkUserTokenInApp(),changeStatusTo: false)
    }
    
    //Change User's login status on server.
    private func changeUserLoginStatusOnServer(userToken: String, changeStatusTo:Bool){
        
        if(!isInternet){
            print("Show allert = NO INTERNET")
        }else{
            let url = URL(string: (ConectData().testChangeUserLoginStatusEndpoint))!
            var status: String
            if(changeStatusTo){
                status = "1"
            }else{
                status = "0"
            }
            let bodyData: String = "uid=\(userToken)&status=\(status)"
            NetworkService.connectToServer(url: url, bodyDataText: bodyData) {  [weak self] resultData, resultError in
                guard let self = self else{return}
                if(resultData != nil){
                   
                    do {
                        guard let d = resultData else {return}
                            let decodedJson = try JSONDecoder().decode([LoginStatusResponseData].self, from: d)
                        
//                            DispatchQueue.main.async {
//                                guard let dataController = self.dataController else { return }
//                                dataController.isPreRegistered(data: decodedJson[0])
//                            }
                      
                            
                    }catch{
                        print("ERROR")
                        self.dataController = nil
                    }
                }else{
                    print("ERROR: \(String(describing: resultError))")
                    self.dataController = nil
                }
            }
        }
    }
}
