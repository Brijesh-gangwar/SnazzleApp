# Delivery App - Lib Folder Structure

This document provides a detailed overview of the `lib` folder structure for the Delivery Agent Application.

## 📁 Complete Folder Structure

```
lib/
├── main.dart                          # Application entry point
├── secrets.dart                       # API keys and sensitive configuration
│
├── models/                            # Data models and entities
│   ├── agent_details_model.dart      # Agent profile and details data model
│   └── order_model.dart              # Order data model and structure
│
├── providers/                         # State management (Provider pattern)
│   ├── agent_details_provider.dart   # Agent details state management
│   └── order_provider.dart           # Orders state management
│
├── screens/                           # Application screens/pages
│   ├── dashboard_screen.dart         # Main dashboard view
│   ├── home_screen.dart              # Home screen
│   ├── location_screen.dart          # Location tracking/display screen
│   ├── login_screen.dart             # Authentication login screen
│   ├── map_screen.dart               # Map view for deliveries
│   ├── orders_screen.dart            # Orders list screen
│   ├── profile_screen.dart           # Agent profile screen
│   └── waiting_screen.dart           # Waiting/loading screen
│
├── services/                          # Business logic and API services
│   ├── auth_service.dart             # Authentication service
│   ├── details_service.dart          # Agent details service
│   └── order_service.dart            # Order management service
│
└── widgets/                           # Reusable UI components
    ├── delivered_order_screen.dart   # Delivered orders widget/screen
    ├── online_status_toggle_card.dart # Online/offline status toggle
    ├── order_card.dart               # Order card component
    ├── order_details_screen.dart     # Order details widget/screen
    ├── personal_info_screen.dart     # Personal information widget/screen
    ├── unverified_profile_screen.dart # Unverified profile view
    └── verification_pending_screen.dart # Verification pending view
```

## 📝 Detailed File Descriptions

### Root Files

#### `main.dart`
- **Purpose**: Application entry point
- **Contains**: 
  - App initialization
  - MultiProvider setup for state management
  - MaterialApp configuration
  - SplashScreen implementation
  - App routing configuration

#### `secrets.dart`
- **Purpose**: Configuration file for sensitive data
- **Contains**: 
  - API keys
  - Secret tokens
  - Environment-specific configurations
- **Note**: Should be added to `.gitignore`

---

### 📦 Models Directory

Data models representing the core entities of the application.

#### `agent_details_model.dart`
- **Purpose**: Agent profile data structure
- **Likely Contains**:
  - Agent ID
  - Name and contact information
  - License details
  - Verification status
  - Profile information
  - JSON serialization methods

#### `order_model.dart`
- **Purpose**: Order data structure
- **Likely Contains**:
  - Order ID
  - Customer information
  - Delivery address
  - Order status
  - Items and pricing
  - Timestamps
  - JSON serialization methods

---

### 🔄 Providers Directory

State management using the Provider pattern for reactive UI updates.

#### `agent_details_provider.dart`
- **Purpose**: Manages agent profile state across the app
- **Likely Contains**:
  - Agent details data
  - Loading states
  - Update methods
  - notifyListeners() calls

#### `order_provider.dart`
- **Purpose**: Manages orders state and business logic
- **Likely Contains**:
  - Orders list
  - Active/pending/completed order filters
  - Order update methods
  - Real-time order status updates

---

### 📱 Screens Directory

Full-page screens that represent different views in the application.

#### `login_screen.dart`
- **Purpose**: User authentication interface
- **Features**: Login form, authentication validation

#### `waiting_screen.dart`
- **Purpose**: Loading or waiting state screen
- **Features**: Progress indicators, status messages

#### `home_screen.dart`
- **Purpose**: Main home screen after login
- **Features**: Navigation to other screens, quick actions

#### `dashboard_screen.dart`
- **Purpose**: Overview dashboard
- **Features**: Statistics, quick access to features

#### `orders_screen.dart`
- **Purpose**: List view of all orders
- **Features**: Order filtering, sorting, status updates

#### `map_screen.dart`
- **Purpose**: Map view for deliveries
- **Features**: GPS tracking, route display, customer location

#### `location_screen.dart`
- **Purpose**: Location tracking and management
- **Features**: Current location, location permissions

#### `profile_screen.dart`
- **Purpose**: Agent profile management
- **Features**: Profile editing, settings, logout

---

### 🛠️ Services Directory

Business logic layer handling API calls and data operations.

#### `auth_service.dart`
- **Purpose**: Authentication operations
- **Likely Methods**:
  - login()
  - logout()
  - checkAuthStatus()
  - Token management

#### `details_service.dart`
- **Purpose**: Agent details operations
- **Likely Methods**:
  - fetchAgentDetails()
  - updateAgentDetails()
  - checkLicenseStatus()
  - Profile verification

#### `order_service.dart`
- **Purpose**: Order management operations
- **Likely Methods**:
  - fetchOrders()
  - updateOrderStatus()
  - acceptOrder()
  - completeDelivery()
  - API communication

---

### 🧩 Widgets Directory

Reusable UI components and smaller screen components.

#### `order_card.dart`
- **Purpose**: Reusable order card component
- **Usage**: Display individual orders in lists

#### `order_details_screen.dart`
- **Purpose**: Detailed view of a single order
- **Features**: Full order information, action buttons

#### `delivered_order_screen.dart`
- **Purpose**: View for completed deliveries
- **Features**: Delivery confirmation, receipt

#### `online_status_toggle_card.dart`
- **Purpose**: Toggle agent online/offline status
- **Features**: Status indicator, toggle button

#### `personal_info_screen.dart`
- **Purpose**: Personal information display/edit
- **Features**: Form fields for agent details

#### `unverified_profile_screen.dart`
- **Purpose**: Screen shown when profile is unverified
- **Features**: Verification instructions, status info

#### `verification_pending_screen.dart`
- **Purpose**: Screen shown during verification process
- **Features**: Pending status, verification progress

---

## 🏗️ Architecture Pattern

This application follows a **layered architecture**:

1. **Presentation Layer** (Screens & Widgets)
   - UI components
   - User interactions
   - Navigation

2. **Business Logic Layer** (Providers & Services)
   - State management
   - Business rules
   - API communication

3. **Data Layer** (Models)
   - Data structures
   - Serialization/Deserialization

## 🔑 Key Technologies

- **Flutter**: UI framework
- **Provider**: State management
- **HTTP/Dio**: API communication (likely)
- **Maps**: Location and routing features
- **Geolocator**: Location services

## 📋 Best Practices Observed

1. **Separation of Concerns**: Clear separation between UI, logic, and data
2. **Reusable Components**: Widgets directory for shared components
3. **State Management**: Provider pattern for reactive updates
4. **Service Layer**: Centralized API and business logic
5. **Model Layer**: Structured data representations

## 🔮 Potential Enhancements

Consider adding these folders for scalability:

```
lib/
├── constants/              # App constants and enums
│   ├── app_colors.dart
│   ├── app_strings.dart
│   └── routes.dart
│
├── utils/                  # Utility functions
│   ├── validators.dart
│   ├── formatters.dart
│   └── helpers.dart
│
├── config/                 # Configuration files
│   ├── api_config.dart
│   └── app_config.dart
│
└── routes/                 # Route management
    └── app_router.dart
```

---

**Generated**: October 17, 2025  
**Project**: Delivery Agent Application  
**Framework**: Flutter
