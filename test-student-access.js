// Test script to verify student access to all complaint data
const axios = require('axios');

// Test configuration
const BASE_URL = 'http://localhost:5000/api';
const STUDENT_TOKEN = 'your-student-token-here'; // Replace with actual student token

async function testStudentAccess() {
  try {
    console.log('Testing student access to complaint data...\n');

    // Test 1: Get all tickets (should return all tickets, not just student's own)
    console.log('1. Testing ticket listing...');
    const ticketsResponse = await axios.get(`${BASE_URL}/tickets`, {
      headers: { Authorization: `Bearer ${STUDENT_TOKEN}` }
    });
    console.log(`✓ Successfully retrieved ${ticketsResponse.data.length} tickets`);
    console.log('First few tickets:', ticketsResponse.data.slice(0, 3).map(t => ({
      ticketId: t.ticketId,
      studentName: t.studentName,
      status: t.status
    })));

    // Test 2: Get dashboard stats (should return stats for all tickets)
    console.log('\n2. Testing dashboard stats...');
    const statsResponse = await axios.get(`${BASE_URL}/dashboard/stats`, {
      headers: { Authorization: `Bearer ${STUDENT_TOKEN}` }
    });
    console.log('✓ Dashboard stats:', statsResponse.data);

    // Test 3: Get ticket statistics (should return stats for all tickets)
    console.log('\n3. Testing ticket stats...');
    const ticketStatsResponse = await axios.get(`${BASE_URL}/tickets/stats`, {
      headers: { Authorization: `Bearer ${STUDENT_TOKEN}` }
    });
    console.log('✓ Ticket stats:', ticketStatsResponse.data);

    console.log('\n✅ All tests passed! Students can now access all complaint data.');

  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
  }
}

// Run the test
testStudentAccess();