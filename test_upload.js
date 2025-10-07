const axios = require('axios');
const fs = require('fs');
const path = require('path');

// Create a test file
const testFilePath = path.join(__dirname, 'test_image.jpg');
fs.writeFileSync(testFilePath, 'This is a test file content');

// Test if the upload endpoint exists
async function testEndpoint() {
  try {
    const response = await axios.options('http://localhost:5005/api/upload');
    console.log('Endpoint exists:', response.status);
  } catch (error) {
    if (error.response) {
      console.log('Endpoint exists but requires authentication:', error.response.status);
    } else {
      console.log('Endpoint not found or server not running');
    }
  }
}

testEndpoint();

// Test the upload endpoint
async function testUpload() {
  try {
    // First, we need to get a token. For testing purposes, we'll create a fake one
    // In a real scenario, you would login to get a real token
    const fakeToken = 'fake-test-token';
    
    const formData = new FormData();
    formData.append('file', fs.createReadStream(testFilePath));
    
    const response = await axios.post('http://localhost:5005/api/upload', formData, {
      headers: {
        'Authorization': `Bearer ${fakeToken}`,
        'Content-Type': 'multipart/form-data',
      },
    });
    
    console.log('Upload successful:', response.data);
  } catch (error) {
    console.error('Upload failed:', error.response?.data || error.message);
  } finally {
    // Clean up test file
    if (fs.existsSync(testFilePath)) {
      fs.unlinkSync(testFilePath);
    }
  }
}

testUpload();