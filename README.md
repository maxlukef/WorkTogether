# Work Together

## Project Description

Work Together is a project aimed at streamlining the group project creation and management for students and teachers. It will allow students to find compatible group members that they will be able to work effectively with, and allow professors to manage groups throughout the project and gain insight into how the class is performing through project milestones and team surveys.

## Getting started - Frontend Flutter Install
- To get Flutter running locally on your machine follow the flutter install documentation here: https://docs.flutter.dev/get-started/install
- Select your operating system the team currently all use Windows so we recommend using that operating system
- When following the Flutter SDK install guide we recommend completing everything the guide says to do. Although we don’t use the android emulator for local development we still recommend downloading it in case of a Flutter SDK dependency issue.
- Once the SDK is installed we recommend setting up Flutter with VS Code because it has a compatible extension. IntelliJ is also compatible with Flutter development.
- When Flutter is fully installed on your machine pull down the mono repository with both the Flutter frontend and .NET backend.
- Next run ‘flutter doctor’ to verify flutter is installed correctly.
- Next run ‘flutter pub upgrade’ to get all the latest versions of the project dependencies
- Next navigate to the http_request.dart file and make sure you are using local host as the connection string for local development.
- Finally Locate the VS Code status bar (the blue bar at the bottom of the window): select an emulator OR run the application without debugging to launch the application in a web app format.
- Note: While the frontend will be up and running on your machine you will have to setup and run the backend separately to be able to log into the application.

## Getting started - Backend .NET 6.0 install
- Download the .NET 6.0 SDK here and follow the installation process:
https://dotnet.microsoft.com/en-us/download/dotnet/6.0
- We recommend using Windows for this as Work Together was developed in a Windows environment
- We recommend using Visual Studio to build the backend. Pull the mono repository containing both the frontend and backend.
- Ensure that you have MariaDB installed (Version 10.95 or older) and that the connection string in appsettings.json contains valid credentials to your database.
- In Visual Studio, ensure that you have opened the backend solution file (WorkTogether.sln) and not just the directory.
- In Visual Studio’s Package Manager Console, use Update-Database to generate the database tables.
- Finally, hit Run to start the backend. The Swagger UI will start up, allowing you to see all of the API endpoints. You can now start up the frontend to use Work Together locally.
- Note: Most of these calls require a JWT authentication token, so you will need to use the login/register calls to create and/or log in to an account. 

## Troubleshooting (Common Problems)
- Troubleshooting (Common Problems)
- If you are running into state issues on the frontend we recommend dropping all of your tables in HeidiSQL then running update-database from the package manager console in - - Visual Studio with the worktogether.sln file open.
- Likewise if you are running into state issues on the frontend or unable to log into an account we recommend reloading and clearing your cache.

## Authors and acknowledgment
- Alex Childs
- Grayson Spencer
- Max Failla
- Rory Donald

## Project status
Final release was November 20 2023, continued hotfixes for defects until December 8th.

## Building and Running
Our project is run in a standard linux environment. These insructions are specific to Ubuntu 20.04. It is also assumed that you have flutter and C# installed on your instance. If you do not visit these urls to install them.
- https://docs.flutter.dev/get-started/install/linux
- https://learn.microsoft.com/en-us/dotnet/core/install/linux

Once you have the prereqs installed the first thing you need to do is pull the code down to your computer. Once you have the code pulled down you can start building and running the application. We will assume that you have the code in a director called work-together in your home directory.

### Setting up the Server
Follow the instructions at https://ubuntu.com/tutorials/install-and-configure-nginx#1-overview to set up nginx for your server.
We will assume that your site is being run from /var/www/html/work-together.

### Building and Running the Frontend
- Navigate to ~/work-together/work_together_flutter’
- Run ‘sudo flutter build web’
- Run ‘cp -r ~/work-together/work_together_flutter/build/web/* /var/www/html/work-together’

### Building and Running the Backend
- Navigate to ~/work-together/WorkTogether
- If the database needs updating run ‘dotnet ef database update’
- 	You may need to drop the database. If so:
* Mysql -u username -p
* Drop database worktogether
* Create database worktogether
* quit
- Run ‘dotnet publish –configuration Release’
- Run ‘cp -r ~/work-together/WorkTogether/bin/Release/net6.0/* /var/www/html/work-together/api
- Run ‘sudo systemctl restart kestre-worktogether.service’

