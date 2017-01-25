## Deployment

```bash
# get your API token from digitalocean dashboard
DO_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# create a docker-machine using the digitalocean driver
docker-machine create --driver digitalocean --digitalocean-access-token=$DO_TOKEN --digitalocean-size=1gb digitalocean

# make the machine active
docker-machine env digitalocean
eval $(docker-machine env digitalocean)

# deploy the services
docker-compose up -d

# make changes to rails code... redeploy by running
docker-compose up -d --no-deps --build app

# and we are live!
open http://`docker-machine ip`

# shut stuff down
docker-machine stop digitalocean
docker-machine rm digitalocean
```
