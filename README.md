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
├── dataset/                   # Contains larger datasets
│
├── misc/                      # Contains submissions at different stages
│
└── README.md                  # Project overview and directory structure

```


### Clone the repository

```bash
git clone https://github.dev/sudo-boo/dbis-proj.git
```

### Run Backend

Run the backend using:

```bash
node app.js
```

and then run the ngrok after successful running backend on port `5000`:

```bash
ngrok port 5000
```

and replace the `BASE_URL` in `.env` of each app in client with the new generated ngrok public url. 


### Run frontend

Build the individual apps using:

```bash
flutter build apk
```

in each respective directory.