//
//  ContentView.swift
//  CatFact
//
//  Created by Chanti Palavalasa on 14/04/25.
//

import SwiftUI
import SwiftData
import CachedAsyncImage

struct CatFactView: View {
    @StateObject var presenter: CatPresenter
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack {
                    Spacer()
                    CachedAsyncImage(
                        url:URL(string: presenter.caturl),
                        scale: 9.0,
                        transaction: Transaction(
                            animation: .spring(
                                response: 0.5,
                                dampingFraction: 0.65,
                                blendDuration: 0.025))) { phase in
                                    switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .failure:
                                            Image(systemName: "photo.badge.exclamationmark")
                                                .resizable()
                                                .scaledToFit()
                                                .opacity(0.5)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        default:
                                            EmptyView()
                                    }
                                }
                                .clipShape(.rect(cornerRadius: 25))
                                .edgesIgnoringSafeArea(.all)
                    Spacer()
                    MessageView(
                        heading: "A Cat Fact",
                        message: presenter.fact.data.first ?? "")
                    
                    
                }
                .onAppear(perform: {
                    presenter.refresh()
                })
                .navigationTitle("The Cat Story")
                .padding()
                
                Color.clear
                    .contentShape(Rectangle()) // Makes the entire area tappable
                    .onTapGesture {
                        presenter.refresh()
                    }
            }
        }
        .alert(presenter.errorMessage ?? "Error Occured", isPresented: $presenter.showingAlert) {
            Button("OK", role: .cancel) {
                presenter.showingAlert = false
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CatRouter.createView()
}


struct MessageView: View {
    var heading: String
    var message: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("A Cat Fact:")
                .fontWeight(.bold)
                .fontDesign(.serif)
                .padding()
                .background(Color.black)
            Text(message)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
        }
        .foregroundStyle(Color.white)
        .clipShape(.rect(cornerRadius: 10))
    }
}
