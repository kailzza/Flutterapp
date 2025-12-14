# ScholarTrack (Flutter)

A Flutter application to track scholarship applications.

## Quick Start

Prerequisites:
- Flutter SDK installed and on PATH
- Android SDK for building APKs
- (Optional) iOS development requires Xcode and a macOS runner

Install dependencies and check code:

```powershell
cd 'E:\Flutter BrigthPath App'
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser # optionally if scripts blocked
scripts\checks.ps1 -RunTests

If you do not have a global Flutter command on PATH but want to use the SDK bundled in this repo (under `flutter/`), run:

```powershell
scripts\setup-flutter.ps1
If you see "flutter : The term 'flutter' is not recognized" in PowerShell when running `flutter` commands, either:

- Run the local SDK directly for this session:

```powershell
$env:Path += ';E:\Flutter BrigthPath App\flutter\bin'
flutter analyze
```

- Persist for the current user (then restart PowerShell/VSCode):

```powershell
[Environment]::SetEnvironmentVariable('Path', $env:Path + ';E:\Flutter BrigthPath App\flutter\bin', 'User')
# OR use the helper script that simplifies this:
scripts\setup-flutter.ps1 -Persist
```

Or install Flutter globally and add it to your PATH following the official docs: https://docs.flutter.dev/get-started/install

# or to persist for your user account:
scripts\setup-flutter.ps1 -Persist
```
```

Run the app (specify device id if needed):

```powershell
scripts\run.ps1
# or
scripts\run.ps1 -DeviceId <device-id>
```

## Hooks

Install git hooks for pre-commit checks:

```powershell
scripts\setup-hooks.ps1
# On macOS/Linux make .githooks/pre-commit executable:
chmod +x .githooks/pre-commit

# Git will now run the pre-commit checks before each commit
```

## XAMPP local API setup

This project can work with a REST API served by a local XAMPP stack (PHP + MySQL). Below are example steps to run an API on your development machine and connect the Flutter app to it.

1. Install XAMPP and start Apache & MySQL services.
2. Create a `scholarships` MySQL table with columns compatible with the model: `id` (auto-increment), `name`, `provider`, `deadline`, `status`, `notes`, `lat`, `lng`.
3. Place a simple PHP REST endpoint in your XAMPP `htdocs` folder, for example: `htdocs/api/scholarships.php` (sample below). You can also use `server/sql/seed.sql` to add sample data to your `scholarships` table.
4. Configure the `HttpApiService.baseUrl` in `lib/services/http_api_service.dart` if needed (default: `http://10.0.2.2:8080/api` for Android emulator). For a device on the same network, use your machine IP (e.g., `http://192.168.1.10/api`).

SQL for creating the `scholarships` table:

```sql
CREATE TABLE scholarships (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  provider VARCHAR(255) NOT NULL,
  deadline VARCHAR(50) DEFAULT '',
  status VARCHAR(50) DEFAULT 'pending',
  notes TEXT,
  lat DOUBLE NULL,
  lng DOUBLE NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Sample `scholarships.php` for XAMPP (very basic - adjust and secure for production):

```php
<?php
header('Content-Type: application/json');
$host = '127.0.0.1';
$db = 'your_db';
$user = 'root';
$pass = '';
$dsn = "mysql:host=$host;dbname=$db;charset=utf8mb4";

try {
  $pdo = new PDO($dsn, $user, $pass);
} catch (PDOException $e) {
  http_response_code(500);
  echo json_encode(['error' => $e->getMessage()]);
  exit;
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
  $stmt = $pdo->query('SELECT * FROM scholarships ORDER BY id DESC');
  $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
  echo json_encode($rows);
  exit;
}

if ($method === 'POST') {
  $data = json_decode(file_get_contents('php://input'), true);
  $stmt = $pdo->prepare('INSERT INTO scholarships (name, provider, deadline, status, notes, lat, lng) VALUES (?, ?, ?, ?, ?, ?, ?)');
  $stmt->execute([
    $data['name'] ?? '',
    $data['provider'] ?? '',
    $data['deadline'] ?? '',
    $data['status'] ?? '',
    $data['notes'] ?? '',
    $data['lat'] ?? null,
    $data['lng'] ?? null,
  ]);
  echo json_encode(['id' => $pdo->lastInsertId()]);
  exit;
}

http_response_code(405);
echo json_encode(['error' => 'Method not supported']);
```

Local testing commands (after you start XAMPP and configure API):
```powershell
# Install packages
flutter pub get

# Run analyzer
flutter analyze

# Run the app
flutter run -d <device-id>
```

If you want, I can provide a sample PHP file structure and SQL for the `scholarships` table. The project includes `server/sql/schema.sql` and `server/sql/seed.sql` for quick setup.

## CRUD UI

List items offer an Edit/Delete popup menu. Tap the three-dot menu on each item to edit or remove it; changes are synchronized via the REST API.
