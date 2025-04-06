# DBIS Project

## Getting Started

This contains all of our solution's source code. The project is a mono repo, meaning all the code is in one repository. This makes managing dependencies and sharing code between different project parts easier.

### ngrok

To run the server on a public URL/IP, we use ngrok. Basically, what it does is redirects the requests from a localhost port to a public API endpoint.

<hr>

## Directory Structure

```bash
/
│
├── src/
│   ├── client/                # Frontend Flutter application (customer, vendor, delivery)
│   │   ├── customer/
│   │   ├── delivery/
│   │   └── vendor/
│   │
│   └── server/                # Backend Node.js
│
├── test/                      # Contains larger datasets and tests to
│                              # Test the performance of the system
│
├── Dockerfile                 # Dockerfile for containerizing the project
├── README.md                  # Project overview and setup instructions
└── .gitignore                 # Files and directories to ignore in Git

```