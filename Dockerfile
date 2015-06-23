FROM node:0.10

ENV VIRTUAL_HOST zsbwx.neau.edu.cn

EXPOSE 80

WORKDIR /src

CMD ["npm", "start"]

