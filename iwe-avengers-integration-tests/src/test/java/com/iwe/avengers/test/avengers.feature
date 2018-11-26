Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://blr3a0vfcg.execute-api.us-east-1.amazonaws.com/dev'

Scenario: Should return not found Avengers

Given path 'avengers','not-found-id'
When method get
Then status 404

Scenario: Get Avenger by Id

Given path 'avengers','aaaa-bbbb-cccc-dddd'
When method get
Then status 200
And match response == {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'} 

Scenario: Create Avenger

Given path 'avengers'
And request {name:'Iron Man', secretIdentity: 'Tony Stark'} 
When method post
Then status 201
And match response == {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'} 

Scenario: Must return 400 for invalid create payload

Given path 'avengers'
And request {secretIdentity: 'Tony Stark'} 
When method post
Then status 400

Scenario: Delete Avenger by Id

Given path 'avengers','aaaa-bbbb-cccc-dddd'
When method delete
Then status 204

Scenario: Update Avenger

Given path 'avengers','aaaa-bbbb-cccc-dddd'
And request {name:'Hulk', secretIdentity: 'Doctor Banner'} 
When method put
Then status 200
And match response == {id: '#string', name: 'Hulk', secretIdentity: 'Doctor Banner'} 

Scenario: Must return 400 for invalid create payload when update 
Given path 'avengers','aaaa-bbbb-cccc-dddd'
And request {secretIdentity: 'Tony Stark'} 
When method put
Then status 400




