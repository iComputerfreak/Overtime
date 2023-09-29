//
//  DurationPicker.swift
//  Overtime
//
//  Created by Jonas Frey on 31.08.20.
//  Copyright © 2020 Jonas Frey. All rights reserved.
//

import SwiftUI

struct DurationPicker: View {
        
    @Binding var hours: Int
    @Binding var minutes: Int
    
    let labelSize: CGFloat = 30
    let padding: CGFloat = 5
    
    func pickerWidth(_ proxyWidth: CGFloat) -> CGFloat {
        // We have two labels, 3 paddings and two pickers
        return (proxyWidth - self.labelSize * 2 - self.padding * 3) / 2.0
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                Picker(selection: self.$hours, label: Text(verbatim: "")) {
                    ForEach(0..<24) { i in
                        Text(verbatim: "\(i)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: pickerWidth(proxy.size.width))
                .clipped()
                .padding(.leading, self.padding)
                
                Text("h")
                    .bold()
                    .frame(width: self.labelSize)
                    .padding(0)
                
                Picker(selection: self.$minutes, label: Text("min")) {
                    ForEach(0..<60) { i in
                        Text(verbatim: "\(i)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: pickerWidth(proxy.size.width))
                .clipped()
                .padding(.leading, self.padding)
                
                Text("m")
                    .bold()
                    .frame(width: self.labelSize)
                    .padding(.trailing, self.padding)
            }
            .padding(0)
        }
        .frame(height: 200)
        .padding(0)
    }
    
}

struct DurationPicker_Previews: PreviewProvider {
    static var previews: some View {
        DurationPicker(hours: .constant(5), minutes: .constant(20))
    }
}
