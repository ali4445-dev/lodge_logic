# Backend Schema Alignment - Complete Documentation

## Overview
Updated all models and services to align with the new backend database schema. All CRUD operations are now fully integrated with Supabase.

---

## Database Tables & Schema

### 1. Users Table
Stores all user types (Owner, Customer, Admin)

**Fields:**
- `user_id`: AutoField (Primary Key)
- `name`: CharField (max_length=100)
- `email`: EmailField (unique, max_length=191)
- `phone`: CharField (max_length=20)
- `password`: CharField (max_length=255)
- `role`: CharField (Choices: 'owner', 'customer', 'admin')
- `is_approved`: BooleanField (default=False)
- `profile_image`: ImageField (upload_to="profile_images/")
- `last_login`: DateTimeField
- `date_joined`: DateTimeField
- `created_at`: DateTimeField
- `is_deleted`: BooleanField

### 2. GuestHouses Table
Represents a property owned by a user

**Fields:**
- `guesthouse_id`: AutoField (Primary Key)
- `owner_id`: ForeignKey to Users
- `name`: CharField (max_length=255)
- `address`: CharField (max_length=255)
- `city`: CharField (max_length=100)
- `country`: CharField (max_length=100)
- `total_rooms`: IntegerField
- `description`: TextField
- `amenities`: JSONField (List of strings)
- `images`: JSONField (List of strings)
- `is_active`: BooleanField (default=True)
- `created_at`: DateTimeField

### 3. Rooms Table
Individual rooms within a guest house

**Fields:**
- `room_id`: AutoField (Primary Key)
- `guesthouse_id`: ForeignKey to GuestHouses
- `room_number`: CharField (max_length=50)
- `floor`: IntegerField
- `capacity`: IntegerField
- `price`: DecimalField (max_digits=10, decimal_places=2)
- `description`: TextField
- `amenities`: JSONField
- `is_available`: BooleanField (default=True)
- `status`: CharField (Choices: 'available', 'occupied', 'maintenance')
- `created_at`: DateTimeField

### 4. Bookings Table
Reservation records connecting guests, guest houses, and rooms

**Fields:**
- `booking_id`: CharField (Primary Key, max_length=20)
- `guest_id`: ForeignKey to Users
- `guesthouse_id`: ForeignKey to GuestHouses
- `room_id`: ForeignKey to Rooms
- `check_in`: DateField
- `check_out`: DateField
- `rooms_count`: IntegerField
- `guests_count`: IntegerField
- `amount`: DecimalField (max_digits=10, decimal_places=2)
- `status`: CharField (Choices: 'pending', 'confirmed', 'cancelled', 'completed')
- `booking_date`: DateTimeField
- `created_at`: DateTimeField

### 5. Admins Table
Links an Admin user to the Owner who created them

**Fields:**
- `admin_id`: AutoField (Primary Key)
- `user_id`: OneToOneField to Users
- `owner_id`: ForeignKey to Users (who created the admin)
- `name`: CharField
- `email`: CharField
- `created_at`: DateTimeField
- `is_active`: BooleanField (default=True)

---

## Models Updated

### 1. UserProfile Model (`lib/models/user_profile.dart`)
**Fields:**
```dart
- userId: String?
- name: String
- email: String
- phone: String?
- password: String?
- role: String ('owner', 'customer', 'admin')
- isApproved: bool?
- profileImage: String?
- lastLogin: DateTime?
- dateJoined: DateTime?
- createdAt: DateTime?
- isDeleted: bool?
```

### 2. GuestHouse Model (`lib/models/guest_house.dart`)
**Fields:**
```dart
- guesthouseId: String?
- ownerId: String?
- name: String
- address: String?
- city: String
- country: String
- totalRooms: int
- description: String?
- amenities: List<String>?
- images: List<String>?
- isActive: bool?
- createdAt: DateTime?
```

### 3. Room Model (`lib/models/room.dart`)
**Fields:**
```dart
- roomId: String?
- guesthouseId: String?
- roomNumber: String?
- floor: int?
- capacity: int?
- price: double?
- description: String?
- amenities: List<String>?
- isAvailable: bool?
- status: String ('available', 'occupied', 'maintenance')
- createdAt: DateTime?
```

### 4. Booking Model (`lib/models/booking.dart`)
**Fields:**
```dart
- bookingId: String?
- guestId: String?
- guesthouseId: String?
- roomId: String?
- checkIn: DateTime?
- checkOut: DateTime?
- roomsCount: int?
- guestsCount: int?
- amount: double?
- status: String ('pending', 'confirmed', 'cancelled', 'completed')
- bookingDate: DateTime?
- createdAt: DateTime?
```

### 5. Admin Model (`lib/models/admin.dart`)
**Fields:**
```dart
- adminId: String?
- userId: String?
- ownerId: String?
- name: String?
- email: String?
- createdAt: DateTime?
- isActive: bool?
```

---

## Services - CRUD Operations

### 1. UserService (`lib/services/user_service.dart`)

**Available Methods:**
```dart
// Create
createUser(UserProfile user) → bool

// Read
getUserById(String userId) → UserProfile?
getUserByEmail(String email) → UserProfile?
getCurrentUser() → UserProfile?
getUsersByRole(String role) → List<UserProfile>
getApprovedOwners() → List<UserProfile>
getPendingAdmins() → List<UserProfile>

// Update
updateUser(UserProfile user) → bool
approveUser(String userId) → bool
updateLastLogin(String userId) → bool

// Delete
deleteUser(String userId) → bool
```

