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
        case tracker = "Трекеры"
        case newEvents = "Новое нерегулярное событие"
        
        var text: String { rawValue }
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
        case onBoarding = "Вот это технологии"
        
        var text: String { rawValue }
    }
    
    enum TitleTabBarItem: String {
        case trackers = "Трекеры"
        case statistics = "Статистика"
        
        var text: String { rawValue }
    }
    
    enum ImageNames: String {
        case dizzy = "dizzy"
        
        var imageName: String { rawValue }
    }
    
    enum ButtonIcons: String {
        case plus = "plus"
        case trackersTabBar = "trackers"
        case statisticsTabBar = "hare"
        case clearButton = "xmark.circle"
        case checkmark = "checkmark"
        
        var imageName: String { rawValue }
    }
    
    enum Labels: String {
        case dizzyLabel = "Что будем отслеживать?"
        case searchPlaceholder = "Поиск"
        
        var text: String { rawValue }
    }
    
    enum EmojiImage: String, CaseIterable {
        case emojiSmile = "emojiSmile"
        case emojiCatHeartEyes = "emojiCatHeartEyes"
        case emojiHibiscus = "emojiHibiscus"
        case emojiDog = "emojiDog"
        case emojiHeart = "emojiHeart"
        case emojiScream = "emojiScream"
        case emojiAngel = "emojiAngel"
        case emojiAngry = "emojiAngry"
        case emojiColdFace = "emojiColdFace"
        case emojiThinking = "emojiThinking"
        case emojiRaisedHands = "emojiRaisedHands"
        case emojiBurger = "emojiBurger"
        case emojiBroccoli = "emojiBroccoli"
        case emojiTableTennis = "emojiTableTennis"
        case emojiGoldMedal = "emojiGoldMedal"
        case emojiGuitar = "emojiGuitar"
        case emojiIsland = "emojiIsland"
        case emojiSleepy = "emojiSleepy"
        
        static var allCasesList: [EmojiImage] { allCases }
        static var allImageNames: [String] { allCases.map { $0.imageName } }
        
        var imageName: String { rawValue }
    }
    
    enum OnboardingImage: String, CaseIterable{
        case onBoardingBlue = "onBoardingBlue"
        case onBoardingRed = "onBoardingRed"
        
        static var allCasesImage: [OnboardingImage] { allCases }
        static var allImageNames: [String] { allCases.map { $0.imageName } }
        
        var imageName: String { rawValue }
    }
    
    enum OnBoardingLabel: String {
        case onBoardingBlue = "Отслеживайте только то, что хотите"
        case onBoardingRed = "Даже если это не литры воды и йога"
        
//        stati
        
        var text: String { rawValue }
    }
}
