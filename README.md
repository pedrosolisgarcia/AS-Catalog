# Agnieszka Światły Catalog #

### What is this repository for? ###

* This repository stores the updates performed over the iPad application Catalog for the Wedding Dresses firm Agnieszka Światły.

* Version: 3.0

### How do I get set up? ###

* Summary: The app shows the dresses catalog allowing the user to see them in small mosaics view or carousel view. The user is
also able to select the dress to zoom it in. The user will select the dresses that she would like to try. Once the user has 
his/her selection, it will confirm it so the information gets stored.

* Back End Configuration: The app is syncronised with an AWS server used as backend, which the app tries to store the information. If there would be any reason why the information does not get to the server, the data is automatically backed up locally in CoreData, until the server is available again, making the app extract and removed the data locally to store it in the back end.

* Tests: There are Unit Tests being performed to cover all the user actions. The already available ones are based on the data introduced by the user.

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* iOS Developer (Front End): Pedro Solis Garcia (solisgpedro@gmail.com)
* Back End Developer: José Antonio Jiménez Hernández (josetalito@gmail.com)
