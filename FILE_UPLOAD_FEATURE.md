# File Upload Feature for Template Headers

## Overview
This feature adds support for uploading media files (images, documents, audio, video) as headers in WhatsApp message templates. Users can now create templates with rich media content in addition to text-only headers.

## Features Implemented

### 1. Client-Side Components
- **FileUpload Component**: A reusable drag-and-drop file upload component with validation
- **Enhanced TemplateForm**: Updated form with file upload capability for non-text header types
- **Improved WhatsAppPreview**: Preview support for media headers

### 2. Server-Side Implementation
- **File Upload Endpoint**: New `/api/upload` endpoint for handling file uploads
- **Multer Configuration**: Proper file validation and storage configuration
- **Static File Serving**: Uploaded files served from `/uploads` directory

### 3. Supported File Types
- **Images**: JPG, PNG, GIF, WEBP
- **Documents**: PDF, DOC, DOCX
- **Audio**: MP3, WAV, OGG
- **Video**: MP4, MOV, AVI, WEBM

### 4. File Size Limits
- Maximum file size: 50MB per file

## How It Works

### 1. User Interface
1. User selects a non-text header type (Image, Document, or Video)
2. File upload area appears with appropriate file type restrictions
3. User can drag and drop files or click to select
4. File is uploaded to the server and URL is stored in the template

### 2. Technical Flow
1. File is selected by user
2. File is sent to `/api/upload` endpoint via POST request
3. Server validates file type and size
4. File is saved to `uploads/` directory with unique filename
5. Server returns file URL
6. URL is stored in template header.mediaUrl field

### 3. Preview
- Images are displayed as thumbnails
- Documents show a document icon with "Document Preview" text
- Audio/Video show appropriate icons with "Audio/Video Preview" text

## API Endpoints

### Upload File
```
POST /api/upload
Content-Type: multipart/form-data

Form Data:
- file: [file data]

Response:
{
  "success": true,
  "data": {
    "filename": "file-123456789.jpg",
    "originalName": "my-image.jpg",
    "size": 123456,
    "mimetype": "image/jpeg",
    "url": "/uploads/file-123456789.jpg"
  }
}
```

## File Storage
- Files are stored in the `server/uploads/` directory
- Filenames are made unique using timestamp and random numbers
- Files are served statically at `/uploads/filename.ext`

## Security Considerations
- File type validation on both client and server
- File size limits enforced
- Unique filenames prevent conflicts
- Authentication required for upload endpoint

## Error Handling
- File size exceeded errors
- Unsupported file type errors
- Upload failures with user feedback
- Graceful degradation when uploads fail

## Future Improvements
- Cloud storage integration (AWS S3, Google Cloud Storage)
- File compression for images
- Progress indicators for large file uploads
- Batch upload support
- File management interface