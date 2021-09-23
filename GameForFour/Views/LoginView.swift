//
//  LoginView.swift
//  GameForFour
//
//  Created by devtolife on 23.09.21.
//


import SwiftUI

struct LoginView: View{
    @EnvironmentObject var vm:ViewModel
    @Binding var output:Int
     
    var body: some View{
        VStack{
            
            TitleNameView()
            
            LoginField()
           // PasswordField()
            
            Button(action:{
                vm.loginButtonPressed = true
         
            }){
                //TODO change login BAckground
                //
                if(vm.isReadyToLogin){
                    
                    Text("Login")
                                       .frame(width: 200, height: 50, alignment: .center)
                                       .background(Color.blue)
                                       .foregroundColor(.black)
                                       .font(.system(size: 32, weight: .medium))
                                       .cornerRadius(15)
                                       .padding()
                }else{
                    Text("Login")
                                       .frame(width: 200, height: 50, alignment: .center)
                                       .background(Color.secondary)
                                       .foregroundColor(.black)
                                       .font(.system(size: 32, weight: .medium))
                                       .cornerRadius(15)
                                       .padding()

                }
            }
            
            Button(action:{
                vm.updateButtonPressed = true
            }){
                Text("Update").font(.system(size: 24, weight: .medium))
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}

struct TitleNameView: View {
    var body: some View {
        Text("Login")
            .font(.system(size: 40, weight: .medium))
            .foregroundColor(.white)
            .padding()
    }
}

struct LoginField: View {
    @EnvironmentObject var vm:ViewModel
   // @Binding var loginName:String
    var body: some View {
        TextField("Login:", text: $dc.loginName).autocapitalization(UITextAutocapitalizationType.none).disableAutocorrection(true).padding().frame(width: 300, height: 40).background(Color.white).cornerRadius(6).padding(2)
    }
}

//struct PasswordField: View {
//   // @Binding var password:String
//    @EnvironmentObject var vm:ViewModel
//    var body: some View {
//        SecureField("Password:", text: $dc.loginPassword).autocapitalization(UITextAutocapitalizationType.none).disableAutocorrection(true).padding().frame(width: 300, height: 40).background(Color.white).cornerRadius(6).padding(2).autocapitalization(.none)
//    }
//}

struct LoginView_Previews: PreviewProvider {
    @State static var output:Int = 0
    static var previews: some View {
        LoginView(output: $output)
    }
}
