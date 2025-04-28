Solution to resolve Deployment Error for netbeans
1. Locate to C:\Users\gohch\Documents\NetBeansProjects\MajuTech\nbproject, delete the folder so called private. //CHECK THE CONTENT OF THE FILES INSIDE BEFORE DELETING.
2. Check if your JDK version is JDK-17, GlassFish 6.2.5, Jakarta EE Web 9.1.
3. Jakarta EE Web 9.1 is automatically assigned when you deploy the Project with GlassFish 6.2.5, and GlassFish 6.2.5 only can run with JDK-17
4. Remove your current GlassFish server from NetBeans IDE, close your NetBeans and remove the folder of GlassFish from path C:/Users/<Username>/GlassFish
5. Reopen GlassFish Server, right-click MajuTech project and find Resolve Missing Server Problem (Above Properties), reinstall GlassFish 6.2.5 from there and select it as server.
6. Install JDK-17 from https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html

Solution to resolve "The module has not been deployed."
1. Check if the content in glassfish-resources.xml is correct. 
2. Replace the older version of derby.jar and derbyclient.jar file in path glassfish/domains/domain1/lib/ext/
3. Make sure to restart the Glassfish server and clean and build project.


Client Username: ethan/jovel	
Client Password: 123		

Admin Username: manager
Admin Password: majutech123

Staff Username: staff1	
Staff Password: 123456