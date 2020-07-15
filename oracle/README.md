# Go Ethereum event listener
- Build docker container
> docker build -t tag/name .

> docker run --name name <USER/TAG>

> docker run --name <NAME> <USER/TAG> --ropsten --syncmode light --rpcapi "db,eth,net,web3,personal" --ws --wsaddr "localhost" --wsport "8545" --wsorigins "*" --identity "listener"

- To run container after being built
> docker start <name>

- Get a shell into container
> docker exec -it <NAME> /bin/sh
- Notes on container
  The container currently starts geth when it is started, but it does NOT start the event listener yet you should shell into the container to start it and monitor its logs, to do so simply run the listen command 
> listen

