//
//  MainTabView.swift
//  FinalProject342
//
//  Created by Alex Rowshan on 4/29/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
                    CourseMap()
                        .tabItem {
                            Image(systemName: "map")
                            Text("Course Map")
                        }
                    
                    Stats()
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Stats")
                        }
                RoundHistoryView()
                    .tabItem {
                        Image(systemName: "clock.fill")
                        Text("Round History")
                    }
                
                }
            }
    }


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
