//
//  Dynamic.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T?) -> ()

    var listener: Listener?

    var value: T? {
        didSet {
            listener?(value)
        }
    }

    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }

    init(_ value: T) {
        self.value = value
    }
}
