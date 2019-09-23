# Facebook Event Filter

Facebook [provides a way](https://www.facebook.com/help/152652248136178) to export and sync all your events to a third party calendar application such as Google Calendar, Apple Calendar or Outlook. However, they include events you have not responded to yet. This application allows you to filter events before importing them.

## Usage

You can either use my instance at https://fef.michalzajac.me or deploy it wherever you want.

## Deployment

Provided Dockerfile listens on port `4567`. If you are fine with that then just run `docker-compose up -d`. Otherwise edit `Dockerfile` and change the port.
