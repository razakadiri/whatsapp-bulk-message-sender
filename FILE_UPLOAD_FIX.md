# File Upload Fix

## Problem
Users were experiencing "Failed to upload file. Please try again. Route not found" when trying to upload images in the template management system.

## Root Cause
The issue was in the client-side API service. The upload endpoint was incorrectly configured:
- Server endpoint: `/api/upload`
- Client was calling: `/upload`

This mismatch caused the request to hit the 404 handler instead of the upload endpoint.

## Solution
Updated the client-side API service to use the correct endpoint path:

```javascript
// Before (incorrect)
const response = await api.post('/upload', formData, {
  headers: {
    'Content-Type': 'multipart/form-data',
  },
});

// After (correct)
const response = await api.post('/api/upload', formData, {
  headers: {
    'Content-Type': 'multipart/form-data',
  },
});
```

## Verification
1. Confirmed the server-side endpoint `/api/upload` exists and is properly configured
2. Verified the uploads directory is writable
3. Tested the endpoint with a simple script
4. Confirmed the server is running and connected to MongoDB

## Additional Notes
- The server uses Multer for file handling with proper validation
- Files are stored in the `server/uploads/` directory
- Files are served statically at `/uploads/filename.ext`
- Authentication is required for all upload operations
- File type and size limits are enforced

## How to Test
1. Start the server: `cd server && npm start`
2. Try uploading an image file in the template form
3. Check that the file appears in the `server/uploads/` directory
4. Verify the file is accessible at `http://localhost:5005/uploads/filename.ext`

## File Storage
- Location: `server/uploads/`
- Filename format: `fieldname-timestamp-random.ext`
- Size limit: 50MB per file
- Supported types: Images, PDF, DOC, DOCX, Audio, Video

## Security
- Authentication required for uploads
- File type validation on both client and server
- Unique filenames prevent conflicts
- Size limits prevent abuse