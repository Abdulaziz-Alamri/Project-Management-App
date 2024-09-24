<center>
<img src="https://github.com/user-attachments/assets/e8606ed3-b550-47b5-b03a-c2d527af10bc" width="550" />
</center>



# Project Management App

## Overview
This is a Flutter application designed for project management, aiming to provide a comprehensive solution for users to create, manage, and evaluate projects efficiently. The app includes essential features such as QR code scanning for quick evaluations, project creation forms, and a user-friendly interface. Utilizing the BLoC (Business Logic Component) pattern for state management, the app is built to be scalable and maintainable.

## Features
- **QR Code Scanner**: Users can scan QR codes to quickly access project evaluations, streamlining the evaluation process.
- **Add Project Screen**: A dedicated screen that allows users to create new projects by entering a user ID and an end date.
- **Edit Project Screen**: Enables users to modify existing projects, with any changes automatically reflected in the backend API.
- **Custom Add Card**: A reusable UI component designed for adding tasks, featuring a modern design aesthetic.
- **Responsive Design**: The application is built to adapt to various screen sizes, ensuring a seamless experience across devices using the Sizer package.
- **API Integration**: The app fetches, creates, and updates project data from a remote server using robust API calls, facilitating smooth communication between the app and the backend.

## Project Structure
The project is organized into several directories for better maintainability and readability:

