//
//  ApplicationSummaryView.swift
//  InsightUI
//
//  Created by Jaanus Siim on 29/09/2019.
//  Copyright © 2019 Coodly OU. All rights reserved.
//

import SwiftUI
import CloudInsight

struct ApplicationSummaryView: View {
    let app: CloudInsight.Application
    
    var body: some View {
        VStack {
            Text(app.identifier)
            Text("New users: \(app.newUsersToday)")
        }
    }
}
