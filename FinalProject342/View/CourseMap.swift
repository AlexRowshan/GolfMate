
//  CourseMap.swift
//  FinalProject342
//
//  Created by Alex Rowshan on 4/29/24.
//
//  CourseMap.swift
//  FinalProject342
//
//  Created by Alex Rowshan on 4/29/24.
//
import Foundation
import SwiftUI
import Firebase
import MapKit

struct IdentifiableMapItem: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

struct CourseMap: View {
    @State private var err: String = ""
    @StateObject var manager = CourseMapViewModel()
    @State private var selectedCourse: IdentifiableMapItem?
    @State private var showScorecardView = false
    
    var body: some View {
        TabView {
            NavigationStack {
                VStack {
                    // Top section
                    HStack {
                        Text("GolfMate")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.top)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Hello " + (Auth.auth().currentUser!.displayName ?? "Username not found"))
                                .font(.headline)
                            
                            Button {
                                Task {
                                    do {
                                        try await Authentication().logout()
                                    } catch let e {
                                        err = e.localizedDescription
                                    }
                                }
                            } label: {
                                Text("Log Out")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                    
                    if !err.isEmpty {
                        Text(err)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                    //Map to show all courses
                    Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: manager.golfCourses.map(IdentifiableMapItem.init)) { identifiableMapItem in
                        MapAnnotation(coordinate: identifiableMapItem.mapItem.placemark.coordinate) {
                            Button(action: {
                                selectedCourse = identifiableMapItem
                            }) {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(.green)
                                    .font(.title)
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    //Select course to start round
                    if let course = selectedCourse {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(course.mapItem.name ?? "")
                                .font(.headline)
                            
                            Button(action: {
                                showScorecardView = true
                            }) {
                                Text("Start Round")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .padding()
                    }
                    
                    Button(action: { //Center User on map button
                        manager.centerUserLocation()
                    }) {
                        Image(systemName: "location.circle.fill")
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.bottom, 30)
                }
                .sheet(isPresented: $showScorecardView) {
                    if let course = selectedCourse {
                        ScorecardView(courseName: course.mapItem.name ?? "")
                    }
                }
            }
            .tabItem { //Tab Bar
                Label("Map", systemImage: "map")
            }
            Stats()
                .tabItem {
                    Label("Stats", systemImage: "plus.forwardslash.minus")
                }
            RoundHistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Round History")
                }
        }
    }
}
