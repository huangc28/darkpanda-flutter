## TODOs 

- [x] Click on each inquiry avatar would open inquiry detail.
- [] Female user is able to pick up an inquiry by clicking on `pickup` button. The server will attempt to create an inquiry chat between the two (male and female).
  
  
## Create an inquiry chat between Male / Female users 

PubNub instance should be initialized at the start of the application. PuNub credentials should be pull in from the environment varialbes.

Once female user has successfully picked up an inquiry, it should perform the following things:
  - Subscribe to a pubnub channel. We should maintain a map of channel_uuid : subscription in `picked_inquiry`  bloc.