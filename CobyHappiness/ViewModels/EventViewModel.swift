//
//  EventViewModel.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

import Foundation

class EventFormViewModel: ObservableObject {
    var event: Event?
    var updating: Bool { event != nil }

    init() {}

    init(_ event: Event) {
        self.event = event
    }
}
