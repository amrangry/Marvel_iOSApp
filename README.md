# Marvel_iOSApp
## Demo for Marvel's Characters ##

```ruby
A picture says a thousand words
```

![Alt text](https://github.com/amrangry/Marvel_iOSApp/blob/master/logo.png?raw=true "sample")

### Prerequisites
1 - You need to setup pod first before you can run to do that follow the following 

```
* open terminal from finder
* $ cd ../Project folder 
* $ pod setup
* $ pod install

```

2- Replace keys with your keys **ParentUIViewController.h**
```
#define public_key @"<your public key>"
#define private_key @"<your private key>"

```

# Application Description / Details:
Using this application, users will be able to browse through the Marvel
library of characters. 
The data is available by connecting to the Marvel API
(http://developer.marvel.com/).

You should use the following mockup and assets as a base for this challenge:
iOS:
https://marvelapp.com/279b309  
assets: http://bit.ly/1LcMgwO


# Story
List of Characters
In this view, you should present a list of characters loaded from the Marvel
API character index. Notice that the when reaching the end of the list, if there
are additional results to show, you should load and present the next page.
Filter Results
When tapping on the magnifier icon, you should be able to search for
characters by name. To do this, use the same endpoint used to list characters
and use the name param to filter results.

Character Details
When selecting a character, you should present a detail view of that
character. Most of this information is already available on the result of the
first API call, except for the images to be presented on the
comics/series/stories/events sections. Those images can be fetched from the
resourceURI and should be lazy loaded. That same behavior is expected
when expanding those images.

<p align="center">
<img style="-webkit-user-select: none;" src="https://github.com/amrangry/Marvel_iOSApp/blob/master/first1.png?raw=true">
</p>


## **Author**

<div align="center">
  <img src="https://avatars.githubusercontent.com/u/2900952?s=400&u=41c504ca200e2f92638fc630e8361da78296b35c&v=4" width="180" alt="Amr Ahmed Elghadban"/>

  **Amr Ahmed Elghadban (AmrAngry)**

[![Email](https://img.shields.io/badge/Email-Contact%20Me-red?logo=gmail)](mailto:amr.elghadban@gmail.com) [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/amrelghadban/)

[![WhatsApp](https://img.shields.io/badge/whatsapp-00971543233227-green?logo=whatsapp)](https://api.whatsapp.com/send/?phone=00971543233227&text=Hi%20&app_absent=0)

[![GitHub](https://img.shields.io/badge/GitHub-Profile-blue?logo=github)](https://github.com/amrangry) [![StackOverflow](https://img.shields.io/badge/StackOverflow-Profile-orange?logo=stackoverflow)](https://stackoverflow.com/users/1316779/amrangry)

[![Twitter (formerly Twitter)](https://img.shields.io/badge/Twitter-@amr_elghadban-blue?logo=twitter)](https://x.com/intent/follow?screen_name=amr_elghadban) [![Facebook](https://img.shields.io/badge/Facebook-Profile-blue?logo=facebook)](https://facebook.com/amr.elghadban) [![Website](https://img.shields.io/badge/Website-Visit%20Me-blue?logo=globe)](https://amrangry.github.io/)
       <div align="center" >
	       <a href = "https://www.buymeacoffee.com/amrangry">
		    <img src = "https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=your-username&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff"/>
                </a>
       </div>
  <!--  [![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-Support%20Me-yellow?logo=buymeacoffee)](https://www.buymeacoffee.com/amrangry) -->
  <!--  [Email](mailto:amr.elghadban@gmail.com?subject=I%20checked%20your%20GitHub%20repo!): [amr.elghadban@gmail.com](mailto:amr.elghadban@gmail.com) -->
  <!-- [![Linkedin](https://img.shields.io/badge/Lets%20Connect%20via-LinkedIn-blue)](https://www.linkedin.com/in/amrelghadban/) -->
  <!-- [![X (formerly Twitter) Follow](https://img.shields.io/twitter/follow/amr_elghadban)](https://x.com/intent/follow?screen_name=amr_elghadban) -->
  
</div>
## **Contributing 🤘**

All your feedback and help to improve this project is very welcome. 
Please create issues for your bugs, ideas and enhancement requests, or better yet, contribute directly by creating a PR. 😎

When reporting an issue, please add a detailed instruction, and if possible a code snippet or test that can be used as a reproducer of your problem. 💥

When creating a pull request, please adhere to the current coding style where possible, and create tests with your code so it keeps providing an awesome test coverage level 💪


## **Code of Conduct**

I’m here to share my knowledge and findings as I work every day to improve our apps/demos for the community.

This is a space where we work together, openly and safely, as kind and considerate human beings.

We grow by giving and receiving positive, constructive feedback.
 
Let’s keep learning and building, one step at a time.


## **License**

<details>
<summary><strong>MIT License</strong></summary>
<p>
Marvel_iOSApp is distributed under the MIT License.  
For more information, see the <a href="https://github.com/amrangry/Marvel_iOSApp/blob/master/LICENSE" target="_blank">LICENSE</a> file.  

&copy; 2025 Amr Elghadban  
All rights reserved.
</p>
</details>


