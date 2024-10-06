# Leaf (Learning English and FlashCard)

An English learning App written in Flutter

## Getting Started

1. [Feature List](#1-features-list)
2. [Tech Stack](#2-tech-stack)
3. [Demo Video](#3-demo-video)
4. [Appendix](#4-appendix)

### 1. Features List
- Authentication
    - Email/Password Authorization
    - Google Login
    - Forgot Password, Mail OTP system
- Topic Management
A topic is a **group of vocabularies** displayed in 2 languages, it can be pulic or private based on the User option.A User can access the public Topics created by different User to learn
    - Create New Topic
    - Update Existing Topic
    - Delete Topic
    - Favorite a Vocabulary
    - Save Topic to Local Database (Using Hive Storage)
    - Get Recently Learned Topic
    - Search by Topic Name
- Folder Management
A Folder is a **group of Topics**, it is only visible to the User created it.
    - Create New Folder
    - Update (Add/Remove Topics) of a Folder
    - Delete Folder
- Learning Mode
The mobile app offer User multiple options to study a Topic, including:
    - Flashcard Learning: User can manually horizontally scroll through flashcards, tap on to flip the card or select automatic option for the app to auto-scroll and flip and pronounce the card at the same time.
    - Matching Learning: User has to select 2 card that have the same meaning, layout in a grid for selection.
    - Quiz Learning: User has to select 1 of the at least 4 options to determine the correct answer to the displayed vocabulary, User can have the option to listen to question vocabulary.
    - Typing Learning: User is displayed with a question and has to type out the answer/vocabulary of the question.
- Profile Management:
    - Change Profile Image
    - Update Personal Information
    - Change Password
    - Change Gmail through Mail OTP
    - Change App Language (English/Vietnamese)
    - Change Dark Mode
    - Change Option to Receive Notifications (Through FCM)
- Rankings:
During the learning process, all of the progression of selecting correct/wrong answers are stored and can be view on the Ranking page of the Topic
    - View personal Ranking compared to different Learners

### 2. Tech Stack
- Architecture: Clean Architecture
- API Services: Dio & Retrofit, API Caching with Dio Cache Interceptor
- Service Locator: GetIt, Injectable
- State Management: Bloc & Freezed
- Local Storage: Shared Preferences for Key-Value pair, Hive for Object storage

### 3. Demo Video
- [Demo Video](https://www.youtube.com/watch?v=hUkZmgYNcwo&t=2s)

## 4. Appendix
- [Report File](./report.pdf): File for further details on the database schema