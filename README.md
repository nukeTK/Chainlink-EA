## Guide to Build an External Adapter that bridges to a Chainlink Oracle Node so that your smart contracts can fetch arbitrary data from an external API.

### IMPORTANT FLOW DIAGRAM

## FOLLOW THESE STEPS

### STEP 1

    Build external adapter to fetch data from api and response data back to contract with correct structure

    for example we are getting data in the form of this

    API - https://fortniteapi.io/v1/lookup?username=Ninja

    ```
    {
    "result": true,
    "account_id": "4735ce9132924caf8a5b17789b40f79c"
    }

    ```
    External adapter returns data in the following structure

    ```
    returned response:   {
        jobRunId: '0x93fd920063d2462d8dce013a7fc75656', // This is come from node
        statusCode: 200,
        data: {
             "account_id": "4735ce9132924caf8a5b17789b40f79c"
        }
    }
    ```

### STEP 2 Run a chainlink node locally 

    Install the docker desktop
    https://www.docker.com/products/docker-desktop/
    
    Install the postgresql(Must)
    https://www.postgresql.org/

    After this you need to create an .env file inside your project folder

    Enter the following info , remember sslmode must be true if you are not running node locally
    ```
    LOG_LEVEL=debug
    ETH_CHAIN_ID=5 //Specify the chain id where you are going to run chainlink node // In my case i am running on Goerli
    CHAINLINK_TLS_PORT=0
    SECURE_COOKIES=false
    ALLOW_ORIGINS=*
    SKIP_DATABASE_PASSWORD_COMPLEXITY_CHECK=true //optional
    ETH_URL=wss://eth-goerli.g.alchemy.com/v2/<API-KEY> // Ethereum Node address 
    //In Database section, check the password  and port under inspect section, local port might be different from 5432
    DATABASE_URL=postgresql://<Username>:<password>@host.docker.internal:<PORT>/postgres?sslmode=disable
    ```
    //Open the git bash, and run this command, in windows you have to use winpty to run docker command, just navigate through directory of   
      yours 
    winpty docker run -v ~/chainlink -it --env-file=.env -p 6688:6688 --add-host=host.docker.internal:host-gateway              
    smartcontract/chainlink:1.11.0 <- Version 

    NOTE: If Docker desktop not running on windows you need to install "linux subsystem for windows" from microsoft store, to run certain    
          docker files  
          after running the chainlink node it will ask for email id and 16 character pasword that is alter use for signing in for the node   

### Step 3 Deploying both the contracts
    1. Deploy the Operator & Consumer contract, Operator contract ask for link token address and the address of your wallet(owners)
    2. Fund the consumer contract with some link tokens
    3. Also fund the chainlink node address with some goerli eth or network you deployed on
        and copy the same address, and paste into the "setAuthorizedSenders" function in operator contract so the oracle contract fetch the 
        data. 


### Step 4 Setup the chainlink node
    URL:- http://localhost:6688 for chainlink node

    1. Create a bridge, so enter the name of bridge and the docker link which is http://host.docker.internal:8080 
    2. Create a job 
    3. Run the Cosumner contract Function to call the external adapter to fetch the data.

NOTE: It will take time to complete a job, max 10 mins so wait for it and check the job on chainlink node whether you are getting error or  
      not also it will show suspended first later it will be completed.

## Thank you




