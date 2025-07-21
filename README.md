# Decentralized Public Pool Lifeguard Training Program

A blockchain-based system for managing lifeguard certification, training, and continuing education using Clarity smart contracts.

## Overview

This system provides a decentralized platform for managing all aspects of lifeguard training and certification, ensuring transparency, immutability, and efficient coordination of training programs.

## System Components

### 1. Certification Tracking Contract (`certification-tracker.clar`)
- Manages lifeguard certifications and renewal requirements
- Tracks certification status, expiration dates, and renewal history
- Handles certification issuance and revocation

### 2. Skills Assessment Contract (`skills-assessment.clar`)
- Evaluates rescue techniques and CPR proficiency
- Records assessment scores and competency levels
- Manages assessment scheduling and results

### 3. Training Schedule Coordination Contract (`training-scheduler.clar`)
- Manages instructor availability and class scheduling
- Coordinates training sessions and capacity management
- Handles booking and cancellation logic

### 4. Equipment Management Contract (`equipment-manager.clar`)
- Tracks rescue equipment and training materials
- Manages equipment allocation and maintenance schedules
- Handles equipment inventory and availability

### 5. Continuing Education Contract (`continuing-education.clar`)
- Coordinates ongoing safety training requirements
- Tracks continuing education credits and compliance
- Manages specialized training programs

## Key Features

- **Immutable Records**: All certifications and training records are permanently stored on the blockchain
- **Transparent Process**: Public verification of certification status and training completion
- **Automated Compliance**: Smart contract enforcement of renewal requirements and continuing education
- **Efficient Coordination**: Streamlined scheduling and resource management
- **Decentralized Governance**: Community-driven training standards and requirements

## Data Structures

### Lifeguard Profile
- Principal ID
- Certification level
- Certification date and expiration
- Training history
- Assessment scores
- Continuing education credits

### Training Session
- Session ID
- Instructor principal
- Date and time
- Capacity and enrolled count
- Training type and requirements
- Equipment needed

### Equipment Item
- Equipment ID
- Type and description
- Condition status
- Last maintenance date
- Current location
- Availability status

## Usage

### For Lifeguards
1. Register for training sessions
2. Complete skills assessments
3. Track certification status
4. Manage continuing education requirements

### For Instructors
1. Schedule training sessions
2. Conduct skills assessments
3. Issue certifications
4. Track student progress

### For Pool Administrators
1. Verify lifeguard certifications
2. Monitor training compliance
3. Manage equipment inventory
4. Coordinate training programs

## Installation

1. Install Clarinet CLI
2. Clone this repository
3. Run `clarinet check` to validate contracts
4. Run `npm test` to execute test suite
5. Deploy contracts using `clarinet deploy`

## Testing

The system includes comprehensive tests using Vitest:
- Unit tests for each contract function
- Integration tests for cross-contract interactions
- Edge case testing for error conditions
- Performance testing for large datasets

## Security Considerations

- Access control for sensitive operations
- Input validation for all user data
- Protection against common smart contract vulnerabilities
- Regular security audits and updates

## Contributing

Please read the PR-DETAILS.md file for contribution guidelines and development standards.

## License

This project is licensed under the MIT License.
