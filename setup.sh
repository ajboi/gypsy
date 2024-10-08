#!/bin/bash

# Initialize npm project
npm init -y

# Install necessary dependencies
npm install --save-dev electron@latest electron-builder@latest react react-dom react-scripts
npm install --save-dev concurrently wait-on cross-env

# Create a basic structure for your Electron app
mkdir public src
touch public/electron.js src/index.js src/App.js

# Create a basic HTML file
cat << EOF > public/index.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>GIPS Reporting Tool</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
EOF

# Create a basic React component
cat << EOF > src/App.js
import React from 'react';

function App() {
  return (
    <div>
      <h1>GIPS Reporting Tool</h1>
      <p>Welcome to your new desktop application!</p>
    </div>
  );
}

export default App;
EOF

# Set up the main React entry point
cat << EOF > src/index.js
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
EOF

# Set up the main Electron process file
cat << EOF > public/electron.js
const { app, BrowserWindow } = require('electron');
const path = require('path');
const isDev = require('electron-is-dev');

function createWindow() {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
    },
  });

  win.loadURL(
    isDev
      ? 'http://localhost:3000'
      : \`file://\${path.join(__dirname, '../build/index.html')}\`
  );

  if (isDev) {
    win.webContents.openDevTools({ mode: 'detach' });
  }
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});
EOF

# Update package.json with necessary scripts and configurations
npm pkg set scripts.start="react-scripts start"
npm pkg set scripts.build="react-scripts build"
npm pkg set scripts.test="react-scripts test"
npm pkg set scripts.eject="react-scripts eject"
npm pkg set scripts.electron="electron ."
npm pkg set scripts.dev="concurrently \"cross-env BROWSER=none npm start\" \"wait-on http://localhost:3000 && electron .\""
npm pkg set scripts.pack="electron-builder --dir"
npm pkg set scripts.dist="electron-builder"

npm pkg set build.appId="com.example.gipsreportingtool"
npm pkg set build.productName="GIPS Reporting Tool"
npm pkg set build.files[]=build/**/*
npm pkg set build.files[]=node_modules/**/*
npm pkg set build.files[]=public/electron.js
npm pkg set build.directories.output=dist
npm pkg set build.mac.target[]=dmg
npm pkg set build.mac.target[]=zip
npm pkg set build.mac.arch[]=arm64
npm pkg set build.mac.arch[]=x64

npm pkg set main="public/electron.js"

# Install additional dependency
npm install electron-is-dev

# Update .gitignore
cat << EOF > .gitignore
# Dependencies
/node_modules

# Production build
/build
/dist

# Misc
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Editor directories and files
.idea
.vscode
*.swp
*.swo
EOF

# Update README
cat << EOF > README.md
# GIPS Reporting Tool

This is a desktop application built with Electron and React for GIPS (Global Investment Performance Standards) reporting.

## Setup

1. Clone the repository
2. Run \`npm install\` to install dependencies
3. Run \`npm run dev\` to start the development server

## Features

(To be added as development progresses)

## Development

This project uses:
- Electron for desktop app functionality
- React for the user interface
- electron-builder for packaging and distribution

## Future Plans

(To be added)
EOF

echo "Setup complete. You can now run 'npm run dev' to start your application."