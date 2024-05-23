//
//  FlagView.swift
//  GuessTheFlag
//
//  Created by Denis Evdokimov on 5/23/24.
//

import SwiftUI

struct FlagView: View {
    let flagName: String
    var body: some View {
        Image(flagName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

