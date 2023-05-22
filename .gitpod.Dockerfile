# docker build --no-cache --progress=plain -f .gitpod.Dockerfile .
FROM gitpod/workspace-full

# System
RUN bash -c "sudo apt-get update"
RUN bash -c "sudo install-packages direnv gettext mysql-client"
