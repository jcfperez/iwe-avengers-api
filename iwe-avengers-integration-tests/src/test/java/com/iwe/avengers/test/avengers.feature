Feature: Perform integrated tests on the Avengers registration API

Background:
* url 'https://blr3a0vfcg.execute-api.us-east-1.amazonaws.com/dev'

Scenario: Get Avenger by Id

Given path 'avengers','531'
When method get
Then status 200
And match response == {id: '#string', name: 'Iron Man', secretIdentity: 'Tony Stark'} 