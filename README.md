# Salesforce Order Management Template
Salesforce Order Management Template (SOMT) is a boilerplate template aims to reduce development time by using reusable module, increase and maintain code quality by running static code analyzer and implement best practices/principles.

Based on different topics, these are the items we are having or will have in the future for SOMT.

## One-Click Configuration Deployment
Every new project comes with some configurations that must be handled by developers in order to make Order Management (OM) work. These configurations are the same for every OM org but it takes developer’s time. In SOMT we have these configurations ready:
- Field Level Security (permissions set) configurations
- Layouts
- B2C Integration records (Product, Delivery Method, Payment Gateway etc.)

Benefits: 
- Reduces time (mostly 8H per org) for OM configuration
- Creates necessary records for B2C Integration and the integration becomes ready to be tested with one click

## Code Base
Salesforce projects will have code base that can be reusable in new projects regardless OM or not. Thus, we will have a standard and ready-to-go on development. In SOMT we have these modules ready which covers the most of the development requirements:
- Logging & error management
- DML & callout management
- Utils classes for: Http, Parsing, OM APIs and enums

Benefits:
- Reduces significant development time  for base/infastructure code
- Independant modules are easy to grab and use it in new projects
- All the code are covered by unit tests (mostly 100% cover lines)

## Static Code Analyzer
SOMT project has necessary files and configurations for static code analyzer. Static code analyzer (SCA) improves the code quality and maintains the code by checking pull requests/commits and running unit tests in sandbox and printing out the violations in comment section as running official Salesforce Scanner plugin. SCA is already integrated with GitHub repository.

Static Code Analyzer Architecture
![image](https://user-images.githubusercontent.com/15785611/116583329-e7eb4280-a91e-11eb-8da5-65b692eacf12.png)
Benefits:
- SCA is integrated with GitHub repository and ready-to-go with one click
- SCA will also be available on developer’s machine with necessary configurations
- Prevents security, performance issues and bugs in the future by running analyzer on every GitHub pull request/commit and let the team know by notifications
- Custom rules can be defined by the team and can be implemented to project
- Runs unit tests and lint for both Apex and JavaScript (Lightning Web and Visualforce) code

## Roadmap and Ideas

| Idea/Feature  | Tag           | Priority/Impact |
| ------------- | ------------- | --------------- |
| Modules related to Order Management domain | APEX | HIGH |
| Implements new features of v52.0 (Summer ’21) | APEX | HIGH |
| Base integration modules/configurations for popular 3rd party systems e.g. Mirakl, Adyen | APEX | MEDIUM |
| Improve GitHub action (SCA) by adding SFDX commands | CI-CD AUTOMATION | LOW |
