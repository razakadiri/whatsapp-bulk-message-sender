const axios = require('axios');
const jwt = require('jsonwebtoken');

// Create a test token
const JWT_SECRET = 'whatsapp-bulk-sender-secret-key';
const testToken = jwt.sign({ userId: 'test-user-id' }, JWT_SECRET, { expiresIn: '1h' });

// Test the templates API
async function testTemplatesAPI() {
  try {
    console.log('Testing Templates API...');
    
    const config = {
      headers: {
        'Authorization': `Bearer ${testToken}`
      }
    };
    
    // Test get templates
    const templatesResponse = await axios.get('http://localhost:5005/api/templates', config);
    console.log('Get Templates Response:', JSON.stringify(templatesResponse.data, null, 2));
    
    // Test get template stats
    const statsResponse = await axios.get('http://localhost:5005/api/templates/stats/summary', config);
    console.log('Get Template Stats Response:', JSON.stringify(statsResponse.data, null, 2));
    
    console.log('API tests completed successfully!');
  } catch (error) {
    console.error('API test failed:', error.message);
    if (error.response) {
      console.error('Response data:', error.response.data);
      console.error('Status:', error.response.status);
    }
  }
}

testTemplatesAPI();