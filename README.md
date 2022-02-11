# smartgym_web_app 🌐

Smartgym web app to enhance user's login!

## Preview

![Architecture](page_preview.png)

## Build the docker image
Use docker build the container image
```
 docker build -f Dockerfile -t smartgym_web_app .
```
## After Success building image
Run the docker image with localhost 1200 port. You can change to any other port just replace it.

```
 docker run -d -p 1200:80 --name container_name smartgym_web_app
```