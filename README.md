# DMS – Document Management System (Local Bash-Based)

A simple, secure, and modular **Document Management System (DMS)** built using Bash scripts.  
This system allows user authentication, role-based access, file management, backups, activity logging, and read-only viewing functionality.

---

## 📌 Features

### 🔐 **User Authentication**
- Local login using `users.txt`
- Username:Password:Role format
- Supports 3 roles:
  - **admin** – full access
  - **staff** – upload/delete/list/search/view
  - **viewer** – view-only (read-only file access)

---

## 📁 **File Management**
- Upload files (admin & staff)
- Delete files (admin & staff)
- List stored documents
- Read-only file viewer (all roles)
- Secure storage inside `docs/`

---

## 🔍 **Search**
- Filename-based search inside the document directory
- Logs all search actions (term used, user, result)

---

## 🗂️ **User Management (admin only)**
- Add new users
- Delete users
- Display all registered users

---

## ♻️ **Backup & Restore**
- Create compressed backups of all documents
- Restore from previous backups
- Backups stored in `backups/`

---

## 📝 **Logging**
All user actions are written to `logs/` including:
- Uploads
- Deletions
- Searches
- Login attempts
- File views
- Backups and restores

---

## 📘 **System Requirements**
- Linux environment (Ubuntu recommended)
- Bash 4.0+
- Core utilities (`grep`, `cut`, `tar`, `cp`, `less`, etc.)

---

## 🚀 **How to Run**
1. Extract the project folder
2. Open terminal in the project directory
3. Run:

```bash
bash main.sh
```

---

## 🔧 **Directory Structure**
```
dms_final/
 ├── main.sh
 ├── user_manager.sh
 ├── file_manager.sh
 ├── search.sh
 ├── backup.sh
 ├── restore.sh
 ├── logger.sh
 ├── users.txt
 ├── roles.txt
 ├── docs/
 ├── logs/
 └── backups/
```

---

## 👁️ **Read-Only Viewer**
Users (including `viewer` role) can view files without modifying them:

```bash
bash file_manager.sh view filename.txt username
```

Uses `less` or `cat` for read-only mode.

---

## 🛡️ **Permissions**
- All uploaded files stored with permission **640**
- Prevents unauthorized writing or editing
- Only admin/staff can upload or delete

---

## 🧩 **Extensibility**
The system is modular:
- Each feature is a standalone script
- Easy to add, remove, or update functions
- Perfect for learning or lightweight local document workflows

---

## 📄 License
Free to use, modify, and distribute.

---

## ✨ Author
Developed by **Youssef Ashraf**.

