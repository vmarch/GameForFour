//
//  ContentView.swift
//  GameForFour
//
//  Created by devtolife on 23.09.21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm:ViewModel
    
    var body: some View {
        
        ZStack(){
           LinearGradient(gradient: Gradient(colors: [.blue,.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)

            if(self.vm.viewSelector == .main){
                VStack{
                    
                    // -------------- MainView ---------------
                     MainGameView()
                }
                .navigationBarTitle("Trip & Jorney", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                                        HStack{
                    
                    Button(action: {
                       // self.vm.logout()
                    }, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(height: 20)
                    }
                    )
                }
                )
            }
            
            VStack{
                if(self.vm.viewSelector == .login){
                    // ----------- SignInView --------------
                    LoginView()
                }
            }
            
        }.alert(isPresented: $vm.showAlert) {
            Alert(title: Text("\(vm.messageTitle)"), message: Text(vm.messageText), dismissButton: .cancel())
            /*Alert(
             title: Text("Are you sure you want to delete this?"),
             message: Text("There is no undo"),
             primaryButton: .destructive(Text("Delete")) {
             self.dc.showAlert = false
             },
             secondaryButton: .cancel()
             )*/
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
