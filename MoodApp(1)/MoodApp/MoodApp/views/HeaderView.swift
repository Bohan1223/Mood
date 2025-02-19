

import Foundation

import SwiftUI

struct HeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
    }
}
