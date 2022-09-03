//
//  ContentViewRow.swift
//  LearnAndTest
//
//  Created by Alex Ivanescu on 20.08.2022.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index:Int
    
    var body: some View {
        
        let lessonC = model.currentModule!.content.lessons[index]
        ZStack (alignment: .leading) {
            Rectangle().foregroundColor(.white).cornerRadius(10).shadow(radius: 5).frame(height: 66)
            HStack (spacing: 30) {
                Text(String(index+1)).bold()
                
                VStack (alignment: .leading){
                    Text(lessonC.title).bold()
                    Text(lessonC.duration)
                }
            }
            .padding()
        }
        .padding(.bottom, 7)
    }
}

