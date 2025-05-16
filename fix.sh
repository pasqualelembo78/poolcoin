#!/bin/bash

echo ">>> Pulizia directory corrotta..."
rm -rf node_modules/form-data

echo ">>> Rimozione completa di node_modules e package-lock.json..."
rm -rf node_modules package-lock.json

echo ">>> Reinstallazione delle dipendenze..."
npm install

echo ">>> Installazione manuale di form-data, mailgun.js e nodemailer..."
npm install form-data mailgun.js nodemailer

echo ">>> Completato!"
