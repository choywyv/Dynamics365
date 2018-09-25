# Dynamics365
Quick and dirty way to connect to Dynamics 365 via Azure AD OAUTH2 authtentication.
Lots of dependencies on Maven and other libraries which is making the code extremely long and is to be removed.

Pre requisites
1. Dynamics activated with URL known

Steps to achieve connection
1. Login to Azure portal -> Azure Active Directory -> App registrations
2. New Application Registration -> Native. The Application ID is also the client id
3. Add Dynamic 365 and Grant permission
