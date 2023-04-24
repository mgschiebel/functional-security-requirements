# Functional Security Requirements

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Project Description

Functional Security Requirements is an open source project that provides a collection of Gherkin feature files containing scenario outlines for testing security requirements. It also includes mocked up step scenarios in multiple programming languages that developers can use as reference implementations when implementing the scenario outlines. It aims to provide a comprehensive library of reusable example Gherkin scenarios that can be used for security testing of software applications.

## Installation Instructions

To use the Functional Security Requirements project, simply clone the repository to your local machine using the following command:

```
git clone https://github.com/mgschiebel/functional-security-requirements.git
```

## Usage

The Functional Security Requirements project provides a library of Gherkin feature files that contain scenario outlines. These feature files can be used with popular BDD (Behavior-Driven Development) frameworks, such as Cucumber, to write and execute security tests for your software applications.

These feature files are organized into directories based on the security requirements being tested. Each directory contains a Gherkin feature file that includes multiple scenario outlines. In addition, each directory in the project structure also includes language-specific example mock step files in sub-directories. These step files are available in multiple programming languages, such as [Java](examples/java), [Python](examples/python), and [Ruby](examples/ruby), and can be used as reference implementations when implementing the scenario outlines. These examples can serve as a starting point for writing step definitions in your preferred programming language.

To use the scenarios in your project, simply include the relevant feature files in your test suite, based on the security requirements you want to test. For example, if you want to test authentication-related security requirements, you can include the `authentication.feature` file in your test suite. You can customize the scenarios to suit your specific security requirements and integrate them into your existing testing workflow.

For more information on how to write and execute Gherkin scenarios with step definitions, please refer to the documentation or user guides provided in the [Documentation](docs/) folder of this project.

## Contributing

We welcome contributions to the Functional Security Requirements project! If you're interested in contributing, please follow our [Contributing Guidelines](CONTRIBUTING.md) in the [Documentation](docs/) to get started. We appreciate bug reports, feature requests, documentation improvements, and code contributions.

## License

This project is released under the [MIT License](LICENSE). Please review the license file for terms and conditions.

## Documentation

For more information, please refer to the [Documentation](docs/) folder for user guides, or other resources that can help users understand and use the Functional Security Requirements project effectively.

## Roadmap

Our future plans for the Functional Security Requirements project include expanding the library of Gherkin scenarios to cover more security requirements and improving the documentation to make it more comprehensive and user-friendly.

## Contact Information

If you have any questions, feedback, or suggestions, please feel free to reach out to us at mike.schiebel+fsr@gmail.com.

## Acknowledgements

We would like to express our gratitude to all the contributors, organizations, and communities that have contributed to the Functional Security Requirements project. Thank you for your support!

## Changelog

For a list of changes, updates, and bug fixes for each version of the Functional Security Requirements project, please refer to the Github version history and commit messages.
