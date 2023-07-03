//
//  ScrollViewModifiers.swift
//  hkstp oneapp testing
//
//  Created by van on 7/7/2022.
//

import Foundation
import SwiftUI
import Introspect




struct TopShadowBar<Content : View> : View {
    @ObservedObject var stObs : ScrollViewTopOffsetObserver
    var content : () -> Content

    var body : some View {
        content()
            .shadow(color: .black.opacity(stObs.isNotOnTop ? 0.1 : 0.0), radius: 10, x: 0, y: -4)
            .shadow(color: .black.opacity(stObs.isNotOnTop ? 0.6 : 0.0), radius: 10, x: 0, y: -4)
            .zIndex(50)
//                .animation(.default, value: stObs.isNotOnTop)

    }
}


class ScrollViewTopOffsetObserver: ObservableObject
{
    @Published var isNotOnTop : Bool = false
    var offsetY : CGFloat = 0
    @Published var topOffsetY : CGFloat = 0
    
    func feed(offsetY: CGFloat)
    {
        self.offsetY = offsetY
        if offsetY < topOffsetY
        {
            if self.isNotOnTop != true {
                self.isNotOnTop = true
            }
        }
        else
        {
            if self.isNotOnTop != false {
                self.isNotOnTop = false
            }
        }
    }
}



class ScrollViewTopOffsetPublishedObserver: ObservableObject
{
    @Published var isNotOnTop : Bool = false
    @Published var offsetY : CGFloat = 0
    
    func feed(offsetY: CGFloat)
    {
        self.offsetY = offsetY
        if offsetY < 0
        {
            if self.isNotOnTop != true {
                self.isNotOnTop = true
            }
        }
        else
        {
            if self.isNotOnTop != false {
                self.isNotOnTop = false
            }
        }
    }
}







struct ScrollViewTopOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: Value = 0

    static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value = nextValue()
        print(value)
    }
}





struct ScrollViewTopOffsetAnchor: ViewModifier {
    var name : String
    @ObservedObject var stObs : ScrollViewTopOffsetObserver
    func body(content: Content) -> some View {
        content
            .background(
                
                GeometryReader { proxy in
                    let v = proxy.frame(in: .named(name)).origin.y
                    Color.clear.preference(
                        key: ScrollViewTopOffsetPreferenceKey.self,
                        value: v
                    )
                }
                .onPreferenceChange(ScrollViewTopOffsetPreferenceKey.self) { value in
                    stObs.feed(offsetY: value)
                }
            )
    }
}

struct ScrollViewTopOffsetPublishedAnchor: ViewModifier {
    var name : String
    @ObservedObject var stObs : ScrollViewTopOffsetPublishedObserver
    func body(content: Content) -> some View {
        content
            .background(
                
                GeometryReader { proxy in
                    let v = proxy.frame(in: .named(name)).origin.y
                    Color.clear.preference(
                        key: ScrollViewTopOffsetPreferenceKey.self,
                        value: v
                    )
                }
                .onPreferenceChange(ScrollViewTopOffsetPreferenceKey.self) { value in
                    stObs.feed(offsetY: value)
                }
            )
    }
}

struct ScrollViewTopOffsetRoot: ViewModifier {
    var name : String
    func body(content: Content) -> some View {
        content
            .coordinateSpace(name: name)
    }
}

struct Demo_ScrollViewTopOffset: View {
    @StateObject var stObs = ScrollViewTopOffsetObserver()
    var body: some View {
        ZStack {
            VStack {
                Text("\(stObs.offsetY)")
                Text("\(stObs.isNotOnTop == true ? "True":"False" )")
            }
            ScrollView {
                ZStack {
                    LazyVStack {
                        ForEach(0 ..< 100, id: \.self) {_ in
                            Text("A")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .modifier(ScrollViewTopOffsetAnchor(name: "scroll", stObs: stObs))
            }
            .modifier(ScrollViewTopOffsetRoot(name: "scroll"))
            
            ZStack {
                VStack(spacing: 0) {
                    TopShadowBar(stObs: stObs) {
                        
                        Spacer()
                        .frame(height: 1)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(
                            Rectangle()
                                .fill(Color(hex: 0xEFEFEF))
                        )
                    
                    }
                    Spacer()
                        .layoutPriority(100)
                }
            }
        }
    }
}

struct ScrollViewTopOffsetDetector_Previews: PreviewProvider {
    static var previews: some View {
        Demo_ScrollViewTopOffset()
    }
}
