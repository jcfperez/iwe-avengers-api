Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://blr3a0vfcg.execute-api.us-east-1.amazonaws.com/dev'

 * def getToken =
"""
function() {
 var TokenGenerator = Java.type('com.iwe.avengers.test.authorization.TokenGenerator');
 var sg = new TokenGenerator();
 return sg.getToken();
}
"""
* def token = call getToken

Scenario: Should  Return invalid access

Given path 'avengers', 'any-id'
When method get
Then status 401

Scenario: Should return not found Avengers

Given path 'avengers','not-found-id'
And header Authorization = 'Bearer ' + token
When method get
Then status 404
 
	
Scenario: Create Avenger and search

Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {name:'Iron Man', secretIdentity: 'Tony Stark'} 
When method post
Then status 201
And match response == {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'}

* def savedAvenger = response

Given path 'avengers',savedAvenger.id
And header Authorization = 'Bearer ' + token
When method get
Then status 200
And match response == savedAvenger 
 
Scenario: Should return not found Avengers

Given path 'avengers','not-found-id'
And header Authorization = 'Bearer ' + token
When method get
Then status 404


Scenario: Must return 400 for invalid create payload

Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {secretIdentity: 'Tony Stark'} 
When method post
Then status 400

Scenario: Must return 400 for invalid create payload when update 
And header Authorization = 'Bearer ' + token
Given path 'avengers','aaaa-bbbb-cccc-dddd'
And request {secretIdentity: 'Tony Stark'} 
When method put
Then status 400

Scenario: Should return not found Avengers when update

Given path 'avengers','not-found-id'
And header Authorization = 'Bearer ' + token
And request {name:'Hulk', secretIdentity: 'Doctor Banner'} 
When method put
Then status 404


Scenario: Update Avenger

Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {name:'Captain', secretIdentity: 'Steve'} 
When method post
Then status 201

* def savedAvenger2 = response

Given path 'avengers',savedAvenger2.id
And header Authorization = 'Bearer ' + token
And request {name:'Captain America', secretIdentity: 'Steve Rogers'} 
When method put
Then status 200

* def savedAvenger3 = response

Given path 'avengers',savedAvenger3.id
And header Authorization = 'Bearer ' + token
When method get
Then status 200
And match response == savedAvenger3 

Scenario: Delete Avenger

Given path 'avengers'
And header Authorization = 'Bearer ' + token
And request {name:'Hulk', secretIdentity: 'Banner'} 
When method post
Then status 201

* def savedAvenger = response

Given path 'avengers', savedAvenger.id
And header Authorization = 'Bearer ' + token
When method delete
Then status 204

Given path 'avengers',savedAvenger.id
And header Authorization = 'Bearer ' + token
When method get
Then status 404






