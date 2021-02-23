# $cammer$ Project
**CASH COW:** Our application is an idle-clicker game that builds upon the wallet assignment from class. We will implement gamification (badges, customization, virtual "currency", rewards/penalties) to educate users on various aspects of personal finance.

## Trello Board
Link: https://trello.com/b/lWbT4HPm/sprint-planning

## Milestone 1 [*February 22*]
### Team Roles
- Bridget: API’s, Firebase, testing + debugging
- Jarod: design, auxiliary support, testing + debugging
- Rachel: front-end programming, testing + debugging
- Angie: team scheduling, reports, sound design

### What We Did
Setup: 
- GitHub repository
- Design document
- Trello board
- Libraries + API’s -- Bridget
- Balsamiq wireframe -- Angie
- App logo -- Jarod
- Outline game currency -- Jarod
View Controllers:
- Launch, Login/Signup -- Bridget + Jarod
- Home, Clicker -- Angie + Rachel

### Next Steps
View Controllers:
- Profile, Settings, Upgrades -- Rachel
- Functioning Clicker -- Angie + Jarod
- Server Support: implementing Firebase APIs -- Bridget
- User Class: income (per click & passive), current money, stamina, timestamps -- Bridget
- Moooney Class: handling currency -- Jarod
- Upgrades Struct: organizing upgrades -- Jarod + Angie

### Wireframe
See `ImagesTempStorage` for .png Wireframe

### View Controllers
- Launch: logo; skip login/signup + verification if user is logged in
- Login/Signup: option to login (returning user), signup (new user) with email, Google, or FB
- Verification: for new users, verify account
- Home Menu: option to start game or logout
- Clicker: click to generate income while stamina is not empty; display user stats
- Settings: options 
- Upgrades: upgrading passive/icnome per click
- Profile: user customization (username, profile image, etc.)

### Third-Party Libraries
- Animations (Spring, Hero)
- UI
- -> Design  (Dynamic Color)
- -> Buttons (EasySocialButton, SSBouncyButton)
- -> Popups (CatAlertController. CRToast)
- -> Other (NVActivityIndicatorView. JVFloatLabeledTextView)
- Parsing (Japx or SwiftyJSON)
- Date & Time (SwiftDate)
- Server Support (Firebase Auth, Analytics, Database)

### Server Support and APIs
- Firebase
- -> Firebase/Auth for sign-in and authentication with Google or Facebook
- -> Firebase/Database for keeping track of users, their “money”, and other settings
- ->Users kept track of via email
- API’s
- -> createUser
- -> deleteUser
- -> setMoney
- -> setActiveUpgrade/setPassiveUpgrade
- -> setUsername
- -> More as needed

### Testing Plan
Phase 1
- Init testing on our side, and between the 4 of us,
Phase 2 - ~1 week
- Make a basic feedback form
- Close friends/available test subjects used as free labor
- Work on “beta” build whilst testing is occuring
Phase 3
- Larger testing phase
- After feedback from phase 2, do some internal testing after fixes, then test again


## Sprint Planning 2 [*February 18*]
### Leading up to this meeting, we:
- Finalized the app name **Cash Cow**
- Started a design document for information about design guidelines, third-party libraries, Firebase, and project descriptions
- Completed the Balsamiq wireframe
- Designed the Cash Cow logo
- Set up Firebase and login authentication
- Created controllers for Launch, Login/Signup, Home, and Clicker views
### Our incoming action items due *next Sprint Planning*:
- Achieve full functioning clicker that updates user income @Angie
- Finish user authentication stage @Bridget
- Set up Upgrades, Profile, and Settings view controllers @Rachel
- Brainstorm upgrade ideas that are feasible @Jarod
- Money and Upgrades class @Jarod @Angie

## Sprint Planning 1 [*February 11*]
### In this meeting, we:
- Finalized our project idea
- Segmented our project into milestones
- Delegated tasks to individual team members
- Structured task management through Discord and Trello
- Created a git repo
### Our incoming action items due *next Sprint Planning*:
- Complete and submit HW4
- Begin outlining code for project
- Draw out storyboard navigation of our application
- Assemble the basic clicker functionality
### Issues
None that we are aware of, but this may quickly change once we transition away from the planning stage.

