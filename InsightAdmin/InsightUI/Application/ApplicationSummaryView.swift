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
    @ObservedObject var viewModel: ApplicationSummaryViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.identifier)
            Text("New users: \(viewModel.formattedUsersToday)")
            Text("Sessions: \(viewModel.formattedSessionsToday)")
        }
    }
}
