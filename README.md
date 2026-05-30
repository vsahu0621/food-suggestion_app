# Smart Recipe App

## Overview

Smart Recipe App is a Flutter application that helps users discover recipes based on search, current time, and location. The application follows an offline-first approach using local caching and favorites persistence.

## Features

### Smart Discovery & Search

* Recipe search using TheMealDB API
* Debounced search to reduce unnecessary API calls
* Time-based meal recommendations

  * Breakfast (Morning)
  * Lunch (Afternoon)
  * Dinner (Evening)
* Location-based recipe suggestions

### Offline First Experience

* Save favorite recipes using Hive
* Offline access to favorites
* Cached recipe data for network resilience
* Graceful fallback when internet is unavailable

### Notifications

* Daily breakfast reminder (8:00 AM)
* Daily lunch reminder (2:00 PM)
* Daily dinner reminder (8:00 PM)

### UI & UX

* Shimmer loading effects
* Hero animations between list and detail screens
* Responsive Material 3 UI
* Error handling and fallback states

## Tech Stack

### State Management

* Riverpod

### Local Storage

* Hive

### API

* TheMealDB API

### Notifications

* flutter_local_notifications

### Location

* geolocator
* geocoding

## Project Structure

lib/
├── data/
│ ├── api/
│ ├── model/
├── provider/
├── screen/
│ ├── home/
│ ├── splash/
├── widgets/
└── main.dart

## CI/CD

GitHub Actions workflow automatically:

1. Runs flutter analyze
2. Runs flutter test
3. Builds Release APK

Workflow file:

.github/workflows/main.yml

## Build APK

flutter build apk --release

Generated APK:

build/app/outputs/flutter-apk/app-release.apk

## Run Project

flutter pub get

flutter run

## GitHub Release

The Release section contains the generated APK for download and testing.

## Assignment Requirements Covered

* Recipe API Integration
* Search with Optimization
* Time-Based Suggestions
* Location-Based Suggestions
* Offline Favorites
* Cached Data
* Push Notifications
* Permission Handling
* Riverpod State Management
* Shimmer Loading
* Hero Animations
* Error Handling
* GitHub Actions CI/CD
* Release APK Generation

## Author

Vandana Sahu
Flutter Developer
