//
//  DaysValueTransformer.swift
//  Tracker
//
//  Created by Алина on 25.05.2025.
//

import Foundation

@objc(DaysValueTransformer)
final class DaysValueTransformer: ValueTransformer, NSSecureCoding {
    // MARK: NSSecureCoding
    static var supportsSecureCoding: Bool { true }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        
    }

    override init() {
        super.init()
    }
    
    /// Говорим, что трансформируем в Data
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    /// Разрешаем обратное преобразование
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    /// Вызываем при сохранении объекта в CORE DATA
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? Set<WeekDay> else { return nil }
        return try? JSONEncoder().encode(days)
    }
    /// Декодирование данных из DATA обратно в необходимый тип (WeekDay)
    /// Вызываем при чтении данных из Core Data
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode(Set<WeekDay>.self, from: data as Data)
    }
    
    /// Регистрируем кастомный трансформер и сообщаем о нем системе
    static func register() {
        
        _ = NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        )
    }
}
