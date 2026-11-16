//
//  Priority.swift
//  Todo
//
//  Created by Leonardo Takuno on 09/11/26.
//

public enum Priority: Int, Comparable, Codable, CaseIterable, Identifiable {
    case high = 0
    case medium = 1
    case low = 2

    public var id: Self { self } // ou: public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .high: return "Alta"
        case .medium: return "Média"
        case .low: return "Baixa"
        }
    }

    public static func < (lhs: Priority, rhs: Priority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
