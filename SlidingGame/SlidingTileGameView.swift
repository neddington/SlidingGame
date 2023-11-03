//
//  ContentView.swift
//  SlidingGame
//
//  Created by Eddington, Nick on 11/1/23.
//

import SwiftUI

struct SlidingTileGameView: View {
    @State private var points: [Point] = []
    
    init() {
        // Initialize points with random positions
        for i in 0..<9 {
            let x = i % 3
            let y = i / 3
            points.append(Point(id: i, x: x, y: y))
        }
        points.shuffle()
    }
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(points) { point in
                Button(action: {
                    // Implement the logic to move the button when clicked
                }) {
                    Text("\(point.id + 1)")
                        .font(.largeTitle)
                        .frame(width: 80, height: 80)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .position(x: CGFloat(point.x * 100 + 50), y: CGFloat(point.y * 100 + 50))
            }
        }
    }
}

struct SlidingTileGameView_Previews: PreviewProvider {
    static var previews: some View {
        SlidingTileGameView()
    }
}


