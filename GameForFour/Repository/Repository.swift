//
//  Repository.swift
//  GameForFour
//
//  Created by devtolife on 23.09.21.
//

import Foundation
class Repository{
    
    var viewModel:ViewModel? = nil
    
    private var isInternet: Bool = true
    
    var userLoggedIn: Bool = false
       
    init(){}
    
    //====================================================================
    //---------------------------- LOGIN TO GAME--------------------------------
    //--------------------------------------------------------------------
    
    //Authenticate with LoginName and Password
    func login(vm: ViewModel,login: String, password: String){
     viewModel = vm
        
        if(!isInternet){
            print("Show allert = No Internet")
        }else{
            let url = URL(string: (ConectData().testLoginEndpoint))!
            /*
            //Connect to Vladi
            let bodyData: String = "\(ConectData().keyWordUser)=\(login)&\(ConectData().keyWordPass)=\(password)"
            */
            
            //Connect to Alex
            let bodyData: String = "\(ConectData().keyWordUser)=\(login)"
          
            NetworkService.connectToServer(url: url, bodyDataText: bodyData) {  [weak self] resultData, resultError in
                guard let self = self else{return}
                if(resultData != nil){
                   
                    do {
                        guard let d = resultData else {return}

                        print(     String(data: resultData!, encoding: .utf8))
                           let decodedJson = try JSONDecoder().decode([LoginResponseData].self, from: d)
                    
                            DispatchQueue.main.async {
                                guard let viewModel = self.viewModel else { return }
                                viewModel.isLoggedIn(data: decodedJson[0])
                            }
                    }catch{
                        print("ERROR")
                        self.viewModel = nil
                    }
                }else{
                    print("ERROR: \(String(describing: resultError))")
                    self.viewModel = nil
                }
            }
        }
    }
    
    //====================================================================
    //---------------------------- LOGOUT --------------------------------
    //--------------------------------------------------------------------
    
    /*
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
     */
}
