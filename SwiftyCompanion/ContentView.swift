//
//  ContentView.swift
//  SwiftyCompanion
//
//  Created by Louise on 13/03/2020.
//  Copyright © 2020 Louise Pieri. All rights reserved.
//

import SwiftUI
import OAuth2

struct ContentView: View {
    
    @State private var login: String = ""
    @State private var showAlert = false
    @State private var navigationActive = false
    @State private var researchUser: User?
    let intra: IntraApi
    
    /* New Version */
//    func callbackMe(dict: OAuth2JSON?, error: Error?) -> Void {
//        if let json = dict {
//            if json.isEmpty {
//                self.showAlert = true
//            } else {
//                self.researchUser = intra.createUser(json)
//                self.navigationActive = true
//
//            }
//        } else {
//            self.showAlert = true
//        }
//    }

    /* Old Version */
    func callbackMe(dict: OAuth2JSON?, error: Error?) -> Void {
        if let json = dict {
            if json.isEmpty {
                self.showAlert = true
            } else {
                self.researchUser = intra.createUser(json)
                self.navigationActive = true

            }
        } else {
            self.showAlert = true
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack (alignment: .leading) {
                
                TextField("Enter 42 login", text: $login)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.title)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.gray))
                    .padding(.horizontal, 20)

                Button(action: {
                    self.intra.request(self.login.lowercased(), callback: self.callbackMe(dict:error:))
                    print(self.researchUser?.login)
                }) {
                    Text("Enter")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(.systemGreen), Color(.green)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40, antialiased: true)
                .padding(.horizontal, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Error to get user !"), dismissButton: .cancel())
                }
                
                NavigationLink(destination: TemplateTableView(), isActive: $navigationActive) {
                    
                    EmptyView()

                }.navigationBarTitle(Text("Swifty-Companion"), displayMode: .large)
                
            }.padding()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(intra: IntraApi())
    }
}
