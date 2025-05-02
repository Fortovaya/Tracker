//
//  Resources.swift
//  Tracker
//
//  Created by Алина on 02.05.2025.
//
import Foundation

enum Resources {
    enum ScreenTitles: String {
        case createTracker = "Создание трекера"
        case newHabit = "Новая привычка"
        case createHabit = "Создание привычки"
        case editHabit = "Редактирование привычки"
        case category = "Категория"
        case newCategory = "Новая категория"
        case editCategory = "Редактирование категории"
        case schedule = "Расписание"
        case filters = "Фильтры"
    }
    
    enum TitleButtons: String {
        case addCategory = "Добавить категорию"
        case create = "Создать"
        case done = "Готово"
        case cancel = "Отменить"
        case filters = "Фильтры"
        case irregularEvent = "Нерегулярное событие"
        case habit = "Привычка"
        case category = "Категория"
        case schedule = "Расписание"
    }
}
