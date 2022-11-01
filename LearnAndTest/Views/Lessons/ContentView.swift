//
//  ContentView.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 20.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
        ScrollView {
            
            LazyVStack {
                //Confirm that currentModule is set
                if model.currentModule != nil {
                    ForEach(0..<model.currentModule!.content.lessons.count, id: \.self) { index in
                        NavigationLink {
                            ContentDetailView().onAppear {
                                model.beginLesson(index)
                            }
                        } label: {
                            ContentViewRow(index: index)
                        }

                        
                    }
                }
            }
            .accentColor(.black)
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
