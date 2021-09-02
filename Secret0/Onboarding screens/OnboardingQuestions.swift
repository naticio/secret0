//
//  Q1Day2LiveView.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/31/21.
//

import SwiftUI

struct OnboardingQuestions: View {
    
    @EnvironmentObject var model: ContentModel
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State var goWhenTrue : Bool = false
    @State private var response : String = ""
    
    var body: some View {
        ZStack {
            VStack {
                
                let index = model.onboardingIndex
                
                Image(systemName: Constants.screens[index].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)
                Spacer()
                
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Text(Constants.screens[index].title)
                        .font(.title)
                        .bold()
                    
                    
                    Text(Constants.screens[index].disclaimer)
                        .font(.caption)
                }
                .padding()
                
                TextEditor(text: $response).font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                
                
                NavigationLink(destination: OnboardingQuestions(), isActive: $goWhenTrue) {
                    EmptyView()
                }
                
                //BUTTON NEXT
                Button {
                   
                    if model.onboardingIndex < Constants.screens.count-1 {
                        model.onboardingIndex += 1
                        //isOnboarding = true
                        response = ""
                        
                        if Constants.screens[index].title.contains("one day left") {
                            model.Q1day2liveModel = response
                        }
                        if Constants.screens[index].title.contains("100,000,000") {
                            model.QlotteryWinModel = response
                        }
                        if Constants.screens[index].title.contains("money didn't matter") {
                            model.QmoneynotanIssueModel = response
                        }
                        if Constants.screens[index].title.contains("bucket list") {
                            model.bucketListModel = response
                        }
                        if Constants.screens[index].title.contains("Jokes") {
                            model.jokesModel = response
                        }
                        
                        goWhenTrue = true
                        
                    } else if model.onboardingIndex == Constants.screens.count-1 {
                        isOnboarding = false
                        //model.onboardingIndex = 0
                        model.checkLogin()
                        
                    }
                    
                    
                } label: {
                    if model.onboardingIndex == Constants.screens.count {
                        Text("Done")
                    } else {
                        Text("Next")
                    }
                }
                .padding()
                .background(Capsule().strokeBorder(Color.white, lineWidth: 1.5))
                .frame(width: 100)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

struct Q1Day2LiveView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingQuestions()
    }
}