- **data_layer/**: Contains the data management code, such as `data_layer.dart`, which handles data retrieval and storage.
- **networking/**: Responsible for API communication, including `api_networking.dart` where all API calls are defined.
- **services/**: Manages initialization and dependency injection, with files like `setup.dart` for configuring services.
- **screens/**: This directory holds various screens of the application:
  - `Auth/first_screen.dart`: The initial screen where users can log in or register.
  - `Evaluation/evaluation_screen.dart`: Displays the project evaluation results after scanning a QR code.
  - `QR_scanner/`: Contains the functionality and UI components for scanning QR codes.
  - `AddProjectScreen.dart`: A screen dedicated to adding new projects.
  - `EditProjectScreen.dart`: A screen for editing existing projects.
  - `User/user_dashboard.dart`: Dashboard specifically designed for user-related functionalities.
  - `Admin/admin_dashboard.dart`: A dashboard for managing admin functionalities, including user management and project oversight.
  - `Supervisor/supervisor_dashboard.dart`: Dashboard for supervisors to manage projects and oversee user submissions.
- **widgets/**: Contains reusable UI components like `custom_add_card.dart` that can be used across different screens.
- **main.dart**: This is the entry point of the application, where the app is initialized and run.

## API Usage
The application interacts with a backend server through a series of API calls. These calls are essential for managing projects and user roles. Here's a detailed breakdown of the API interactions:

### Fetching Projects
- **GET /api/projects**: This endpoint retrieves a list of all projects stored on the server. It is used when users want to view available projects in the app.

### Creating Projects
- **POST /api/projects**: This endpoint allows Supervisor to create a new project. The request body must include necessary details such as user ID and end date. This is used in the Add Project Screen.

### Editing Projects
- **PUT /api/projects/{id}**: Users can modify an existing project by sending a PUT request to this endpoint, replacing `{id}` with the specific project ID. The request body should contain the updated project details.

### User Role Management
The application supports three user roles—Admin, Supervisor, and User—each with specific functionalities managed via API calls:
- **Admin**: Can create, update, and delete any project. Admins have complete access to all API functionalities.
- **Supervisor**: Can add new projects and oversee user contributions. Supervisors can manage project status and monitor progress through API endpoints.
- **User**: Users can edit projects assigned to them and submit changes. Their interactions with projects are also managed through API calls to ensure data integrity.

### Email Verification
- **OTP Service**: The app includes a feature for email verification, where a One-Time Password (OTP) is sent to the user’s email during the registration process. This ensures that users have access to their email accounts before they can log in.

## Technical Details
### Dependencies
This project utilizes a variety of packages and libraries to enhance its functionality:

- **flutter**: The core Flutter SDK, essential for building mobile applications.
- **pinput**: A package that provides modern input fields for enhanced user experience.
- **sizer**: A library that facilitates responsive design, making it easier to create layouts that adapt to various screen sizes.
- **syncfusion_flutter_sliders**: A library that offers advanced slider widgets for better user interaction.
- **input_slider**: A customizable input slider component for the app.
- **dot_curved_bottom_nav**: Implements a curved bottom navigation bar for improved navigation aesthetics.
- **flutter_bloc**: A state management library that follows the BLoC pattern, promoting separation of business logic from UI code.
- **get_it**: A service locator for implementing dependency injection, making it easier to manage dependencies.
- **get_storage**: A simple key-value storage solution for persisting data locally.
- **dio**: A powerful HTTP client for making API requests and handling responses.
- **animated_bottom_navigation_bar**: A customizable animated bottom navigation bar that enhances the app's UI.
- **device_preview**: A tool that allows developers to preview their app on various device configurations.
- **dotted_border**: A widget that helps create dotted borders around elements.
- **outlined_text**: A widget that provides the ability to style text with outlines.
- **percent_indicator**: A package for displaying progress indicators in various formats.
- **file_picker**: A utility for picking files from the user's device.
- **image_picker**: A library for selecting images either from the gallery or capturing them via the camera.
- **font_awesome_flutter**: A package that integrates Font Awesome icons for enhanced visual appeal.
- **flutter_barcode_scanner**: A package for scanning barcodes and QR codes.
- **equatable**: A utility that simplifies equality comparisons in Dart objects.
- **url_launcher**: A package for opening URLs in a mobile browser or in-app.
- **qr_flutter**: A library for generating QR codes for various uses within the app.
- **intl**: A package for internationalization and localization support.
- **flutter_dotenv**: A package that loads environment variables from a `.env` file for configuration.

## GIF
- **Auth_Screans**:

  
![ScreenRecording1446-03-20at5 01 54PM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/201c47ba-abe6-474a-8c1c-725d14911774)

![ScreenRecording1446-03-20at5 21 34PM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/e256fcad-e180-462e-b7b8-bfa4607ee4f9)


![ScreenRecording1446-03-20at5 28 23PM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/83d50d58-6470-4790-b239-da32f783d06c)


- **Home_Screan**:


![ScreenRecording1446-03-20at11 35 02PM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/72fd580f-dc53-410d-aa2a-8f96583ce676)



- **Home_Projects_Screan**:

  
![ScreenRecording1446-03-20at6 59 03PM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/240f799e-53d7-47aa-88ff-030a0470da76)



- **Projects_Screan**:


![ScreenRecording1446-03-20at7 08 57PM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/8d6c9eaf-34c5-42fa-bf52-04c57c587fc0)


- **Projects_Details_Screan**:
  

![ScreenRecording1446-03-20at11 29 19PM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/82a6c562-1b4d-43ef-b383-7172a0acb517)



- **Profile_Screan**:
  

![ScreenRecording1446-03-20at11 25 45PM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/29707edc-d0ea-42bf-a38d-48d6e13bf927)


- **Admin_Screan**:


![ScreenRecording1446-03-20at11 33 00PM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/b26fc070-7397-46c4-8364-86045e51151c)

- **Creat_new_project_Screan**:


  ![ScreenRecording1446-03-21at12 36 25AM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/98928c63-2687-4972-b34d-47e0687f22a1)


- **new_project_after_creating_for_user_Screan**:

  
![WhatsApp Image 1446-03-21 at 00 39 34](https://github.com/user-attachments/assets/0c2b1bb2-b922-49ee-a582-161d55d868e8)

- **Edite_new_project_Screan**:

![ScreenRecording1446-03-21at12 44 01AM-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/3ade4267-fc9e-4994-9039-62bc59ef727a)


- **After_Edit_new_project_Screan**:

  
![Screenshot 1446-03-21 at 12 51 13 AM](https://github.com/user-attachments/assets/6835262b-6124-4e27-bf1a-4073492702a4)


- **Edit_project_Screan**:
  
![Screenshot 1446-03-21 at 12 52 28 AM](https://github.com/user-attachments/assets/c9e685ae-3ae5-474c-a6ca-855abc2b2896)


## Acknowledgments
Special thanks to the Flutter community and contributors for their invaluable resources and support in developing this application.



## Team Members
Muhannad Al-Thaher


Abdulaziz Alamri


Rawan Al Riyad



# 🇸🇦Happy national day🇸🇦


![Screenshot 1446-03-21 at 12 55 38 AM](https://github.com/user-attachments/assets/464fb044-ec72-421f-a183-bc968a3fda39)
=======