### 2. GuestHouseService (`lib/services/guest_house_service.dart`)

**Available Methods:**
```dart
// Create
addGuestHouse(GuestHouse guestHouse) → bool

// Read
getUserGuestHouses() → List<GuestHouse>
getGuestHouseById(String guesthouseId) → GuestHouse?
getAllActiveGuestHouses() → List<GuestHouse>

// Update
updateGuestHouse(GuestHouse guestHouse) → bool
deactivateGuestHouse(String guesthouseId) → bool

// Delete
deleteGuestHouse(String guesthouseId) → bool
```

### 3. RoomService (`lib/services/room_service.dart`)

**Available Methods:**
```dart
// Create
createRoom(Room room) → bool

// Read
getRoomsByGuestHouse(String guesthouseId) → List<Room>
getRoomById(String roomId) → Room?
getAvailableRooms(String guesthouseId) → List<Room>

// Update
updateRoom(Room room) → bool
updateRoomStatus(String roomId, String status) → bool
updateRoomAvailability(String roomId, bool isAvailable) → bool

// Delete
deleteRoom(String roomId) → bool
```

### 4. BookingService (`lib/services/booking_service.dart`)

**Available Methods:**
```dart
// Create
createBooking(Booking booking) → bool

// Read
getGuestBookings() → List<Booking>
getGuestHouseBookings(String guesthouseId) → List<Booking>
getBookingById(String bookingId) → Booking?
getRoomBookings(String roomId) → List<Booking>
getActiveBookings(String guesthouseId) → List<Booking>

// Update
updateBookingStatus(String bookingId, String status) → bool
cancelBooking(String bookingId) → bool

// Delete
deleteBooking(String bookingId) → bool
```

### 5. AdminService (`lib/services/admin_service.dart`)

**Available Methods:**
```dart
// Create
createAdmin(Admin admin) → bool

// Read
getOwnerAdmins() → List<Admin>
getAdminById(String adminId) → Admin?
getAdminByUserId(String userId) → Admin?
getAdminsByOwner(String ownerId) → List<Admin>

// Update
updateAdmin(Admin admin) → bool
deactivateAdmin(String adminId) → bool

// Delete
deleteAdmin(String adminId) → bool
```

---

## Usage Examples

### Create a Guest House
```dart
GuestHouse guestHouse = GuestHouse(
  name: 'Beautiful Villa',
  city: 'New York',
  country: 'USA',
  totalRooms: 5,
  address: '123 Main St',
  description: 'Luxury villa',
  amenities: ['WiFi', 'Pool', 'Gym'],
  images: ['url1', 'url2'],
);

bool success = await GuestHouseService.addGuestHouse(guestHouse);
```

### Fetch User's Guest Houses
```dart
List<GuestHouse> myHouses = await GuestHouseService.getUserGuestHouses();
```

### Create a Room
```dart
Room room = Room(
  guesthouseId: 'gh_123',
  roomNumber: '101',
  floor: 1,
  capacity: 2,
  price: 99.99,
  status: 'available',
  amenities: ['WiFi', 'AC'],
);

bool success = await RoomService.createRoom(room);
```

### Create a Booking
```dart
Booking booking = Booking(
  guesthouseId: 'gh_123',
  roomId: 'room_123',
  checkIn: DateTime(2025, 12, 25),
  checkOut: DateTime(2025, 12, 27),
  roomsCount: 1,
  guestsCount: 2,
  amount: 299.97,
  status: 'pending',
);

bool success = await BookingService.createBooking(booking);
```

### Create an Admin
```dart
Admin admin = Admin(
  userId: 'user_123',
  name: 'John Admin',
  email: 'admin@example.com',
  ownerId: 'owner_123',
  isActive: true,
);

bool success = await AdminService.createAdmin(admin);
```

---

## Key Features

✅ **Full CRUD Operations** - Create, Read, Update, Delete operations for all entities
✅ **Supabase Integration** - All services use Supabase client for data persistence
✅ **DateTime Handling** - Proper ISO8601 string conversion for date fields
✅ **JSON Serialization** - fromJson() and toJson() for all models
✅ **Error Handling** - Try-catch blocks with informative error messages
✅ **Logging** - Console output for debugging (✅ success, ❌ error)
✅ **User Context** - Services automatically use current authenticated user
✅ **Query Filtering** - Support for filtering, sorting, and conditional queries
✅ **Relationships** - Proper handling of foreign keys and relationships
✅ **Active Records** - Soft delete support with is_active/is_deleted fields

---

## Important Notes

1. **Authentication Required**: Most services use `supabase.auth.currentUser!.id` - ensure user is authenticated
2. **Table Names**: Ensure your Supabase table names match:
   - `users`
   - `guesthouses`
   - `rooms`
   - `bookings`
   - `admins`
3. **Field Names**: Ensure field names in Supabase match the snake_case names in schema
4. **RLS Policies**: Configure Row Level Security policies in Supabase for proper access control
5. **Indexes**: Create indexes on foreign key fields for better query performance

---

## Next Steps

1. Create the tables in Supabase with the exact schema specified
2. Set up RLS (Row Level Security) policies for data access control
3. Test each service method in your UI screens
4. Update screens that use the old field names (ghId → guesthouseId, etc.)
5. Implement proper error handling in UI for better user feedback

